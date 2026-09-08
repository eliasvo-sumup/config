-- Telescope
vim.api.nvim_set_keymap('n','<leader>ff','<cmd>Telescope find_files<CR>',{noremap=true,silent=true})
vim.api.nvim_set_keymap('n','<leader>fg','<cmd>Telescope live_grep<CR>',{noremap=true,silent=true})
vim.api.nvim_set_keymap('n','<leader>fb','<cmd>Telescope buffers<CR>',{noremap=true,silent=true})
-- Nvim-tree toggle
vim.api.nvim_set_keymap('n','<leader>e','<cmd>NvimTreeToggle<CR>',{noremap=true,silent=true})

-- Gitsigns
require('gitsigns').setup()

-- Comment.nvim
require('Comment').setup()

-- Lualine for statusline
require('lualine').setup {
  options = { theme = 'gruvbox' }
}

local delete_hidden_bufs = function()
  local in_tab = {}
  -- map all buffers currently active in any tab.
  for tab = 1, vim.fn.tabpagenr('$') do
    for _, buf in ipairs(vim.fn.tabpagebuflist(tab)) do
      in_tab[buf] = true
    end
  end

  -- now iterate over all buffers
  for buf = 1, vim.fn.bufnr('$') do
    -- buffer exists, but not in any of the tabs, close it.
    if vim.fn.bufexists(buf) == 1 and not in_tab[buf] then
      vim.cmd('silent bwipeout ' .. buf)
    end
  end
end

vim.keymap.set('n', '<leader>DH', delete_hidden_bufs, { noremap = true, silent = true })
