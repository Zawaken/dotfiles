-- vim.cmd [[
-- try
--   colorscheme tokyonight
-- catch /^Vim\%((\a\+)\)\=:E185/
--   colorscheme default
--   set background=dark
-- endtry
-- ]]


local colorscheme = "tokyonight"

-- local status_ok, _ = pcall(require(colorscheme).colorscheme())
-- if not status_ok then
--   vim.cmd [[
--     colorscheme default
--     set background=dark
--   ]]
-- end
require(colorscheme).colorscheme()
