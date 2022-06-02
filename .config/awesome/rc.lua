-- {{{ Packages
-- standard awesome libs
-- pcall(require, "luarocks.loader")

-- Xmonad-like workspaces
local charitable = require("charitable")
-- Dynamic tags
require("eminent.eminent")
-- lain utils, widgets & layouts
local lain = require("lain")
-- zen widgets
local zen = require("zen.bootstrap")
-- scratchpads
local scratch = require("scratch.scratch")

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
  -- {{{ commented out old code
--   -- Create an imagebox widget which will contain an icon indicating which layout we're using.
--   -- We need one layoutbox per screen.
--   s.mylayoutbox = awful.widget.layoutbox {
--     screen  = s,
--     buttons = {
--       awful.button({ }, 1, function() awful.layout.inc( 1) end),
--       awful.button({ }, 3, function() awful.layout.inc(-1) end),
--       awful.button({ }, 4, function() awful.layout.inc(-1) end),
--       awful.button({ }, 5, function() awful.layout.inc( 1) end),
--     }
--   }
--
--   -- Create a taglist widget
--   s.mytaglist = awful.widget.taglist {
--     screen  = s,
--     filter  = awful.widget.taglist.filter.all,
--     buttons = {
--       awful.button({ }, 1, function(t) t:view_only() end),
--       awful.button({ modkey }, 3, function(t)
--                                     if client.focus then
--                                       client.focus:move_to_tag(t)
--                                     end
--                                   end),
--       awful.button({ }, 3, awful.tag.viewtoggle),
--       awful.button({ modkey }, 1, function(t)
--                                     if client.focus then
--                                       client.focus:toggle_tag(t)
--                                     end
--                                   end),
--       awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
--       awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end),
--     }
--   }
--

-- }}}


  -- Create the wibox
  s.mywibox = awful.wibar {
    position = "top",
    screen   = s,
    widget   = {
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
awful.mouse.append_global_mousebindings({
  awful.button({ }, 3, function() mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewprev),
  awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}

-- {{{ Key bindings

-- {{{ General
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "s",
    hotkeys_popup.show_help,
    { description="show help", group="awesome" }),
  awful.key({ modkey }, "w",
    function() mymainmenu:show() end,
    { description="show main menu", group="awesome" }),
  awful.key({ modkey, "Shift" }, "r",
    awesome.restart,
    { description="reload awesome", group="awesome" }),
  awful.key({ modkey, "Control" }, "q",
    awesome.quit,
    { description="quit awesome", group="awesome" }),
  awful.key({ modkey, "Shift" }, "p",
    function()
      awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
      }
    end,
    { description="lua execute prompt", group="awesome" }),
  awful.key({ modkey }, "Return",
    function() awful.spawn(terminal) end,
    { description="open a terminal", group="launcher" }),
  awful.key({ modkey }, "x",
    function() awful.spawn("betterlockscreen --lock dimblur --blur 8") end,
    { description="lock screen", group="awesome" }),
  awful.key({ modkey }, "d",
    function() awful.screen.focused().mypromptbox:run() end,
    { description="run prompt", group="launcher" }),
  awful.key({ modkey }, "r",
    function() menubar.show() end,
    { description="show the menubar", group="launcher" }),
  awful.key({ "Control", "Shift"}, "c",
    function() awful.util.spawn("screenshot -m region --open 'sharenix -n -c'") end),
  awful.key({ "Control", "Shift"}, "x",
    function() awful.util.spawn("screenshot -m window --open 'sharenix -n -c'") end),
  awful.key({ modkey, "Shift"}, "c",
    function () awful.spawn("toggleprogram picom")end
  ),

  -- Audio related
  awful.key({}, "XF86AudioPlay",
    function() awful.util.spawn("playerctl play-pause") end),
  awful.key({}, "XF86AudioPause",
    function() awful.util.spawn("playerctl play-pause") end),
  awful.key({}, "XF86AudioNext",
    function() awful.util.spawn("playerctl next") end),
  awful.key({}, "XF86AudioPrev",
    function() awful.util.spawn("playerctl previous") end),
  awful.key({}, "XF86AudioLowerVolume",
    function() awful.util.spawn("pactl set-sink-volume 2 -5%") end),
  awful.key({}, "XF86AudioRaiseVolume",
    function() awful.util.spawn("pactl set-sink-volume 2 +5%") end),
})
-- }}}

-- {{{ Tag-related
awful.keyboard.append_global_keybindings({
  awful.key({ modkey }, "h",
            awful.tag.viewprev,
            { description="view previous", group="tag" }),
  awful.key({ modkey }, "l",
            awful.tag.viewnext,
            { description="view next", group="tag" }),
  awful.key({ modkey }, "Tab",
            awful.tag.history.restore,
            { description="go back", group="tag" }),
})
-- }}}

-- {{{ Focus-related
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
  awful.key({ modkey, "Shift" }, "-",
            function()
              local c = awful.client.restore()
              -- Focus restored client
              if c then
                c:activate { raise=true, context="key.unminimize" }
              end
            end,
            { description="restore minimized", group="client" }),
})
-- }}}

-- {{{ Layout
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
  awful.key({ modkey }, ",",
            function() awful.tag.incnmaster(1, nil, true) end,
            { description="increase the number of master clients", group="layout" }),
  awful.key({ modkey }, ".",
            function() awful.tag.incnmaster(-1, nil, true) end,
            { description="decrease the number of master clients", group="layout" }),
  awful.key({ modkey }, "v",
            function() awful.tag.incncol(1, nil, true) end,
            { description="increase the number of columns", group="layout" }),
  awful.key({ modkey, "Shift" }, "v",
            function() awful.tag.incncol(-1, nil, true) end,
            { description="decrease the number of columns", group="layout" }),
  awful.key({ modkey }, "space",
            function() awful.layout.inc(1) end,
            { description="select next", group="layout" }),
  awful.key({ modkey, "Shift" }, "space",
            function() awful.layout.inc(-1) end,
            { description="select previous", group="layout" }),
})
-- }}}

-- {{{ Tag-Switching etc
awful.keyboard.append_global_keybindings({
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
-- {{{old code
  -- awful.key {
  --   -- TODO If attempting to focus current tag, focus previous
  --   modifiers   = { modkey },
  --   keygroup    = "numrow",
  --   description = "only view tag",
  --   group       = "tag",
  --   on_press    = function(index)
  --     local screen = awful.screen.focused()
  --     local tag = screen.tags[index]
  --     if tag then
  --       tag:view_only()
  --     end
  --   end,
  -- },
  -- awful.key {
  --   modifiers   = { modkey, "Control" },
  --   keygroup    = "numrow",
  --   description = "toggle tag",
  --   group       = "tag",
  --   on_press    = function(index)
  --     local screen = awful.screen.focused()
  --     local tag = screen.tags[index]
  --     if tag then
  --       awful.tag.viewtoggle(tag)
  --     end
  --   end,
  -- },
  -- awful.key {
  --   modifiers = { modkey, "Shift" },
  --   keygroup    = "numrow",
  --   description = "move focused client to tag",
  --   group       = "tag",
  --   on_press    = function(index)
  --     if client.focus then
  --       local tag = client.focus.screen.tags[index]
  --       if tag then
  --         client.focus:move_to_tag(tag)
  --       end
  --     end
  --   end,
  -- },
  -- awful.key {
  --   modifiers   = { modkey, "Control", "Shift" },
  --   keygroup    = "numrow",
  --   description = "toggle focused client on tag",
  --   group       = "tag",
  --   on_press    = function(index)
  --     if client.focus then
  --       local tag = client.focus.screen.tags[index]
  --       if tag then
  --         client.focus:toggle_tag(tag)
  --       end
  --     end
  --   end,
  -- },
  -- awful.key {
  --   modifiers   = { modkey },
  --   keygroup    = "numpad",
  --   description = "select layout directly",
  --   group       = "layout",
  --   on_press    = function(index)
  --     local t = awful.screen.focused().selected_tag
  --     if t then
  --       t.layout = t.layouts[index] or t.layout
  --     end
  --   end,
  -- } -- }}}
})
-- }}}

-- {{{ Resizing
awful.keyboard.append_client_keybindings({
  -- Resize windows
  awful.key({ modkey, "Control" }, "Up",
            function(c)
              if c.floating then
                c:relative_move(0, 0, 0, -10)
              else
                awful.client.incwfact(0.025)
              end
            end,
            { description="Resize Vertical -", group="client" }),
  awful.key({ modkey, "Control" }, "Down",
            function(c)
              if c.floating then
                c:relative_move(0, 0, 0, 10)
              else
                awful.client.incwfact(-0.025)
              end
            end,
            { description="Resize Vertical +", group="client" }),
  awful.key({ modkey, "Control" }, "Left",
            function(c)
              if c.floating then
                c:relative_move(0, 0, -10, 0)
              else
                awful.tag.incmwfact(-0.025)
              end
            end,
            { description="Resize Horizontal -", group="client" }),
  awful.key({ modkey, "Control" }, "Right",
            function(c)
              if c.floating then
                c:relative_move( 0, 0,  10, 0)
              else
                awful.tag.incmwfact(0.025)
              end
            end,
            { description="Resize Horizontal +", group="client" }),

  -- Moving windows
  awful.key({ modkey, "Shift" }, "Down",
    function(c)
      if c.floating then
        c:relative_move(0, 20, 0, 0)
      else
        awful.client.swap.global_bydirection("down")
        c:raise()
      end
    end,
    { description="Move Down", group="client" }),
  awful.key({ modkey, "Shift" }, "Up",
    function(c)
      if c.floating then
        c:relative_move(0, -20, 0, 0)
      else
        awful.client.swap.global_bydirection("up")
        c:raise()
      end
    end,
    { description="Move Up", group="client" }),
  awful.key({ modkey, "Shift" }, "Left",
    function(c)
      if c.floating then
        c:relative_move(-20, 0, 0, 0)
      else
        awful.client.swap.global_bydirection("left")
        c:raise()
      end
    end,
    { description="Move Left", group="client" }),
  awful.key({ modkey, "Shift" }, "Right",
    function(c)
      if c.floating then
        c:relative_move(20, 0, 0, 0)
      else
        awful.client.swap.global_bydirection("right")
        c:raise()
      end
    end,
    { description="Move Right", group="client" }),
  awful.key({ modkey }, "Down",
    function(c)
      awful.client.focus.global_bydirection("down")
      c:lower()
    end,
    { description="focus next window up", group="client" }),
  awful.key({ modkey }, "Up",
    function(c)
      awful.client.focus.global_bydirection("up")
      c:lower()
    end,
    { description="focus next window down", group="client" }),
  awful.key({ modkey }, "Right",
    function(c)
      awful.client.focus.global_bydirection("right")
      c:lower()
    end,
    { description="focus next window right", group="client" }),
  awful.key({ modkey }, "Left",
    function(c)
      awful.client.focus.global_bydirection("left")
      c:lower()
    end,
    { description="focus next window left", group="client" }),
  awful.key({ modkey }, "a",
    function()
      scratch.toggle("alacritty --class scratchpad -e tmux attach", {instance="scratchpad"})
    end,
    { description="toggle tmux", group="client"}),
})
-- }}}
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({ }, 1,
                 function(c) c:activate { context="mouse_click" } end),
    awful.button({ modkey }, 1,
                 function(c) c:activate { context="mouse_click", action="mouse_move" } end),
    awful.button({ modkey }, 3,
                 function(c) c:activate { context="mouse_click", action="mouse_resize" } end),
  })
end)

-- {{{ General 2.0
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    awful.key({ "Mod1" }, "Return",
              function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
              end,
              { description="toggle fullscreen", group="client" }),
    awful.key({ modkey, "Shift" }, "f",
              awful.client.floating.toggle,
              { description="toggle floating", group="client" }),
    awful.key({ modkey }, "q",
              function(c) c:kill() end,
              { description="close", group="client" }),
    awful.key({ modkey, "Shift" }, "Return",
              function(c) c:swap(awful.client.getmaster()) end,
              { description="move to master", group="client" }),
    -- awful.key({ modkey }, "o",
    --           function(c) c:move_to_screen() end,
    --           { description="move to screen", group="client" }),
    awful.key({ "Mod1" }, "space",
              function(c) c.ontop = not c.ontop end,
              { description="toggle keep on top", group="client" }),
    awful.key({ modkey }, "-",
              function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
              end,
              { description="minimize", group="client" }),
    awful.key({ modkey }, "f",
              function(c)
                c.maximized = not c.maximized
                c:raise()
              end,
              { description="(un)maximize", group="client" }),
  })
end)
-- }}}

-- }}}

-- {{{ Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = "global",
    rule       = { },
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.no_overlap+awful.placement.no_offscreen,
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
      }
    },
    properties = { floating=true, ontop=true }
  }

  -- ruled.client.append_rule {
  --   rule_any   = { class={"discord", "slack"}   },
  --   properties = { tag=tags[2], size_hints_honor=false }
  -- }

  ruled.client.append_rule {
    rule       = { instance="scratchpad"   },
    properties = {
      floating = true,
      minimized = true,
      sticky = false,
      above = true,
      skip_taskbar=true,
    }
  }
  ruled.client.append_rule {
    rule       = { class="Steam" },
    properties = { tag=tags[5], size_hints_honor=false }
  }
  ruled.client.append_rule {
    rule       = { class="Spotify" },
    properties = { tag = tags[4] }
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
