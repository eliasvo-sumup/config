-- Setup vimspector keys for Rust
local vimspector_keys = {
  { mode = "n", lhs = "<F9>", rhs = "<cmd>call vimspector#Launch()<CR>" },
  { mode = "n", lhs = "<F5>", rhs = "<cmd>call vimspector#StepOver()<CR>" },
  { mode = "n", lhs = "<F8>", rhs = "<cmd>call vimspector#Reset()<CR>" },
  { mode = "n", lhs = "<F11>", rhs = "<cmd>call vimspector#StepOver()<CR>" },
  { mode = "n", lhs = "<F12>", rhs = "<cmd>call vimspector#StepOut()<CR>" },
  { mode = "n", lhs = "<F10>", rhs = "<cmd>call vimspector#StepInto()<CR>" },
  { mode = "n", lhs = "<leader>DB",  rhs = ":call vimspector#ToggleBreakpoint()<CR>" },
  { mode = "n", lhs = "<leader>DW",  rhs = ":call vimspector#AddWatch()<CR>" },
  { mode = "n", lhs = "<leader>DE",  rhs = ":call vimspector#Evaluate()<CR>" },
}

-- Setup vim-go keys for Go
local vimgo_keys = {
  { mode = "n", lhs = "<F9>", rhs = ":GoDebugStart<CR>" },       -- launch/start debug session
  { mode = "n", lhs = "<F5>", rhs = ":GoDebugNext<CR>" },        -- step over
  { mode = "n", lhs = "<F8>", rhs = ":GoDebugStop<CR>" },        -- reset/stop debug session
  { mode = "n", lhs = "<F11>", rhs = ":GoDebugNext<CR>" },       -- step over (same as F5)
  { mode = "n", lhs = "<F12>", rhs = ":GoDebugStepOut<CR>" },    -- step out (vim-go may not have this, fallback to stop)
  { mode = "n", lhs = "<F10>", rhs = ":GoDebugStep<CR>" },       -- step into
  { mode = "n", lhs = "<leader>DB",  rhs = ":GoDebugBreakpoint<CR>" }, -- toggle breakpoint
  -- vim-go does not have AddWatch or Evaluate equivalents, so omit those or map to echo for now:
  { mode = "n", lhs = "<leader>DW",  rhs = ":echo 'AddWatch not supported in vim-go'<CR>" },
  { mode = "n", lhs = "<leader>DE",  rhs = ":echo 'Evaluate not supported in vim-go'<CR>" },
}

local function set_mappings_for_buffer(keys)
  local bufnr = vim.api.nvim_get_current_buf()
  for _, key in ipairs(keys) do
    vim.keymap.set(key.mode, key.lhs, key.rhs, { noremap = true, silent = true, buffer = bufnr })
  end
end

-- Create autocmd group
local group = vim.api.nvim_create_augroup("DebugKeymaps", { clear = true })

-- Rust FileType autocmd for vimspector keys
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "rust",
  callback = function()
    set_mappings_for_buffer(vimspector_keys)
  end,
})

-- Go FileType autocmd for vim-go keys
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "go",
  callback = function()
    set_mappings_for_buffer(vimgo_keys)
  end,
})

-- quickly comment/uncomment blocks of code.

local comment_delims = {
  tf = "// ",
  c = "// ",
  cpp = "// ",
  php = "// ",
  java = "// ",
  scala = "// ",
  go = "// ",
  javascript = "// ",
  groovy = "// ",
  rust = "// ",
  sh = "# ",
  python = "# ",
  ruby = "# ",
  bash = "# ",
  yaml = "# ",
  dockerfile = "# ",
  conf = "# ",
  make = "# ",
  sshconfig = "# ",
  dosini = ";; ",
  scheme = ";; ",
  lisp = ";; ",
  clojure = ";; ",
  gitconfig = ";; ",
  sql = "-- ",
  elm = "-- ",
  haskell = "-- ",
  erlang = "%% ",
  vim = '" ',
}

local function get_comment_delim()
  local ft = vim.bo.filetype
  return comment_delims[ft] or (vim.bo.commentstring:gsub("%%s", "") or "# ")
end

local function comment_line()
  local delim = get_comment_delim()
  vim.api.nvim_feedkeys('^i' .. delim, 'n', false)
end

local function uncomment_line()
  -- Delete comment delimiter at the beginning of line
  local delim = get_comment_delim()
  local pattern = "^%s*" .. vim.pesc(delim)
  vim.cmd(string.format("silent! execute 'normal! 0' | silent! s/%s//", pattern))
end

local function comment_visual()
  local delim = get_comment_delim()
  vim.cmd("'<,'>normal! I" .. delim)
end

local function append_mode_line()
  local comment_m = get_comment_delim() -- Using your provided function
  local expandtab_str = vim.o.expandtab and '' or 'no'

  local modeline = string.format(
    "%s vim: set ts=%d sw=%d tw=%d foldlevel=%d foldmethod=%s %set :",
    comment_m,
    vim.o.tabstop,
    vim.o.shiftwidth,
    vim.o.textwidth,
    vim.o.foldlevel,
    vim.o.foldmethod,
    expandtab_str
  )

  vim.fn.append(vim.fn.line('$'), modeline)
end

-- tagbar controls
vim.keymap.set('n', '<leader>tb', ':TagbarToggle<CR>', { desc='Toggle tagbar', noremap=true, silent=true })
vim.keymap.set('n', '<leader>gt', ':TagbarJump<CR>', { desc='Jump to tag under cursor', noremap=true, silent=true })

-- nnoremap append mode line to bottom of file.
vim.keymap.set('n', '<Leader>ml', append_mode_line, { silent = true })

-- Normal mode mappings
vim.keymap.set('n', '<leader>cc', comment_line, { desc = 'Comment line' })
vim.keymap.set('n', '<leader>uc', uncomment_line, { desc = 'Uncomment line' })

-- Visual mode mapping
vim.keymap.set('v', '<leader>cc', comment_visual, { desc = 'Comment selection' })

-- Diagnostic key mappings (global)
vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, { desc='Show diagnostic float', noremap=true, silent=true })

-- Quickly add hashbang
vim.keymap.set('n', '<leader>hb', 'ggi#!<Esc>:read !which env<CR>kA<Del><ESC>A bash<CR>', { desc='Quick bind to add hashbang', noremap=true, silent=true })

-- JSON formatting
local function json_format_buffer()
    vim.cmd("%!jq .")
end

local function json_format_ln()
    vim.cmd(vim.fn.line(".") .. "!jq .")
end
vim.keymap.set('n', '<leader>jq', json_format_ln, { desc='Format current line using jq', noremap=true, silent=true })
vim.keymap.set('n', '<leader>JQ', json_format_buffer, { desc='Format entire buffer using jq - assumes valid JSON', noremap=true, silent=true })

-- Cursor agent binds
vim.keymap.set("n", "<leader>cu", ":CursorAgent<CR>", { desc = "Cursor Agent: Toggle terminal" , noremap=true, silent=true })
-- Ask about selection
vim.keymap.set("v", "<leader>cu", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: Send selection", noremap=true, silent=true  })
-- Ask about buffer
vim.keymap.set("n", "<leader>cU", ":CursorAgentBuffer<CR>", { desc = "Cursor Agent: Send buffer", noremap=true, silent=true  })
-- Toggle cursor agent while in terminal mode
vim.keymap.set("t", "<C-c><C-u>", "<CMD>CursorAgent<CR>", { desc = "Toggle cursor agent from terminal mode", noremap=true })
vim.keymap.set("t", "<C-c><C-c>", "<CMD>ClaudeCode<CR>", { desc = "Toggle claude agent from terminal mode", noremap=true })

-- LSP info
vim.keymap.set("n", "<leader>ls", ":lua print(vim.inspect(vim.lsp.get_clients()))<cr>", { desc = "Print LSP client info", silent=true, noremap=true })
vim.keymap.set("n", "<leader>lb", function()
  vim.cmd.tabnew()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.bo.buflisted = false
  vim.api.nvim_put(vim.split(vim.inspect(vim.lsp.get_clients()), "\n"), "", true, true)
end, { desc = "Print LSP client info to a new buffer", silent = true , noremap=true })
