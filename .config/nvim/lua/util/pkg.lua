local M = {}

local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  M.Pboot = true
end

M.boot = function()
  if M.Boot then
    fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
    print "Installing packer, close and reopen nvim"
    vim.cmd[["packadd packer.nvim"]]
  end

  vim.cmd[[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
  ]]
end

M.wrap = function(use)
  return function(spec)
    use(spec)
  end
end

M.update = function()
  local ok, packer = pcall(require, "packer")
  if not ok then
    return
  end
  packer.sync()
end

M.config = {
  profile = {
    enable = true,
    threshold = 0,
  },
  display = {
    open_fn = function()
      return require("packer.util").float({border = "single"})
    end
  }
}

M.setup = function(plugins, config)
  local cfg = vim.tbl_deep_extend("force", M.config, config or {})

  M.boot()

  local ok, packer = pcall(require, "packer")
  if not ok then
    return
  end

  packer.init(cfg)
  return packer.startup({
    function(use)
      use = M.wrap(use)
      plugins(use)
    end
  })
end

return M
