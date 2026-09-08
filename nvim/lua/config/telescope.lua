-- config/telescope_tree.lua - Alternative Telescope-based file browser
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local fb_status_ok, fb_actions = pcall(require, "telescope._extensions.file_browser.actions")
if not fb_status_ok then
  return
end

telescope.setup({
  extensions = {
    file_browser = {
      theme = "ivy",
      -- Disable netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- Custom insert mode mappings
          ["<A-c>"] = fb_actions.create,
          ["<S-CR>"] = fb_actions.create_from_prompt,
          ["<A-r>"] = fb_actions.rename,
          ["<A-m>"] = fb_actions.move,
          ["<A-y>"] = fb_actions.copy,
          ["<A-d>"] = fb_actions.remove,
          ["<C-o>"] = fb_actions.open,
          ["<C-g>"] = fb_actions.goto_parent_dir,
          ["<C-e>"] = fb_actions.goto_home_dir,
          ["<C-w>"] = fb_actions.goto_cwd,
          ["<C-t>"] = fb_actions.change_cwd,
          ["<C-f>"] = fb_actions.toggle_browser,
          ["<C-h>"] = fb_actions.toggle_hidden,
          ["<C-s>"] = fb_actions.toggle_all,
        },
        ["n"] = {
          -- Custom normal mode mappings
          ["c"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["m"] = fb_actions.move,
          ["y"] = fb_actions.copy,
          ["d"] = fb_actions.remove,
          ["o"] = fb_actions.open,
          ["g"] = fb_actions.goto_parent_dir,
          ["e"] = fb_actions.goto_home_dir,
          ["w"] = fb_actions.goto_cwd,
          ["t"] = fb_actions.change_cwd,
          ["f"] = fb_actions.toggle_browser,
          ["h"] = fb_actions.toggle_hidden,
          ["s"] = fb_actions.toggle_all,
        },
      },
    },
  },
})

-- Load the file browser extension
telescope.load_extension("file_browser")

-- Auto-open file browser when opening a file
local function open_telescope_browser(data)
  -- Buffer is a file
  local file = data.file ~= "" and vim.fn.filereadable(data.file) == 1
  
  -- Buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1
  
  if not file and not directory then
    return
  end
  
  if directory then
    -- Change to the directory and open browser
    vim.cmd.cd(data.file)
    vim.cmd("Telescope file_browser")
  else
    -- Open browser in the file's directory
    local file_dir = vim.fn.expand("%:p:h")
    vim.cmd("Telescope file_browser path=" .. file_dir)
  end
end

-- Uncomment the line below if you want auto-open behavior
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_telescope_browser })

-- Key mappings for Telescope file browser
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Open file browser in current working directory
keymap("n", "<leader>Tt", ":Telescope file_browser<CR>", opts)

-- Open file browser in current file's directory (equivalent to :NERDTreeFind)
keymap("n", "<leader>Tf", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)

-- Open file browser in home directory
keymap("n", "<leader>th", ":Telescope file_browser path=~<CR>", opts)

-- Additional telescope mappings for file operations
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
-- this might become the quick/common keybind (leader + G for grep)
keymap("n", "<leader>G", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)
