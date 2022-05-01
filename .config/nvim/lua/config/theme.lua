local colorscheme = "tokyonight"


vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_comments = true


-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   vim.cmd [[
--     colorscheme default
--     set background=dark
--   ]]
-- end
-- vim.cmd("colorscheme tokyonight")
require("tokyonight").colorscheme()
