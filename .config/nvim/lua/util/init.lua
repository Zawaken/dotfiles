local Util = {}
Util.funct = {}

Util.CopyMode = function()
  local g = vim.g
  local w = vim.wo
  vim.cmd("stopinsert")
  g.def_number         = g.def_number ~= nil and true or g.def_number
  g.def_relativenumber = g.def_relativenumber ~= nil and true or g.def_relativenumber
  g.def_wrap           = g.def_wrap ~= nil and false or g.def_wrap
  g.def_list           = g.def_list ~= nil and true or g.def_list
  g.def_signcolumn     = g.def_signcolumn ~= nil and "yes" or g.def_signcolumn

  -- vim.wo always returns a number, but expects a bool when assigning
  local int_to_bool = function(int)
    if int == 0 then return false end
    if int == 1 then return true end
    return int
  end

  local has_blankline, _ = pcall(require, "indent_blankline")

  if w.number or w.relativenumber then
    g.def_number         = int_to_bool(w.number)
    g.def_relativenumber = int_to_bool(w.relativenumber)
    g.def_wrap           = int_to_bool(w.wrap)
    g.def_list           = int_to_bool(w.list)
    g.def_signcolumn     = w.signcolumn

    -- Disable
    -- if has_blankline then vim.cmd("IndentBlanklineDisable") end
    w.number         = false
    w.relativenumber = false
    w.wrap           = false
    w.list           = false
    w.cursorline     = true
    w.signcolumn     = "no"
    vim.api.nvim_input("zRzz")
  else
    -- Restore previous state
    -- if has_blankline then vim.cmd("IndentBlanklineEnable") end
    w.number         = g.def_number
    w.relativenumber = g.def_relativenumber
    w.wrap           = g.def_wrap
    w.list           = g.def_list
    w.cursorline     = false
    w.signcolumn     = g.def_signcolumn
  end
end

return Util
