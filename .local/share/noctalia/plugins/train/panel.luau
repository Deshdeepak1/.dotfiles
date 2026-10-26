-- Train lookups with the train script: a page per subject, a tab per lookup, results as tables whose
-- trains and stations open their own lookups. noctalia msg panel-open local/train:panel [query]
local CLASSES = { "1A", "2A", "3A", "CC", "FC", "SL", "2S", "3E", "GN", "EA", "EC", "EV", "VC", "VS" }
local QUOTAS = { "GN", "TQ", "PT", "LD", "DF", "FT", "SS", "YU", "DP", "HP", "PH" }
local KINDS = { "RAJ", "SHT", "JSHT", "DUR", "GRB", "SF", "EXP", "PASS", "PRM", "T18", "HMS" }

-- form fields; a query word that names a field takes its value, any other word is literal
local FIELDS = {
    train = { hint = "Train no.", width = 130 },
    pnr = { hint = "10-digit PNR", width = 200 },
    name = { hint = "Train name", width = 260 },
    from = { hint = "From station", width = 220, station = true },
    to = { hint = "To station", width = 220, station = true },
    station = { hint = "Station", width = 220, station = true },
    date = { date = true, width = 300 },
    cls = { options = CLASSES, width = 100 },
    quota = { options = QUOTAS, width = 100 },
    kind = { options = KINDS, width = 120 },
    period = { chips = { "1w", "1m", "3m", "6m", "1y" }, width = 280 },
}
local DEFAULTS = { cls = "3A", quota = "GN", period = "1m", kind = "RAJ" }
local OPTIONAL = { date = true, quota = true, period = true }
-- lookups refreshed every two minutes while shown
local LIVE = { live = true, station_live = true }
-- table cells built per render; a callback has 12ms, about a thousand cells
local CELLS = 480
-- table width in the panel; a long column narrows to no less than SQUEEZE before columns move to another view
local TABLE, SQUEEZE = 690, 112

-- query: the train command's words; args: fields in the order the script reports them, when not the query's
local PAGES = {
    { id = "journey", label = "Journey", glyph = "route", views = {
        { label = "Trains", service = "between", query = { "from", "to", "date" } },
        { label = "Change at", service = "transit", query = { "from", "to", "via" } },
    } },
    { id = "train", label = "Train", glyph = "train", views = {
        { label = "Route", service = "route", query = { "train" } },
        { label = "Live", service = "live", query = { "train", "live", "date" } },
        { label = "Coaches", service = "coaches", query = { "train", "coaches" } },
        { label = "Fare", service = "fare", query = { "train", "fare", "from", "to" }, optional = { from = true, to = true } },
        { label = "Seats", service = "seats", query = { "train", "seats", "from", "to", "cls", "date", "quota" },
          args = { "train", "from", "to", "cls", "quota", "date" } },
        { label = "Delays", service = "history", query = { "train", "history", "period" } },
        { label = "Alerts", service = "alerts", query = { "train", "alerts" } },
        { label = "Map", service = "route_map", query = { "train", "map" } },
    } },
    { id = "station", label = "Station", glyph = "map-pin", views = {
        { label = "Live", service = "station_live", query = { "station", "live" } },
        { label = "All trains", service = "timetable", query = { "station", "all", "date" } },
    } },
    { id = "pnr", label = "PNR", glyph = "ticket", views = {
        { label = "Status", service = "pnr", query = { "pnr" } },
    } },
    { id = "find", label = "Find", glyph = "search", views = {
        { label = "By name", service = "search", query = { "name" } },
        { label = "By type", service = "type_list", query = { "list", "kind" } },
    } },
}

local home = noctalia.getenv("HOME")
local WATCH, STATE = home .. "/.cache/train/watch", noctalia.pluginDataDir() .. "/state.json"

local S = { page = "train", views = {}, f = {}, provider = "", cols = 1, first = 1 }
local services, recent, watched = {}, {}, {}
local seed, latest, typed = 0, 0, 0
local render, run

local saved = noctalia.fileExists(STATE) and noctalia.json.decode(noctalia.readFile(STATE))
if saved then S.page, S.views, S.f = saved.page, saved.views, saved.f end
for name in FIELDS do S.f[name] = S.f[name] or DEFAULTS[name] or "" end

local function str(v) return type(v) == "string" and v or type(v) == "number" and tostring(v) or "" end

local function current()
    for _, page in PAGES do
        if page.id == S.page then return page, page.views[S.views[page.id] or 1] end
    end
    return PAGES[1], PAGES[1].views[1]
end

local function missing(view)
    local out = {}
    for _, w in view.query do
        local field = FIELDS[w]
        if field and S.f[w] == "" and not OPTIONAL[w] and not (view.optional or {})[w] then
            table.insert(out, field.hint or w)
        end
    end
    return out
end

local function words(view)
    local out = {}
    for _, w in view.query do
        local v = if FIELDS[w] then S.f[w] else w
        if v ~= "" then table.insert(out, v) end
    end
    return out
end

-- Show the page and fields of the lookup the script answered, so a typed query lands in its form.
local function adopt(r)
    for _, page in PAGES do
        for i, view in page.views do
            if view.service == r.service then
                S.page, S.views[page.id] = page.id, i
                for n, name in view.args or view.query do
                    if FIELDS[name] then
                        local v = str((r.args or {})[n])
                        local y, m, d = v:match("^(%d+)-(%d+)-(%d+)$")
                        S.f[name] = if y then d .. "-" .. m elseif v ~= "" then v else DEFAULTS[name] or ""
                    end
                end
                seed += 1
                return
            end
        end
    end
end

local function loadSide()
    noctalia.runAsync({ "train", "--history" }, function(res)
        recent = {}
        for q in str(res.stdout):gmatch("[^\n]+") do
            if #recent < 10 then table.insert(recent, q) end
        end
        watched = noctalia.listDir(WATCH) or {}
        render()
    end)
end

function run(ws, quiet)
    latest += 1
    local id = latest
    S.words, S.busy, S.error, S.suggest = ws, true, nil, nil
    if not quiet then S.result, S.first, S.cols = nil, 1, 1 end
    render()
    local argv = { "train", "-j" }
    if S.provider ~= "" then table.insert(argv, "-p"); table.insert(argv, S.provider) end
    for _, w in ws do table.insert(argv, w) end
    noctalia.runAsync(argv, function(res)
        if id ~= latest then return end -- a newer lookup is running
        S.busy, S.at = false, os.time()
        local r = noctalia.json.decode(str(res.stdout))
        if r and r.title then
            S.result = r
            adopt(r)
            loadSide()
        else
            S.result = nil
            S.error = r and r.error or "Not a lookup: " .. table.concat(ws, " ")
        end
        render()
    end)
end

-- A query from outside the form (typed, recent, opened with); its own provider list applies.
local function ask(q)
    local ws = {}
    for w in q:gmatch("%S+") do table.insert(ws, w) end
    if #ws == 0 then return end
    S.provider = ""
    run(ws)
end

local function submit()
    local _, view = current()
    local need = missing(view)
    if #need > 0 then
        S.error = "Fill in: " .. table.concat(need, ", ")
        return render()
    end
    run(words(view))
end

-- Switch page or tab, running it at once when its form is already filled.
local function go(page, view)
    S.page, S.views[page] = page, view or S.views[page] or 1
    S.provider, S.result, S.error, S.suggest = "", nil, nil, nil
    seed += 1
    local _, v = current()
    if #missing(v) == 0 then run(words(v)) else render() end
end

local function open(kind, value)
    if kind == "train" then S.f.train = value; go("train", 1) else S.f.station = value; go("station", 1) end
end

-- Station suggestions, ranked by the script the way it resolves a typed station.
local function suggest(name, text)
    typed += 1
    local id = typed
    if #text < 2 then S.suggest = nil; return render() end
    noctalia.runAsync({ "train", "--stations", text }, function(res)
        if id ~= typed then return end -- typed on since
        local items = {}
        for line in str(res.stdout):gmatch("[^\n]+") do
            local code, station = line:match("^([^,]+),(.*)$")
            if code then table.insert(items, { code = code, name = station }) end
        end
        S.suggest = if #items > 0 then { field = name, items = items } else nil
        render()
    end)
end

-- Widgets

local function field(name)
    local spec, f = FIELDS[name], S.f
    local function set(v) f[name] = v; seed += 1; render() end
    if spec.options then
        return ui.select({
            options = spec.options, selectedIndex = (table.find(spec.options, f[name]) or 1) - 1, width = spec.width,
            onChange = function(i) f[name] = spec.options[tonumber(i) + 1]; render() end,
        })
    elseif spec.chips then
        local chips = {}
        for _, c in spec.chips do
            table.insert(chips, ui.button({ text = c, controlSize = "sm", selected = f[name] == c, onClick = function() set(c) end }))
        end
        return ui.row({ gap = 4, align = "center" }, chips)
    elseif spec.date then
        local today, tomorrow = os.date("%d-%m"), os.date("%d-%m", os.time() + 86400)
        local function chip(label, v)
            return ui.button({ text = label, controlSize = "sm", selected = f.date == v, onClick = function() set(if f.date == v then "" else v) end })
        end
        return ui.row({ gap = 4, align = "center" }, {
            chip("Today", today), chip("Tomorrow", tomorrow),
            ui.input({ key = "date-" .. seed, value = f.date, placeholder = "dd-mm", width = 90, controlSize = "sm",
                onChange = function(v) f.date = v end, onSubmit = submit }),
        })
    end
    return ui.input({
        key = name .. "-" .. seed, value = f[name], placeholder = spec.hint, width = spec.width,
        onChange = function(v) f[name] = v; if spec.station then suggest(name, v) end end,
        onSubmit = submit,
    })
end

-- the view's fields, flowed into rows that fit, with a swap between from and to, then Search
local function form(view)
    local rows, row, width = {}, {}, 0
    local function add(node, w)
        if width + w > 700 and #row > 0 then table.insert(rows, ui.row({ gap = 8, align = "center" }, row)); row, width = {}, 0 end
        table.insert(row, node)
        width += w + 8
    end
    for _, w in view.query do
        if FIELDS[w] then
            add(field(w), FIELDS[w].width)
            if w == "from" and table.find(view.query, "to") then
                add(ui.button({ glyph = "arrows-exchange", variant = "ghost", tooltip = "Swap",
                    onClick = function() S.f.from, S.f.to = S.f.to, S.f.from; seed += 1; render() end }), 38)
            end
        end
    end
    add(ui.button({ text = "Search", glyph = "search", variant = "primary", onClick = submit }), 110)
    table.insert(rows, ui.row({ gap = 8, align = "center" }, row))
    if S.suggest then
        local picks = {}
        for _, s in S.suggest.items do
            table.insert(picks, ui.button({ text = s.name .. " · " .. s.code, controlSize = "sm", variant = "outline",
                onClick = function() S.f[S.suggest.field] = s.code; S.suggest = nil; seed += 1; render() end }))
        end
        table.insert(rows, ui.row({ gap = 6 }, picks))
    end
    return ui.column({ gap = 8 }, rows)
end

local BAD = { "^%+%d", "wl%d", "cancel", "regret", "divert", "not avail" }
local GOOD = { "on time", "^avl", "cnf", "available" }
local function tone(text)
    local l = text:lower()
    for _, p in BAD do if l:find(p) then return "error" end end
    if l:find("^rac") then return "#e0a84a" end
    for _, p in GOOD do if l:find(p) then return "primary" end end
    return nil
end

-- each column's width for its longest cell
local function natural(r)
    if r.widths then return r.widths end
    r.widths = {}
    for i, c in r.columns do
        local n = utf8.len(c) or 0
        for _, row in r.rows do n = math.max(n, utf8.len(str(row[i])) or 0) end
        r.widths[i] = math.clamp(n * 8 + 16, 40, 280)
    end
    return r.widths
end

-- the widest width every column can be held to so they fit; longer ones ellipsize
local function cap(r, cols)
    local w, c = natural(r), 280
    local function total() local t = 0; for _, i in cols do t += math.min(w[i], c) end; return t end
    while c > SQUEEZE and total() > TABLE do c -= 4 end
    return c, total() <= TABLE
end

-- the columns split into views that fit, detail last; each view keeps the first two (number and name)
local function views(r)
    local key = {}
    for i = 1, math.min(2, #r.columns) do table.insert(key, i) end
    local out, cur, detail = {}, table.clone(key), r.detail or {}
    local function add(i)
        table.insert(cur, i)
        if #cur > #key + 1 and not select(2, cap(r, cur)) then
            table.remove(cur)
            table.insert(out, cur)
            cur = table.clone(key)
            table.insert(cur, i)
        end
    end
    for i, c in r.columns do if i > #key and not table.find(detail, c) then add(i) end end
    for i, c in r.columns do if i > #key and table.find(detail, c) then add(i) end end
    table.insert(out, cur)
    return out
end

local function resultTable(r, shown, first, last)
    local widths, c = {}, cap(r, shown)
    for _, i in shown do widths[i] = math.min(natural(r)[i], c) end
    local function cells(row, header)
        local out = {}
        for _, i in shown do
            local text, link = str(row[i]), not header and (r.links or {})[r.columns[i]]
            table.insert(out, ui.row({ width = widths[i], onClick = link and text ~= "" and function() open(link, text) end or nil }, {
                ui.label({ text = text, maxWidth = widths[i] - 8, maxLines = 1, fontWeight = header and "bold" or nil,
                    color = if link then "primary" elseif header then nil else tone(text) }),
            }))
        end
        return out
    end
    local rows = { ui.row({ paddingV = 6, paddingH = 8 }, cells(r.columns, true)) }
    for n = first, last do
        local row = r.rows[n]
        table.insert(rows, ui.row({ key = "r" .. n, paddingV = 5, paddingH = 8, radius = 6,
            fill = if n % 2 == 1 then "surface_variant/0.35" else nil }, cells(row)))
    end
    return rows
end

local function result()
    if S.error then
        local lines = {}
        for part in str(S.error):gmatch("[^;]+") do table.insert(lines, ui.label({ text = noctalia.string.trim(part), color = "error", maxWidth = 720 })) end
        return { ui.column({ gap = 4, padding = 12, radius = 10, fill = "error/0.12" }, lines) }
    end
    local r = S.result
    if not r then
        return { ui.label({ text = if S.busy then "Looking up " .. table.concat(S.words, " ") .. "…" else "Fill in the form and press Enter.", color = "on_surface_variant" }) }
    end
    local all = views(r)
    local shown = all[math.min(S.cols, #all)]
    local function copy()
        local lines = { r.title }
        for _, row in { r.columns, table.unpack(r.rows) } do
            local cells = {}
            for _, i in shown do table.insert(cells, str(row[i])) end
            table.insert(lines, table.concat(cells, "\t"))
        end
        noctalia.copyToClipboard(table.concat(lines, "\n"), "text/plain")
    end
    local actions = {
        ui.label({ text = (if S.busy then "updating… · " else "") .. os.date("%H:%M", S.at), color = "on_surface_variant" }),
        ui.button({ glyph = "refresh", variant = "ghost", tooltip = "Refresh", onClick = function() run(S.words, true) end }),
        ui.button({ glyph = "copy", variant = "ghost", tooltip = "Copy as text", onClick = copy }),
    }
    if #all > 1 then
        table.insert(actions, 1, ui.button({ text = "Columns " .. S.cols .. "/" .. #all, glyph = "columns", controlSize = "sm", variant = "outline",
            tooltip = "Next columns", onClick = function() S.cols = S.cols % #all + 1; render() end }))
    end
    if r.service == "pnr" then
        local pnr, on = S.f.pnr, table.find(watched, S.f.pnr) ~= nil
        table.insert(actions, 1, ui.button({ text = if on then "Unwatch" else "Watch", glyph = if on then "eye-off" else "eye", controlSize = "sm",
            tooltip = "Notify on any change until the journey",
            onClick = function() noctalia.runAsync({ "train", if on then "-u" else "-w", pnr }, function() loadSide() end) end }))
    end
    local out = {
        ui.row({ gap = 8, align = "center" }, {
            ui.label({ text = str(r.title), fontSize = 16, fontWeight = "bold", flexGrow = 1, maxLines = 1 }),
            table.unpack(actions),
        }),
    }
    for _, note in r.notes or {} do table.insert(out, ui.label({ text = str(note), color = "on_surface_variant", maxWidth = 740 })) end
    if #shown > 0 and #r.rows > 0 then
        local size = math.max(10, CELLS // #shown)
        local first = math.min(S.first, #r.rows)
        local last = math.min(first + size - 1, #r.rows)
        for _, row in resultTable(r, shown, first, last) do table.insert(out, row) end
        if #r.rows > size then
            local function turn(by) S.first = math.clamp(first + by * size, 1, #r.rows); render() end
            table.insert(out, ui.row({ gap = 4, align = "center", paddingV = 6 }, {
                ui.spacer({ flexGrow = 1 }),
                ui.label({ text = first .. "–" .. last .. " of " .. #r.rows, color = "on_surface_variant" }),
                ui.button({ glyph = "chevron-left", variant = "ghost", enabled = first > 1, onClick = function() turn(-1) end }),
                ui.button({ glyph = "chevron-right", variant = "ghost", enabled = last < #r.rows, onClick = function() turn(1) end }),
            }))
        end
    end
    return out
end

local function sidebar()
    local items = {
        ui.input({ key = "quick", placeholder = "Quick query", focus = true, onSubmit = ask }),
    }
    for _, page in PAGES do
        table.insert(items, ui.button({ text = page.label, glyph = page.glyph, contentAlign = "start",
            variant = if page.id == S.page then "primary" else "ghost", onClick = function() go(page.id) end }))
    end
    local function section(title, list, onClick)
        if #list == 0 then return end
        table.insert(items, ui.separator({}))
        table.insert(items, ui.label({ text = title, fontSize = 12, color = "on_surface_variant" }))
        for _, q in list do
            table.insert(items, ui.button({ text = q, controlSize = "sm", contentAlign = "start", variant = "ghost", onClick = function() onClick(q) end }))
        end
    end
    section("Watching", watched, function(pnr) S.f.pnr = pnr; go("pnr") end)
    section("Recent", recent, ask)
    return ui.scroll({ width = 210, gap = 4, padding = 10, radius = 12, fill = "surface_variant/0.4" }, items)
end

function render()
    local page, view = current()
    local tabs = {}
    for i, v in page.views do
        table.insert(tabs, ui.button({ text = v.label, controlSize = "sm", variant = if v == view then "secondary" else "ghost",
            onClick = function() go(page.id, i) end }))
    end
    -- the provider chosen, else the one that answered, else the one tried first; picking one reruns the lookup with it
    local providers = services[view.service] or {}
    local shown = if S.provider ~= "" then S.provider else str(S.result and S.result.provider)
    if not table.find(providers, shown) then shown = providers[1] end
    table.insert(tabs, ui.spacer({ flexGrow = 1 }))
    table.insert(tabs, ui.select({ options = providers, selectedIndex = (table.find(providers, shown) or 1) - 1, width = 130, controlSize = "sm",
        onChange = function(i)
            local p = providers[tonumber(i) + 1]
            if not p or p == shown then return end
            S.provider = p
            if S.result then run(S.words) else render() end
        end }))
    table.insert(tabs, ui.button({ glyph = "close", variant = "ghost", tooltip = "Close", onClick = function() panel.close() end }))
    panel.render(ui.row({ gap = 16, flexGrow = 1 }, {
        sidebar(),
        ui.column({ flexGrow = 1, gap = 12 }, {
            ui.row({ gap = 4, align = "center" }, tabs),
            form(view),
            ui.separator({}),
            ui.scroll({ flexGrow = 1, gap = 2 }, result()),
        }),
    }))
end

function update()
    if S.result and LIVE[S.result.service] and not S.busy and os.time() - S.at >= 120 then run(S.words, true) end
end

function onOpen(query)
    panel.setWantsSecondTicks(true)
    seed += 1
    if next(services) == nil then
        noctalia.runAsync({ "train", "--services" }, function(res)
            services = noctalia.json.decode(str(res.stdout)) or {}
            render()
        end)
    end
    loadSide()
    if query and query ~= "" then ask(query) else render() end
end

function onClose()
    noctalia.writeFile(STATE, noctalia.json.encode({ page = S.page, views = S.views, f = S.f }))
end
