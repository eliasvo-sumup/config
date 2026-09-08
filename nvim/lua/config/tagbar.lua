-- Autocmd to open tagbar if editing a code file
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.go", "*.rs", "*.sh", "*.vim", "*.lua" },
  callback = function()
    local winid = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(winid)

    -- Don't open Tagbar if we're in a floating/preview window
    if vim.b.tagbar_opened or config.relative ~= "" or vim.fn.bufwinnr('Tagbar') ~= -1 then
      return
    end

    -- mark tagbar as opened
    vim.b.tagbar_opened = true
    -- get the current focused window/buffer
    local current_win = vim.api.nvim_get_current_win()
    -- Defer execution slightly to avoid race with Telescope closing windows
    vim.defer_fn(function()
      -- Re-check the window is still valid and not floating
      local valid = vim.api.nvim_win_is_valid(winid)
      local still_floating = vim.api.nvim_win_get_config(winid).relative ~= ""
      if valid and not still_floating then
        vim.cmd("silent! TagbarOpenAutoClose")
        -- now that we've opened the tagbar, return focus to the original window/buffer.
        if vim.api.nvim_win_is_valid(current_win) then
            vim.api.nvim_set_current_win(current_win)
        end
      end
    end, 100) -- 100ms delay to avoid window-closing race
  end,
})

-- Close tagbar if last code buffer is closed
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    local filetype = vim.bo.filetype
    if vim.fn.bufwinnr('Tagbar') ~= -1 and vim.fn.winnr('$') == 1 then
      vim.cmd("TagbarClose")
    end
  end,
})
