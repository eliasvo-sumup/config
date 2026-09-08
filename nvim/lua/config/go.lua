-- config lsp
local lspconfig = require("lspconfig")
lspconfig.gopls.setup {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shaduw = true,
            },
            staticcheck = true,
        },
    }
}
-- Optional: Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    -- Only call vim-go format if gofmt/gofumpt is set up via vim-go
    vim.cmd("silent! GoFmt")
  end,
})

-- Optional: Lint on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.go",
  callback = function()
    -- for now, no need to run linter on save
    -- vim.cmd("silent! GoLint")
  end,
})
