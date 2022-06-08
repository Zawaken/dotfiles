local awful = require("awful")
local beautiful = require("beautiful")

-- Enable sloppy focus, so that focus follows mouse. {{{
client.connect_signal("mouse::enter", function(c)
  c:activate { context="mouse_enter", raise=false }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{Spawn windows under active client
-- client.connect_signal("manage", function (c)
-- if not awesome.startup then
--   awful.client.setslave(c)
--   local prev_focused = awful.client.focus.history.get(awful.screen.focused(), 1, nil)
--   local prev_c = awful.client.next(-1, c)
--   if prev_c and prev_focused then
--     while prev_c ~= prev_focused do
--       c:swap(prev_c)
--       prev_c = awful.client.next(-1, c)
--     end
--   end
-- end
--
-- if awesome.startup
--   and not c.size_hints.user_position
--   and not c.size_hints.program_position then
--     -- Prevent clients from being unreachable after screen count changes.
--     awful.placement.no_offscreen(c)
-- end
-- end)
-- }}}

-- {{{ Make floating windows behave like they should (always on top)
-- client.connect_signal("property::floating", function(c)
--   if c.floating then
--     c.ontop = true
--   else
--     c.ontop = false
--   end
--   end)
--   client.connect_signal("manage", function(c)
--   if c.floating or c.first_tag.layout.name == "floating" then
--     c.ontop = true
--   else
--     c.ontop = false
--   end
--   end)
--   tag.connect_signal("property::layout", function(t)
--   local clients = t:clients()
--   for k,c in pairs(clients) do
--     if c.floating or c.first_tag.layout.name == "floating" then
--       c.ontop = true
--     else
--       c.ontop = false
--     end
--   end
-- end)
-- }}}

-- {{{Remove borders when only one client visible in tag
-- No borders when rearranging only 1 non-floating or maximized client
-- screen.connect_signal("arrange", function (s)
--     local only_one = #s.tiled_clients == 1
--     for _, c in pairs(s.clients) do
--         if only_one and not c.floating then--or c.maximized then
--             c.border_width = 0
--         else
--             c.border_width = beautiful.border_width -- your border width
--         end
--     end
-- end)
-- client.connect_signal("request::border", set_border)
-- client.connect_signal("property::maximized", set_border)
--}}}

-- {{{ make scratchpads appear in the middle of the screen
-- client.connect_signal("request::manage", function(c)
--   if c.floating and c.instance == "scratchpad" then
--     awful.placement.centered()
--   end
-- end)
-- }}}
