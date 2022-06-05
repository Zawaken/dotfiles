-- {{{ Packages
-- standard awesome libs
pcall(require, "luarocks.loader")

-- Xmonad-like workspaces
local charitable = require("charitable")
-- local sharedtags = require("sharedtags")
-- Dynamic tags
require("eminent.eminent")
-- lain utils, widgets & layouts
local lain = require("lain")
-- zen widgets
local zen = require("zen.bootstrap")
-- scratchpads
local scratch = require("scratch.scratch")
-- awesome-ez. unpack = table.unpack is needed because unpack does not exist in lua 5.2+
local ez = require("ez")
unpack = table.unpack or unpack

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- widget and layout lib
local wibox = require("wibox")
-- notification lib
local naughty = require("naughty")
-- theme handling
local beautiful = require("beautiful")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- }}}

-- {{{ awesomewm error handling with naughty
naughty.connect_signal("request::display_error", function (message, startup)
  naughty.notification {
    urgency = "critical",
    title = "An error occured"..(startup and " during startup!" or "!"),
    message = message
  }
end)
-- }}}

-- {{{ variables
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- nice()

awesome.set_preferred_icon_size(32)

awful.mouse.snap.edge_enabled = false

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
-- }}}

-- {{{ Menu
myawesomemenu = {
  { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile},
  { "recompile", awesome.restart },
  { "quit", function () awesome.quit() end }
}

mymainmenu = awful.menu({
  { "awesome", myawesomemenu, beautiful.awesome_icon },
  { "open terminal", terminal }
})

mylauncher = awful.widget.launcher({
  image = beautiful.awesome_icon,
  menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Layouts
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    lain.layout.centerwork,
    -- lain.layout.cascade,
  })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      {
        image     = beautiful.wallpaper,
        upscale   = true,
        downscale = true,
        widget    = wibox.widget.imagebox,
      },
      valign = "center",
      halign = "center",
      tiled  = false,
      widget = wibox.container.tile,
    }
  }
end)
-- }}}

-- {{{ Wibar

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

local tags = charitable.create_tags(
  { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
  {
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
    awful.layout.layouts[1],
  }
)

screen.connect_signal("request::desktop_decoration", function(s)
--   -- Each screen has its own tag table.
--   awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
  local cpu = lain.widget.cpu {
    settings = function()
      widget:set_markup("﬙ " .. cpu_now.usage .. "%")
    end
  }

  -- local temp = lain.widget.temp {
  --   settings = function()
  --     widget:set_markup("Temp: " .. temp_now[2])
  --   end
  -- }
  -- local temp = load_widget({
  --   widget = "widgets.temperature.widget"
  -- })


  for i = 1, #tags do
    if not tags[i].selected then
      tags[i].screen = s
      tags[i]:view_only()
      break
    end
  end

  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox {
    screen  = s,
    buttons = {
      awful.button({ }, 1, function() awful.layout.inc( 1) end),
      awful.button({ }, 3, function() awful.layout.inc(-1) end),
      awful.button({ }, 4, function() awful.layout.inc(-1) end),
      awful.button({ }, 5, function() awful.layout.inc( 1) end),
    }
  }


  s.scratch = awful.tag.add('scratch-' .. s.index, {})

  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    source = function(screen, args) return tags end,
  })

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = {
      awful.button({ }, 1, function(c)
                             c:activate { context = "tasklist", action = "toggle_minimization" }
                           end),
      awful.button({ }, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
      awful.button({ }, 4, function() awful.client.focus.byidx(-1) end),
      awful.button({ }, 5, function() awful.client.focus.byidx( 1) end),
    }
  }

  -- Create the wibox
  s.mywibox = awful.wibar {
    position = "top",
    ontop = false,
    screen   = s,
    -- margins  = beautiful.useless_gap + beautiful.border_width,
    widget   = {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        mylauncher,
        s.mytaglist,
        s.mypromptbox,
      },
      wibox.container.margin(s.mytasklist, 5, 5, 5, 5), -- Middle widget
      { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        -- temp.widget,
        cpu.widget,
        mykeyboardlayout,
        wibox.widget.systray(),
        mytextclock,
        s.mylayoutbox,
      },
    }
  }
end)
-- }}}

-- {{{ Mouse bindings
-- awful.mouse.append_global_mousebindings({
--   awful.button({ }, 3, function() mymainmenu:toggle() end),
--   awful.button({ }, 4, awful.tag.viewprev),
--   awful.button({ }, 5, awful.tag.viewnext),
-- })
-- }}}

-- {{{ Key bindings
local globalkeys = {
  -- {{{general
  ["M-Return"]  = {awful.spawn, terminal},
  ["M-d"]       = {function() awful.screen.focused().mypromptbox:run() end}, -- run prompt (rofilike)
  ["M-r"]       = {function() menubar.show() end},
  ["M-w"]       = {function() mymainmenu:show() end}, -- show awesome menu
  ["M-S-r"]     = {awesome.restart}, -- restart/recompile awesome, to update config
  -- ["M-C-q"]     = {awesome.quit},
  ["M-S-c"]     = {awful.spawn, "toggleprogram picom"},
  ["M-a"]       = function() scratch.toggle("alacritty --class scratchpad -e tmux attach", {instance="scratchpad"}) end,
  ["M-S-minus"] = function()
    local c = awful.client.restore()
    if c then
      c:activate { raise=true, context="key.unminimize"}
    end
  end, -- }}}

  -- {{{Tag related
  ["M-h"]   = {awful.tag.viewprev},
  ["M-l"]   = {awful.tag.viewnext},
  ["M-tab"] = {awful.tag.history.restore},
  -- }}}

  -- {{{screenshot binds
  ["C-S-x"] = {awful.spawn, "screenshot -m window --open 'sharenix -n -c'"},
  ["C-S-c"] = {awful.spawn, "screenshot -m region --open 'sharenix -n -c'"},
  --}}}

  -- {{{Layout
  ["M-space"]   = {function() awful.layout.inc(1) end},
  ["M-S-space"] = {function() awful.layout.inc(-1) end},
  ["M-v"]       = {function() awful.tag.incncol(1, nil, true) end},
  ["M-S-v"]     = {function() awful.tag.incncol(-1, nil, true) end},
  ["M-comma"]   = {function() awful.tag.incnmaster(1, nil, true) end},
  ["M-period"]  = {function()
    -- local masters = awful.screen.focused().select_tag.master_count
    local masters = awful.tag.getnmaster()
    if masters > 1 then
      awful.tag.incnmaster(-1, nil, true)
    end
    end},
  --}}}

  -- {{{Audio
  ["XF86AudioPlay"]         = {awful.util.spawn, "playerctl play-pause"},
  ["XF86AudioPause"]        = {awful.util.spawn, "playerctl play-pause"},
  ["XF86AudioPrev"]         = {awful.util.spawn, "playerctl previous"},
  ["XF86AudioNext"]         = {awful.util.spawn, "playerctl next"},
  ["XF86AudioLowerVolume"]  = {awful.util.spawn, "pactl set-sink-volume 2 -5%"},
  ["XF86AudioRaiseVolume"]  = {awful.util.spawn, "pactl set-sink-volume 2 +5%"},
  -- }}}

  -- {{{Lua execute prompt
  ["M-S-p"] = function()
    awful.prompt.run {
      prompt = "Run Lua code: ",
      textbox = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. "/history_eval",
    }
  end,
--}}}
}

local clientkeys = {
-- {{{general clientkeys
  ["M-q"]         = function(c) c:kill() end,
  ["M-minus"]     = function(c) c.minimized = true end,
  ["M-f"]         = function(c) c.maximized = not c.maximized c:raise() end,
  ["A-Return"]    = function(c) c.fullscreen = not c.fullscreen c:raise() end,
  ["M-S-Return"]  = function(c) c:swap(awful.client.getmaster()) end,
  ["M-S-f"]       = {awful.client.floating.toggle},
  ["A-space"]     = function(c) c.ontop = not c.ontop end,-- }}}

  -- {{{Focus
  ["M-Up"]    = function(c) awful.client.focus.global_bydirection("up") c:lower() end,
  ["M-Down"]  = function(c) awful.client.focus.global_bydirection("down") c:lower() end,
  ["M-Right"] = function(c) awful.client.focus.global_bydirection("right") c:lower() end,
  ["M-Left"]  = function(c) awful.client.focus.global_bydirection("left") c:lower() end,
  --}}}

  -- {{{Resizing
  -----------
  ["M-C-Up"]    = function(c)
    if c.floating then
      c:relative_move(0,0,0,-10)
    else
      awful.client.incwfact(0.025)
    end
  end,  -- Resize vertical -
  ["M-C-Down"]  = function(c)
    if c.floating then
      c:relative_move(0,0,0,10)
    else
      awful.client.incwfact(-0.025)
    end
  end,  -- Resize vertical +
  ["M-C-Right"] = function(c)
    if c.floating then
      c:relative_move(0,0,10,0)
    else
      awful.client.incwfact(0.025)
    end
  end,   -- Resize horizontal +
  ["M-C-Left"]  = function(c)
    if c.floating then
      c:relative_move(0,0,-10,0)
    else
      awful.client.incwfact(-0.025)
    end
  end, -- Resize Horizontal - }}}

  -- {{{Moving
  ---------
  ["M-S-Up"]    = function(c)
    if c.floating then
      c:relative_move(0,-20,0,0)
    else
      awful.client.swap.global_bydirection("up")
    end
  end,    -- Move Up
  ["M-S-Down"]  = function(c)
    if c.floating then
      c:relative_move(0,20,0,0)
    else
      awful.client.swap.global_bydirection("down")
    end
  end,   -- Move Down
  ["M-S-Right"] = function(c)
    if c.floating then
      c:relative_move(20,0,0,0)
    else
      awful.client.swap.global_bydirection("right")
    end
  end, -- Move Right
  ["M-S-Left"]  = function(c)
    if c.floating then
      c:relative_move(-20,0,0,0)
    else
      awful.client.swap.global_bydirection("left")
    end
  end,   -- Move Left }}}
}

local clientbtns = {
-- {{{Mouse client buttons
  ["1"]   = function(c) c:activate { context="mouse_click"} end,
  ["M-1"] = function(c) c:activate { context="mouse_click", action="mouse_move"} end,
  ["M-3"] = function(c) c:activate { context="mouse_click", action="mouse_resize"} end,
-- }}}
}

local numkeys = {
-- {{{ Tag-Switching etc
  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    description = "view tag",
    group = "tag",
    on_press = function(i)
      local tag = tags[i]
      if tag then
        charitable.select_tag(tag, awful.screen.focused())
      end
    end
  },
  awful.key {
    modifiers = { modkey, "Control" },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tag",
    on_press = function(i)
      local tag = tags[i]
      if tag then
        charitable.toggle_tag(tag, awful.screen.focused())
      end
    end
  },
  awful.key {
    modifiers = { modkey, "Shift" },
    keygroup = "numrow",
    description = "move client to tag",
    group = "tag",
    on_press = function(i)
      if client.focus then
        local tag = tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
      end
    end
  },
-- }}}
}

-- {{{ Focus-related CLEAN
awful.keyboard.append_global_keybindings({
  -- awful.key({ modkey }, "j",
  --           function() awful.client.focus.byidx(1) end,
  --           { description="focus next by index", group="client" }),
  -- awful.key({ modkey }, "k",
  --           function() awful.client.focus.byidx(-1) end,
  --           {description="focus previous by index", group="client" }),
  -- awful.key({ modkey }, "Tab",
  --           function()
  --             awful.client.focus.history.previous()
  --             if client.focus then
  --               client.focus:raise()
  --             end
  --           end,
  --           { description="go back", group="client"}),
  -- awful.key({ modkey }, "Tab",
  --           function() awful.screen.focus_relative(1) end,
  --           { description="focus the next screen", group="screen" }),
  -- awful.key({ modkey, "Shift" }, "Tab",
  --           function() awful.screen.focus_relative(-1) end,
  --           { description="focus the previous screen", group="screen" }),
  -- awful.key({ modkey, "Shift" }, "-",
  --           function()
  --             local c = awful.client.restore()
  --             -- Focus restored client
  --             if c then
  --               c:activate { raise=true, context="key.unminimize" }
  --             end
  --           end,
  --           { description="restore minimized", group="client" }),
})
-- }}}

-- {{{ Layout CLEAN
awful.keyboard.append_global_keybindings({
  -- awful.key({ modkey, "Shift" }, "j",
  --           function() awful.client.swap.byidx(1) end,
  --           { description="swap with next client by index", group="client" }),
  -- awful.key({ modkey, "Shift" }, "k",
  --           function() awful.client.swap.byidx(-1) end,
  --           { description="swap with previous client by index", group="client" }),
  -- awful.key({ modkey }, "u",
  --           awful.client.urgent.jumpto,
  --           { description="jump to urgent client", group="client" }),
  -- awful.key({ modkey, "Control" }, "Right",
  --           function() awful.tag.incmwfact(0.05) end,
  --           { description="increase master width factor", group="layout" }),
  -- awful.key({ modkey, "Control" }, "Left",
  --           function() awful.tag.incmwfact(-0.05) end,
  --           { description="decrease master width factor", group="layout" }),
})
-- }}}

awful.keyboard.append_global_keybindings(ez.keytable(globalkeys))
awful.keyboard.append_global_keybindings(numkeys)
awful.keyboard.append_client_keybindings(ez.keytable(clientkeys))
awful.keyboard.append_client_keybindings(ez.btntable(clientbtns))
-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
client.connect_signal("property::class", function(c)
  if c.class == "[Ss]potify" then
    local tag = tags[4]
    c:move_to_tag(tag)
    if tag then
      charitable.select_tag(tag)
    end
  end

  if c.class == "discord" or "Slack" then
    c:move_to_tag(tags[2])
    local tag = tags[2]
    if tag then
      charitable.select_tag(tag)
    end
  end

  if c.class == "Steam" then
    c:move_to_tag(tags[5])
    local tag = awful.tag.gettags[5]
    if tag then
      charitable.select_tag(tag)
    end
  end
end)
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = "global",
    rule       = { },
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    }
  }

  -- Floating clients.
  ruled.client.append_rule {
    id       = "floating",
    rule_any = {
      instance = { "copyq", "pinentry" },
      class    = {
        "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
        "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
        "Pavucontrol"
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name    = {
        "Event Tester",  -- xev.
      },
      role    = {
        "AlarmWindow",    -- Thunderbird's calendar.
        "ConfigManager",  -- Thunderbird's about:config.
        "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
        "Popup",          -- firefox popup
      }
    },
    properties = { floating=true, border_width=0, above=true }
  }

  ruled.client.append_rule {
    rule       = { class="Steam" },
    properties = { size_hints_honor=false }
  }
  ruled.client.append_rule {
    rule_any   = { class={"[Ss]potify"} },
    properties = { tag = tags[4] }
  }
  ruled.client.append_rule {
    rule       = { class="discord"   },
    properties = { size_hints_honor=false }
  }

  ruled.client.append_rule {
    rule       = { instance="scratchpad"   },
    properties = {
      floating = true,
      minimized = true,
      sticky = false,
      above = true,
      skip_taskbar=true,
      honor_padding = true,
      honor_workarea = true,
    }
  }

end)

-- }}}

-- {{{ Notifications

ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule {
    rule       = { },
    properties = {
      screen           = awful.screen.focused,
      implicit_timeout = 5,
    }
  }
end)

naughty.connect_signal("request::display", function(n)
  naughty.layout.box { notification=n }
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse. {{{
client.connect_signal("mouse::enter", function(c)
  c:activate { context="mouse_enter", raise=false }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ make sure that removing screens doesn't kill tags
tag.connect_signal("request::screen", function(t)
  t.selected = false
  for s in capi.screen do
      if s ~= t.screen then
        t.screen = s
        return
      end
  end
end
) --}}}

-- {{{ Make floating windows behave like they should (always on top)
client.connect_signal("property::floating", function(c)
  if c.floating then
    c.ontop = true
  else
    c.ontop = false
  end
  end)
  client.connect_signal("manage", function(c)
  if c.floating or c.first_tag.layout.name == "floating" then
    c.ontop = true
  else
    c.ontop = false
  end
  end)
  tag.connect_signal("property::layout", function(t)
  local clients = t:clients()
  for k,c in pairs(clients) do
    if c.floating or c.first_tag.layout.name == "floating" then
      c.ontop = true
    else
      c.ontop = false
    end
  end
end)
-- }}}

-- {{{Make clients spawn "normally"
client.connect_signal("manage", function (c)
if not awesome.startup then
  awful.client.setslave(c)
  local prev_focused = awful.client.focus.history.get(awful.screen.focused(), 1, nil)
  local prev_c = awful.client.next(-1, c)
  if prev_c and prev_focused then
    while prev_c ~= prev_focused do
      c:swap(prev_c)
      prev_c = awful.client.next(-1, c)
    end
  end
end

if awesome.startup
  and not c.size_hints.user_position
  and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
end
end)
-- }}}

-- {{{Remove borders when only one client visible in tag
-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating then--or c.maximized then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width -- your border width
        end
    end
end)
-- client.connect_signal("request::border", set_border)
-- client.connect_signal("property::maximized", set_border)
--}}}

-- {{{ fix wrong warping tags
awful.tag.history.restore = function() end
-- }}}
