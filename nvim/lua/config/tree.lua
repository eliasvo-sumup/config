-- config/tree.lua - nvim-tree configuration
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

-- Disable netrw (recommended by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- open new tab for given node.
local function spawn_bg_tab(node)
  local api = require "nvim-tree.api"
  -- Save the current window and tabpage
  local current_win = vim.api.nvim_get_current_win()
  local current_tab = vim.api.nvim_get_current_tabpage()

  -- Open the node in a new tab (this will switch to the new tab)
  api.node.open.tab(node)

  -- Check if the previous window & tabpage are still valid, then return focus
  if vim.api.nvim_win_is_valid(current_win) and vim.api.nvim_tabpage_is_valid(current_tab) then
    vim.api.nvim_set_current_tabpage(current_tab)
    vim.api.nvim_set_current_win(current_win)
  end
end

-- create t and T bindings for tabs
local function custom_key_binds(bufnr)
    local api = require "nvim-tree.api"
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- preserve default mappings (ie apply the defaults, in case we override any)
    api.config.mappings.default_on_attach(bufnr)
    -- I kind of like the ? for help instead of g?
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    -- bind t to open file in a new tab.
    vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set("n", "T", function()
        local node = api.tree.get_node_under_cursor()
        spawn_bg_tab(node)
    end, opts("Open: New Tab - background"))
end


-- Setup nvim-tree
nvim_tree.setup({
  -- Auto open tree when opening a file
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  
  -- File system watcher
  filesystem_watchers = {
    enable = true,
  },
  
  -- Git integration
  git = {
    enable = true,
    ignore = false,
  },
  
  -- Renderer options
  renderer = {
    highlight_git = true,
    highlight_opened_files = "name",
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  
  -- Actions
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
  
  -- Filters
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  
  -- Update focused file
  update_focused_file = {
    enable = true,
    update_root = true,  -- Allow changing root when finding files outside current tree
    ignore_list = {},
  },

    -- custom keybinds
    on_attach = custom_key_binds,
})

-- Auto-open nvim-tree when opening a file (not a directory)
local function open_nvim_tree(data)
  -- Buffer is a file
  local file = data.file ~= "" and vim.fn.filereadable(data.file) == 1
  
  -- Buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1
  
  if not file and not directory then
    return
  end
  
  if directory then
    -- Change to the directory
    vim.cmd.cd(data.file)
    -- Open the tree
    require("nvim-tree.api").tree.open()
  else
    -- Just open the tree showing PWD, don't expand anything
    require("nvim-tree.api").tree.open()
    -- Focus back to the file buffer
    vim.cmd("wincmd p")
  end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Function to get current path context for Telescope
local function get_telescope_path()
  -- Check if nvim-tree is focused
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(current_buf)
  
  if string.match(buf_name, "NvimTree_") then
    -- We're in nvim-tree, get the highlighted node path
    local api = require("nvim-tree.api")
    local node = api.tree.get_node_under_cursor()
    
    if node then
      if node.type == "directory" then
        return node.absolute_path
      else
        -- If it's a file, return its parent directory
        return vim.fn.fnamemodify(node.absolute_path, ":h")
      end
    end
  end
  
  -- Fallback: use current buffer's directory or PWD
  local current_file = vim.fn.expand("%:p")
  if current_file ~= "" then
    return vim.fn.fnamemodify(current_file, ":h")
  else
    return vim.fn.getcwd()
  end
end

-- Function to open Telescope with smart path detection
local function telescope_smart_find()
  local path = get_telescope_path()
  require('telescope.builtin').find_files({ cwd = path })
end

-- Function to open Telescope live grep with smart path detection
local function telescope_smart_grep()
  local path = get_telescope_path()
  require('telescope.builtin').live_grep({ cwd = path })
end

-- Key mappings
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- nvim-tree mappings (using different keys to avoid leader conflict)
keymap("n", "<leader>tt", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>tf", ":NvimTreeFindFile<CR>", opts)
keymap("n", "<leader>tr", ":NvimTreeFocus<CR>", opts)
keymap("n", "<leader>tR", ":NvimTreeRefresh<CR>", opts)
keymap("n", "<leader>tc", ":NvimTreeClose<CR>", opts)  -- Changed from tc to tq to avoid conflict

-- Telescope integration mappings
keymap("n", "<leader>F", telescope_smart_find, opts)
keymap("n", "<leader>G", telescope_smart_grep, opts)
