-- local fn = vim.fn
--
-- function ToggleNumbers()
--   if vim.wo.number or vim.wo.relativenumber then
--     EnterInsert()
--     vim.opt.number = false
--     vim.opt.relativenumber = false
--   else
--     LeaveInsert()
--   end
-- end
--
-- function EnterInsert()
--   vim.opt.cursorline = true
--   vim.opt.relativenumber = false
--   vim.opt.number = true
--   vim.opt.list = false
-- end
--
-- function LeaveInsert()
--   vim.opt.cursorline = false
--   vim.opt.relativenumber = true
--   vim.opt.number = true
--   vim.opt.list = true
-- end
-- vim.cmd [[
-- function! ToggleNumbers()
--   if &number || &relativenumber
--     call EnterInsert()
--     set nonumber
--     set norelativenumber
--   else
--     call LeaveInsert
-- endif
-- endfunction
--
-- function! EnterInsert()
--   set cursorline
--   set norelativenumber
--   set number
--   set list!
-- endfunction
--
-- function! LeaveInsert()
--   set nocursorline
--   set number
--   set relativenumber
--   set list
-- endfunction
-- ]]
function ToggleNumbers()
local g = vim.g
local w = vim.wo
g.def_number         = g.def_number         ~= nil and true  or g.def_number
g.def_relativenumber = g.def_relativenumber ~= nil and true  or g.def_relativenumber
g.def_wrap           = g.def_wrap           ~= nil and false or g.def_wrap
g.def_signcolumn     = g.def_signcolumn     ~= nil and "yes" or g.def_signcolumn

local int_to_bool = function(int)
  if     int == 0 then return false
  elseif int == 1 then return true end
  return int
end

if w.number or w.relativenumber then
  g.def_number         = int_to_bool(w.number)
  g.def_relativenumber = int_to_bool(w.relativenumber)
  g.def_wrap           = int_to_bool(w.wrap)
  g.def_signcolumn     =             w.signcolumn

  w.number         = false
  w.relativenumber = false
  w.wrap           = false
  w.signcolumn     = "no"
else
  w.number         = g.def_number
  w.relativenumber = g.def_relativenumber
  w.wrap           = g.def_wrap
  w.signcolumn     = g.def_signcolumn
end
end
