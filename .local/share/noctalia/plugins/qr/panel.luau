-- noctalia msg panel-open local/qr:panel <text>; Enter re-encodes, click the code to copy it.
local img, n = nil, 0

local function clear()
    if img then noctalia.removeFile(img) end
    img = nil
end

-- seed: input key, new per open so the box takes the new text (inputs keep typed text across renders).
local function show(text, seed)
    n += 1
    -- Unique name: images are cached by path, so reusing one would show the old code.
    local path = noctalia.pluginDir() .. "/qr-" .. os.time() .. "-" .. n .. ".png"
    noctalia.runAsync({ "qrencode", "-s", "12", "-m", "2", "-o", path, "--", text }, function(res)
        if res.exitCode ~= 0 then return end
        clear()
        img = path
        panel.render(ui.column({ gap = 12 }, {
            ui.input({
                key = seed, value = text, width = 400, focus = true,
                onSubmit = function(v) if v ~= "" then show(v, seed) end end,
            }),
            ui.image({
                path = path, width = 400, height = 400, radius = 16,
                onClick = function() noctalia.runAsync({ "sh", "-c", 'wl-copy -t image/png < "$1"', "_", path }) end,
            }),
        }))
    end)
end

function onOpen(text)
    if not text or text == "" then return panel.close() end
    show(text, "in-" .. n)
end

function onClose() clear() end
