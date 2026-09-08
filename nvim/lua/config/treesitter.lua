require('nvim-treesitter').setup {
    ensure_installed = { "rust", "lua", "vim", "bash", "markdown", "json" , "go", "gomod", "gowork", "gosum" },
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
      move = {
        enable = true,
        set_jumps = true, -- rec jumplis.
        goto_next_start = {
          ["]m"] = "@function.outer", -- this should jump between funcs.
          ["]c"] = "@class.outer", -- jump "classes", which specifically are structs, enums, and impl blocks.
        },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
  },
}
