--[[{{{ Keys
taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
tasklist_[bg|fg]_[focus|urgent]
titlebar_[bg|fg]_[normal|focus]
tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
mouse_finder_[color|timeout|animate_timeout|radius|factor]
prompt_[fg|bg|fg_cursor|bg_cursor|font]
hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
notification_font
notification_[bg|fg]
notification_[width|height|margin]
notification_[border_color|border_width|shape|opacity]
menu_[bg|fg]_[normal|focus]
menu_[border_color|border_width]
--}}}]]

local theme_assets                          = require("beautiful.theme_assets")
local xresources                            = require("beautiful.xresources")
local dpi                                   = xresources.apply_dpi
local xrdb                                  = xresources.get_current_theme()
local gfs                                   = require("gears.filesystem")
local config_path                           = gfs.get_configuration_dir()
local themes_path                           = gfs.get_themes_dir()
local wibox                                 = require("wibox")
local gears_shape                           = require("gears.shape")
local gears_surface                         = require("gears.surface")
local clienticon                            = require("awful.widget.clienticon")
local rnotification                         = require("ruled.notification")

local theme                                 = dofile(themes_path.."default/theme.lua")

theme.wallpaper                             = "~/.config/wall.png"

theme.menu_icon                             = config_path .. "icons/menu.png"
theme.task_width                            = dpi(250)

theme.bg                                    = "#262643"
theme.fg                                    = "#F8F2EC"
theme.fg_secondary                          = "#474A7C"
theme.secondary                             = "#C49DA3"
theme.tertiary                              = "#876A97"

-- theme.black                                 = "#000000" -- xrdb.color0
-- theme.dark_red                              = "#c23621" -- xrdb.color1
-- theme.dark_green                            = "#25bc24" -- xrdb.color2
-- theme.dark_yellow                           = "#adad27" -- xrdb.color3
-- theme.dark_blue                             = "#492ee1" -- xrdb.color4
-- theme.dark_magenta                          = "#d338d3" -- xrdb.color5
-- theme.dark_cyan                             = "#33bbc8" -- xrdb.color6
-- theme.gray                                  = "#cbcccd" -- xrdb.color7
-- theme.dark_gray                             = "#818383" -- xrdb.color8
theme.red                                   = "#E27878" -- xrdb.color9
-- theme.green                                 = "#31e722" -- xrdb.color10
-- theme.yellow                                = "#eaec23" -- xrdb.color11
-- theme.blue                                  = "#5833ff" -- xrdb.color12
-- theme.magenta                               = "#f935f8" -- xrdb.color13
-- theme.cyan                                  = "#14f0f0" -- xrdb.color14
-- theme.white                                 = "#e9ebeb" -- xrdb.color15
-- theme.opacity                               = "e6" -- 90%

-- theme.font                                  = "JetBrainsMonoMedium Nerd Font 10"
theme.font                                  = "xos4 Terminess Powerline 9"
theme.font_bold                             = "JetBrainsMonoExtraBold Nerd Font 10"
theme.bg_normal                             = theme.bg
theme.bg_focus                              = theme.bg
theme.bg_urgent                             = theme.red
theme.bg_minimize                           = theme.bg
theme.bg_systray                            = theme.bg
theme.fg_normal                             = theme.fg_secondary
theme.fg_minimize                           = theme.fg_secondary
theme.fg_focus                              = theme.fg
theme.fg_urgent                             = theme.fg
-- theme.separator                             = theme.dark_gray
-- theme.wibar_fg                              = theme.gray
-- theme.wibar_bg                              = theme.black

-- theme.dont_swallow_classname_list           = {"firefox", "[Dd]iscord"}
-- theme.dont_swallow_filter_activated         = true
theme.parent_filter_list = {"firefox", "[Dd]iscord"}
theme.child_filter_list  = {"[Dd]iscord"}
theme.swallowing_filter = true
theme.gap_single_client                     = false
theme.border_single_client                  = false
theme.useless_gap                           = dpi(4)
theme.border_width                          = dpi(2)
theme.border_radius                         = dpi(5)
theme.bar_height                            = dpi(20)

theme.border_color_marked                   = theme.red -- .. theme.opacity
-- theme.border_color_floating                 = theme.blue .. theme.opacity
-- theme.border_color_maximized                = theme.dark_gray .. theme.opacity
-- theme.border_color_fullscreen               = theme.dark_gray .. theme.opacity
theme.border_color_active                   = theme.tertiary -- .. theme.opacity
theme.border_color_normal                   = theme.bg -- .. theme.opacity
-- theme.border_color_urgent                   = theme.cyan .. theme.opacity
-- theme.border_color_new                      = theme.yellow .. theme.opacity

-- theme.taglist_bg_focus                      = theme.blue
-- theme.taglist_bg_urgent                     = theme.cyan
theme.taglist_bg_occupied                   = theme.secondary
theme.taglist_bg_empty                      = theme.secondary
-- theme.taglist_bg_volatile                   = theme.red
theme.taglist_fg_focus                      = theme.secondary
-- theme.taglist_fg_urgent                     = theme.black
theme.taglist_fg_occupied                   = theme.bg
theme.taglist_fg_empty                      = theme.bg
-- theme.taglist_fg_volatile                   = theme.black
-- theme.taglist_spacing                       = dpi(2)
-- theme.taglist_shape                         = gears_shape.rectangle
theme.taglist_shape_border_width            = dpi(3)
theme.taglist_shape_border_color            = theme.secondary
-- theme.taglist_shape_border_color_empty      = theme.black
theme.taglist_shape_border_color_focus      = theme.bg
-- theme.taglist_shape_border_color_urgent     = theme.cyan
-- theme.taglist_shape_border_color_volatile   = theme.red
theme.taglist_squares_sel                   = theme_assets.taglist_squares_sel(dpi(6), theme.secondary)
theme.taglist_squares_unsel                 = theme_assets.taglist_squares_unsel(dpi(6), theme.bg)
theme.tasklist_font_focus                   = theme.font
theme.tasklist_disable_task_name            = true
theme.tasklist_spacing                      = dpi(5)

-- theme.tasklist_fg_normal                    = theme.gray
-- theme.tasklist_bg_normal                    = theme.black
-- theme.tasklist_fg_focus                     = theme.black
-- theme.tasklist_bg_focus                     = theme.blue

-- theme.tasklist_shape_border_width           = dpi(1)
-- theme.tasklist_shape_border_color           = theme.black
-- theme.tasklist_shape_border_color_focus     = theme.blue
-- theme.tasklist_shape_border_color_minimized = theme.dark_gray
-- theme.tasklist_shape_border_color_urgent    = theme.cyan

-- theme.tasklist_widget_template = {
--     {
--         {
--             {
--                 {
--                     id     = 'clienticon',
--                     widget = clienticon,
--                 },
--                 margins = dpi(4),
--                 widget  = wibox.container.margin,
--             },
--             {
--                 id     = 'text_role',
--                 widget = wibox.widget.textbox,
--             },
--             layout = wibox.layout.fixed.horizontal,
--         },
--         left  = dpi(4),
--         right = dpi(4),
--         widget = wibox.container.margin
--     },
--     id     = 'background_role',
--     widget = wibox.container.background,
--     create_callback = function(self, c)
--         self:get_children_by_id('clienticon')[1].client = c
--     end,
-- }

-- theme.titlebar_font_normal                  = theme.font
-- theme.titlebar_fg_normal                    = theme.dark_gray
-- theme.titlebar_bg_normal                    = theme.black
-- theme.titlebar_font_focus                   = theme.font_bold
-- theme.titlebar_fg_focus                     = theme.white
-- theme.titlebar_bg_focus                     = theme.black

-- theme.tooltip_fg                            = theme.gray
-- theme.tooltip_bg                            = theme.black
-- theme.tooltip_border_color                  = theme.black
-- theme.tooltip_border_width                  = dpi(0)
-- theme.tooltip_opacity                       = 1

-- theme.menu_border_color                     = theme.blue
theme.menu_width                            = dpi(160)
theme.menu_height                           = dpi(theme.bar_height)
theme.menu_submenu                          = "▸ "
theme.menu_submenu_icon                     = nil

-- theme.notification_font                     = theme.font
-- theme.notification_bg                       = theme.black
-- theme.notification_fg                       = theme.white
-- theme.notification_border_width             = dpi(1)
-- theme.notification_border_color             = theme.white
-- theme.notification_shape                    = gears_shape.rectangle
-- theme.notification_opacity                  = 1
-- theme.notification_margin                   = dpi(2)
-- theme.notification_width                    = dpi(320)
-- theme.notification_height                   = dpi(100)
-- theme.notification_spacing                  = dpi(2)

theme = theme_assets.recolor_layout(theme, theme.tertiary)
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "normal")
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "normal", "hover")
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "normal", "press")
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "focus")
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "focus", "hover")
theme = theme_assets.recolor_titlebar(theme, theme.tertiary, "focus", "press")

theme.icon_theme                             = nil

-- theme.awesome_icon                           = config_path .. "icons/menu.png"

local myshape = function(cr, width, height)
  local opad = 4
  local ipad = 1
  gears_shape.transform(gears_shape.rectangle) : translate(opad,                      opad)(cr, width/2-ipad/2-opad, height/2-ipad/2-opad)
  gears_shape.transform(gears_shape.rectangle) : translate(width/2+ipad/2,            opad)(cr, width/2-ipad/2-opad, height/2-ipad/2-opad)
  gears_shape.transform(gears_shape.rectangle) : translate(opad,           height/2+ipad/2)(cr, width/2-ipad/2-opad, height/2-ipad/2-opad)
  gears_shape.transform(gears_shape.rectangle) : translate(width/2+ipad/2, height/2+ipad/2)(cr, width/2-ipad/2-opad, height/2-ipad/2-opad)
  -- gears_shape.transform(gears_shape.rectangle) : translate(opad,         opad         )(cr, width/2-opad-ipad, height/2-opad-ipad)
  -- gears_shape.transform(gears_shape.rectangle) : translate(width/2+ipad, opad         )(cr, width/2-opad-ipad, height/2-opad-ipad)
  -- gears_shape.transform(gears_shape.rectangle) : translate(opad,         height/2+ipad)(cr, width/2-opad-ipad, height/2-opad-ipad)
  -- gears_shape.transform(gears_shape.rectangle) : translate(width/2+ipad, height/2+ipad)(cr, width/2-opad-ipad, height/2-opad-ipad)
end
theme.awesome_icon = gears_surface.load_from_shape(20, 20, myshape, theme.tertiary)
-- theme.awesome_icon = gears_surface.load_from_shape(20, 20, wibox.container.background(wibox.widget.textbox("a"), theme.tertiary, wibox.widget.textbox("a")), theme.tertiary)

-- theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.magenta, theme.black)

-- rnotification.connect_signal('request::rules', function()
--     rnotification.append_rule {
--         rule       = { urgency = 'critical' },
--         properties = { bg = theme.black, fg = theme.yellow, border_color = theme.red }
--     }
--     rnotification.append_rule {
--         rule       = { urgency = 'low' },
--         properties = { bg = theme.black, fg = theme.gray, border_color = theme.dark_gray }
--     }
-- end)

return theme

