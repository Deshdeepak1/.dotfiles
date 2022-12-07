-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- awful.util.shell = "sh"

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Awesome-freedesktop
local freedesktop = require("freedesktop")

-- Custom
local switcher = require("awesome-switcher")

-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- battery warning
-- created by bpdp

local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end


local battery = wibox.widget.textbox()

local function bat_notification()
  
  local f_capacity = assert(io.open("/sys/class/power_supply/C245/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/C245/status", "r"))

  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if (bat_capacity <= 20 and bat_status == "Discharging") then
    st_color = "red"
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery low! " .. bat_capacity .."%" .. " left!"
      , fg="#ff0000"
      , bg="#deb887"
      , timeout    = 15
      -- , position   = "bottom_left"
    })
  elseif (bat_status == "Discharging") then
    st_color = "yellow"
  elseif (bat_capacity == 100) then
    st_color = "cyan"
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery Full Charged"
      , fg="#00ff00"
      --, bg="#deb887"
      , timeout    = 15
      -- , position   = "bottom_left"
    })
  elseif (bat_status == "Charging") then
    st_color = "light green"
  else 
        return
  end
  cap = tostring(bat_capacity)
  battery.markup = "<span font='10.5' foreground='" .. st_color .. "'>" .. cap .. "</span>"
end

battimer = timer({timeout = 120})
battimer:connect_signal("timeout", bat_notification)
battimer:start()
bat_notification()

-- end here for battery warning

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -d .config/awesome/ -e '" .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Edit config", editor_cmd .. " " .. awesome.conffile .. "'"},
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

mymainmenu = freedesktop.menu.build({ before = { { "Awesome", myawesomemenu, beautiful.awesome_icon },},
                          after  =  { { "Terminal", terminal }, },
                          sub_menu = "Applications"
                        })


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
clock_fgs = {
    "cyan",
    "light blue",
    "violet",
    "light green",
    "light pink",
    "magenta",
}
math.randomseed(os.time())
clock_fg = clock_fgs[math.random(#clock_fgs)]
clock = "<b><span foreground='" .. clock_fg .."'>%a %d %b, %H:%M</span></b>"
mytextclock = wibox.widget.textclock(clock)

-- Net Connection Status Widget
jio = wibox.widget.textbox()


local function set_con_status(out,err,er,ec)
    local status = "Error"
    local st = "E"
    local st_color = "red"
    if ec == 0 then
        status = "Connected"
        st = "C"
        st_color = "light green"
    elseif ec == 1 then
        status = "Disconnected"
        st = "D"
        st_color = "yellow"
    end
    jio.markup = "<span font='13' foreground='" .. st_color .. "'><b>" .. st .. "</b></span>"
    naughty.notify({text = status})
end

local function check_connection()
    awful.spawn.easy_async_with_shell("ping -w 1 google.com", set_con_status)
end


local function handle_jio()
    awful.spawn.easy_async_with_shell("jio", check_connection)
end

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        --local wallpaper = beautiful.wallpaper
        --local wallpaper = "/usr/share/wallpapers/Next/contents/images/1366x768.png"
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

tags = { "", "🌐", "", "📁", "", "⚙️", "", "", "" }
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    --set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    -- awful.tag({ "CODE", "BR", "FM", "EX", "TG", "EX", "EX", "EX", "EX" }, s, awful.layout.layouts[1])
    awful.tag(tags, s, awful.layout.layouts[1])
    -- awful.tag({ "⚙️", "", " ", "", "", "", "", "", "", "", "🏠", "📃", "🎵", "💬", "🔵", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        width = 32,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,
            spacing = 5,
            jio,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
            battery
        },
    }
    -- Set and check connection status
    check_connection()
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ modkey, "Control" }, "q", function () awful.spawn("loginctl lock-session") end,
              {description="Lock", group="awesome"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({}, "Menu", function () mymainmenu:show() end,
              -- {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ "Mod1",           }, "Tab",
        function ()
            switcher.switch( 1, "Mod1", "Alt_L", "Shift", "Tab")
        end,
        {description = "Switcher:Go Next", group = "client"}),
    awful.key({ "Mod1", "Shift"   }, "Tab",
        function ()
            switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
        end,
        {description = "Switcher:Go back", group = "client"}),


    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "Open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal .. " -e \"fish -c tmux\"") end,
              {description = "Open terminal with tmux", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "Reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "Quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Dmenu
    awful.key({ modkey },            "r",     function () awful.util.spawn("dmenu_run -p 'Run:'  -fn 'Mononoki Nerd Font' -sf lightgreen") end,
              {description = "Programs", group = "Dmenu"}),
    awful.key({ modkey },            "y",     function () awful.util.spawn_with_shell("yt -g") end,
              {description = "Youtube", group = "Dmenu"}),

    -- Clipmenu
    awful.key({ modkey },            "c",     function () awful.util.spawn("clipmenu") end,
              {description = "Clipmenu", group = "Dmenu"}),

    -- Flameshot
    awful.key({ modkey, "Shift" },            "p",     function () awful.util.spawn("flameshot screen -p /home/deshdeepak/Pictures") end,
              {description = "Entire desktop", group = "Screenshot"}),
    awful.key({ modkey, "Control" },            "p",     function () awful.util.spawn("flameshot gui -p /home/deshdeepak/Pictures") end,
              {description = "Manual", group = "Screenshot"}),
    awful.key({ modkey, "Mod1" },            "p",     function () awful.util.spawn("flameshot launcher") end,
              {description = "Capture Mode", group = "Screenshot"}),


    -- Brave
    awful.key({ modkey },            "b",     function () awful.util.spawn("brave") end,
              {description = "Brave", group = "Applications"}),
    awful.key({ modkey, "Shift" },   "b",     function () awful.util.spawn("brave --incognito") end,
              {description = "Brave(Incognito)", group = "Applications"}),

    -- Pcmanfm
    awful.key({ modkey },            "e",     function () awful.util.spawn("pcmanfm") end,
              {description = "FileManager", group = "Applications"}),

    -- JioWifi
    awful.key({ modkey },            "i", handle_jio,
              {description = "Handle Jio Connection", group = "JioWifi"}),
    awful.key({ modkey, "Shift" },            "r", check_connection,
              {description = "Refresh Connection Status", group = "JioWifi"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
              -- {description = "show the menubar", group = "launcher"})
    -- Rofi 
    awful.key({ modkey }, "p", function() awful.util.spawn("rofi -modi drun -show drun -show-icons -display-drun 'Launch' ") end,
              {description = "Applications Menu", group = "Rofi"}),
    awful.key({ modkey }, "w", function() awful.util.spawn_with_shell("rofi-wifi-menu.sh") end,
              {description = "Wifi Menu", group = "Rofi"}),
    awful.key({ modkey, "Mod1" }, "b", function() awful.util.spawn_with_shell("rofi-bluetooth") end,
              {description = "Bluetooth Menu", group = "Rofi"}),
    awful.key({ modkey, "Shift" }, "w", function() awful.util.spawn("rofi -modi window -show window -show-icons") end,
              {description = "Window Menu", group = "Rofi"}),
    awful.key({ modkey, "Mod1" }, "c", function() awful.util.spawn("rofi -show calc -modi calc -no-show-match -no-sort") end,
              {description = "Window Menu", group = "Rofi"}),
    awful.key({ modkey, "Shift" }, "e", function() awful.util.spawn("rofi -modi filebrowser -show filebrowser -show-icons") end,
              {description = "File Browser", group = "Rofi"}),
    awful.key({ modkey, "Shift"}, "c", function() awful.util.spawn_with_shell("CM_LAUNCHER='rofi' clipmenu") end,
              {description = "Clipmenu", group = "Rofi"}),
    awful.key({ modkey, "Mod1"}, "l", function() awful.util.spawn_with_shell("rofi -modi power_menu:rofi-power-menu -show power_menu") end,
              {description = "Power Menu", group = "Rofi"})

)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Sxiv",
          "mpv",
          "KotatogramDesktop",
          "Pcmanfm",
          "Brave-browser"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set default tags for some windows
    { rule = { class = "Brave-browser" },
      properties = { screen = 1, tag = tags[2], switchtotag = true, placement = awful.placement.centered} },
    { rule = { class = "KotatogramDesktop" },
      properties = { screen = 1, tag = tags[5], switchtotag = false, placement = awful.placement.centered } },
    { rule = { class = "Pcmanfm" },
      properties = { screen = 1, tag = tags[4], switchtotag = true, placement = awful.placement.centered } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    c.placement = awful.placement.center
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    awful.spawn.with_shell(terminal)
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart Applications
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("CM_SELECTIONS='clipboard' /usr/bin/clipmenud")
awful.spawn.with_shell("feh --randomize --bg-fill /home/deshdeepak/wallpapers")
-- awful.spawn.with_shell("bash -c \"killall -9 volumeicon\"")
-- awful.spawn.with_shell("volumeicon")
-- awful.spawn.with_shell("flameshot")
-- awful.spawn.with_shell("/home/deshdeepak/.config/polybar/launch.sh")
