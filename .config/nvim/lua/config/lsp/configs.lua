local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

mason.setup()

local lspconfig = require("lspconfig")

local servers = { "clangd"
  , "cssls"
  , "hls"
  , "jsonls"
  , "lua_ls"
  , "pyright"
  , "tsserver"
  , "vimls"
}

require("mason-lspconfig").setup {
  ensure_installed = servers
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("config.lsp.handlers").on_attach,
    capabilities = require("config.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "config.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end
  lspconfig[server].setup(opts)
end
