local M = {}

function M.get_default_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_nvim_lsp then
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  end
  return capabilities
end

return M
