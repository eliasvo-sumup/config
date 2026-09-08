require("rust-tools").setup {
  server = {
    on_attach = function(_, bufnr)
      local opts = { noremap=true, silent=true }
      local buf = function(mode, key, cmd)
        vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, opts)
      end
      buf('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>')
      buf('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
      buf('n','<leader>f','<cmd>lua vim.lsp.buf.format()<CR>')
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        check = { command = "clippy" },
        procMacro = { enable = true },
      }
    }
  }
}
