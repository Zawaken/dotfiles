require "options"
require "keymaps"
vim.defer_fn(function ()
  require "plugins"
end, 0)
require "autocommands"
require "togglenumbers"
