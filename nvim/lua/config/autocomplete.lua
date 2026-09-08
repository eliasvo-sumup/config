local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args) require 'luasnip'.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
            ['<Down>'] = cmp.mapping.select_next_item(),
            ['<Up>'] = cmp.mapping.select_prev_item(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
})
