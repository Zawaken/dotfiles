local fn = vim.fn

function ToggleNumbers()
  if vim.opt.number or vim.opt.relativenumber then
    EnterInsert()
    vim.opt.number = false
    vim.opt.relativenumber = false
  else
    LeaveInsert()
  end
end

function EnterInsert()
  vim.opt.cursorline = true
  vim.opt.relativenumber = false
  vim.opt.number = true
  vim.opt.list = false
end

function LeaveInsert()
  vim.opt.cursorline = false
  vim.opt.relativenumber = true
  vim.opt.number = true
  vim.opt.list = true
end
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
