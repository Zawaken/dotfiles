-- local colorscheme = "tokyonight"
-- vim.g.tokyonight_style = "night"
-- vim.g.tokyonight_italic_comments = true
local Colors = {}
Colors.scheme = "default"
Colors.background = "dark"

Colors.scheme = function(scheme, scheme_config, background)
  scheme = scheme or Colors.scheme
  background = background or Colors.background
  scheme_config = scheme_config or scheme

  local ok, loaded_config = pcall(require, "config." .. scheme_config)
  if ok and type(loaded_config) == "function" then
    loaded_config()
  end

  local ok, _ = pcall(vim.cmd, "colorscheme " .. scheme)
  if ok then
    vim.cmd("set background=" .. background)
  else
    vim.cmd [[
      colorscheme default
      set background=dark
    ]]
  end
end

-- local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- if not status_ok then
--   vim.cmd [[
--     colorscheme default
--     set background=dark
--   ]]
-- end
-- vim.cmd("colorscheme tokyonight")
-- require("tokyonight").colorscheme()
return Colors
