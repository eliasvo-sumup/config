-- Automatically open NERDTree in the current working directory if no file is specified
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("NERDTreeToggle")
    end
  end,
})

-- Map <leader>tf to NERDTreeFind
vim.keymap.set('n', '<leader>tf', ':NERDTreeFind<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tt', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tc', ':NERDTreeCWD<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ts', ':NERDTreeFocus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tx', ':NERDTreeClose<CR>', { noremap = true, silent = true })

