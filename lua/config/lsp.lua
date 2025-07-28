local lspconfig = require("lspconfig")
local typescript_tools = require("typescript-tools")

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  map("n", "<C-]>", vim.lsp.buf.definition)
  map("n", "K", function()
    vim.lsp.buf.hover({ border = "single", max_height = 25, max_width = 120 })
  end)
  map("n", "<C-k>", vim.lsp.buf.signature_help)
  map("n", "<space>rn", vim.lsp.buf.rename, { desc = "Variable rename" })
  map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
  map("n", "<space>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
  map("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
  map("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, { desc = "List workspace folders" })
  map("n", "<leader>D", function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = "",
      scope = "cursor",
    })
  end, { desc = "Show diagnostics popup" })

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

local capabilities = require("lsp_utils").get_default_capabilities()

local enabled_lsp_servers = {
  lua_ls = "lua-language-server",
  vimls = "vim-language-server",
  bashls = "bash-language-server",
  ts_ls = "typescript-language-server",
  jdtls = "jdtls",
  gopls = "gopls",
}

for server_name, lsp_executable in pairs(enabled_lsp_servers) do
  if executable(lsp_executable) then
    if server_name == "ts_ls" then
      typescript_tools.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          disable_formatting(client)
          on_attach(client, bufnr)
        end,
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          expose_as_code_action = "all",
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayVariableTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result and result.diagnostics then
              for _, diag in ipairs(result.diagnostics) do
                if diag.severity == vim.diagnostic.severity.HINT then
                  diag.severity = vim.diagnostic.severity.WARN
                end
              end
            end
            vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
          end,
        },
      })
    elseif server_name == "jdtls" then
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath("data") .. "/site/java-workspace/" .. project_name

      lspconfig.jdtls.setup({
        cmd = {
          "jdtls",
          "-data",
          workspace_dir,
        },
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
        on_attach = on_attach,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
          },
        },
        flags = {
          debounce_text_changes = 500,
        },
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            if not result or not result.diagnostics then return end
            local bufnr = ctx.bufnr or vim.uri_to_bufnr(result.uri or ctx.uri)
            if not bufnr or bufnr == 0 then return end
            local filtered = {}
            for _, diag in ipairs(result.diagnostics) do
              if diag.severity == vim.diagnostic.severity.HINT then
                diag.severity = vim.diagnostic.severity.WARN
              end
              if diag.severity == vim.diagnostic.severity.ERROR or diag.severity == vim.diagnostic.severity.WARN then
                table.insert(filtered, diag)
              end
            end
            vim.diagnostic.set(
              vim.lsp.get_namespace(ctx.client_id),
              bufnr,
              filtered,
              {
                underline = true,
                virtual_text = {
                  spacing = 4,
                  prefix = "●",
                  severity = { min = vim.diagnostic.severity.WARN },
                },
                signs = true,
                update_in_insert = false,
                severity_sort = true,
              }
            )
          end,
        },
      })
    elseif server_name == "gopls" then
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          disable_formatting(client)
          on_attach(client, bufnr)
        end,
        settings = {
          gopls = {
            gofumpt = true,
          },
        },
        flags = {
          debounce_text_changes = 500,
        },
      })
    else
      lspconfig[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 500,
        },
        root_dir = lspconfig.util.root_pattern(".git", "."),
      })
    end
  else
    vim.notify(
      string.format("Executable '%s' for server '%s' not found! Server will not be enabled", lsp_executable, server_name),
      vim.log.levels.WARN,
      { title = "Nvim-config" }
    )
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_buf_conf", { clear = true }),
  callback = function(event_context)
    local client = vim.lsp.get_client_by_id(event_context.data.client_id)
    if not client then return end
    local bufnr = event_context.buf
    on_attach(client, bufnr)
  end,
  nested = true,
  desc = "Configure buffer keymap and behavior based on LSP",
})
