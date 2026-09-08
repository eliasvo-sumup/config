require("mason").setup()
-- ensure LSP's are installed
-- require("mason-lspconfig").setup({
    -- ensure_installed = { "taplo", "pyright", "marksman", "bash-language-server", "lua-language-server", "eslint-lsp", "eslint_d" }
    -- for some reason, eslint-lsp doesn't work woth ensure_installed.
    -- ensure_installed = { "taplo", "pyright", "marksman", "bash-language-server", "lua-language-server", "zls" }
-- })

local configs = require('lspconfig.configs')
-- local lspconfig = require("lspconfig")

vim.lsp.config.gopls = {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
        },
    }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Toml
vim.lsp.config.taplo = {
    filetypes = { "toml" },
    on_attach = function(client, bufnr)
        vim.bo[bufnr].tabstop = 2
        vim.bo[bufnr].shiftwidth = 2
        vim.bo[bufnr].expandtab = true
    end,
    capabilities = capabilities,
}

local attach_cb = function(cl, bn)
    local opts = { noremap = true, silent = true, buffer = bn }
    vim.keymap.set('n', '<leader>LL', vim.cmd.LspLog, opts)
end

-- Lua, special case because nvim use.
vim.lsp.config.lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } }, -- Stop "undefined global 'vim'" warning
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
    capabilities = capabilities,
    on_attach = function(cl, bn)
        local opts = { noremap = true, silent = true, buffer = bn }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        attach_cb(cl, bn)
    end,
    filetypes = { "lua" },
}

-- Python
-- lspconfig.pyright.setup {
vim.lsp.config.pyright =  {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "python" },
}

-- Markdown
-- lspconfig.marksman.setup {
vim.lsp.config.marksman =  {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "markdown" },
}

-- Shell scripts
vim.lsp.config.bashls = { 
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "bash", "sh", "zsh" },
}

-- JS/TS
-- lspconfig.eslint.setup {
vim.lsp.config.eslint =  {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}

-- Zig
-- lspconfig.zls.setup {
vim.lsp.config.zls =  {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "zig" },
}

-- vim.lsp.config only defines configs; it doesn't start clients.
-- vim.lsp.enable is what registers the autocmds that attach on matching filetypes.
vim.lsp.enable({ "gopls", "taplo", "lua_ls", "pyright", "marksman", "bashls", "eslint", "zls" })
