 "=====================
" Basic & General
"=====================
set nocompatible nu rnu smartindent autoindent wildmenu cursorline backup writebackup termguicolors expandtab ignorecase smartcase undofile
filetype plugin indent on
syntax on
set tabstop=4 shiftwidth=4
set foldmethod=indent foldlevel=3
set backupdir=~/.config/nvim/tmp
set undodir=~/.config/nvim/tmp
set signcolumn=yes
set updatetime=300
" set pastetoggle=<F2>
set spelllang=en_gb,nl

let mapleader = ","
let maplocalleader = "L"

" Save file as root
command! SW w !sudo tee % > /dev/null
command! PU PlugUpdate
command! PI PlugInstall

" Restore cursor when reopening file
autocmd BufReadPost * silent! normal! g`"

" Spell toggle
nnoremap <leader>EN :setlocal spell spelllang=en_gb<CR>
nnoremap <leader>NL :setlocal spell spelllang=nl_NL<CR>

"=====================
" Plugin Section
"=====================
call plug#begin('~/.config/nvim/plugged')

" Snippets
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" Plug 'hrsh7th/vim-vsnip'
" Plug 'hrsh7th/vim-vsnip-integ'
" Plug 'rafamadriz/friendly-snippets'

" Table mode
Plug 'dhruvasagar/vim-table-mode'

" Theme
Plug 'ellisonleao/gruvbox.nvim'
Plug 'NLKNguyen/papercolor-theme'

" File Explorer
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-lua/plenary.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" LSP, Autocompletion, Rust
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
"Plug 'simrat39/rust-tools.nvim'
Plug 'mrcjkb/rustaceanvim'
" Git integration
Plug 'lewis6991/gitsigns.nvim'

" Status line
Plug 'nvim-lualine/lualine.nvim'

" Commenting
Plug 'numToStr/Comment.nvim'

" Undo tree
Plug 'mbbill/undotree'

" Go
Plug 'fatih/vim-go'

" NERDTree - or its replacement: nvim-tree
Plug 'nvim-tree/nvim-tree.lua'

" Tagbar
Plug 'preservim/tagbar'

" Dates
Plug 'tpope/vim-speeddating'

" Debuggers
Plug 'puremourning/vimspector'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'


" statusline
Plug 'bling/vim-airline'

" AI slop
Plug 'greggh/claude-code.nvim'
Plug 'xTacobaco/cursor-agent.nvim'

call plug#end()

let g:go_highlight_string_spellcheck=1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_snippet_case_type = "camelcase"
let g:go_auto_sameids = 1
let g:go_highlight_generate_tags = 1
let g:go_gocode_unimported_packages = 1
" let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 0
let g:go_def_mode='gopls'
let g:go_info_mode = 'gopls'
let g:go_fmt_command="gofumpt"
let g:go_gopls_gofumpt=1
let g:go_debug_windows = {
          \ 'vars':       'leftabove 50vnew',
          \ 'stack':      'leftabove 10new',
          \ 'goroutines': 'botright 5new',
\ }
" disable vim-go's omnifunc in favour of nvim-cmp
let g:go_code_completion_enabled = 0
" Golang tagbar settings.
" Tagbar for gofile => install ctags
let g:tagbar_type_go = {
			\ 'ctagstype' : 'go',
			\ 'kinds'     : [
			\ 'p:package',
			\ 'i:imports:1',
			\ 'c:constants',
			\ 'v:variables',
			\ 't:types',
			\ 'n:interfaces',
			\ 'w:fields',
			\ 'e:embedded',
			\ 'm:methods',
			\ 'r:constructor',
			\ 'f:functions'
			\ ],
			\ 'sro' : '.',
			\ 'kind2scope' : {
			\ 't' : 'ctype',
			\ 'n' : 'ntype'
			\ },
			\ 'scope2kind' : {
			\ 'ctype' : 't',
			\ 'ntype' : 'n'
			\ },
			\ 'ctagsbin'  : 'gotags',
			\ 'ctagsargs' : '-sort -silent',
			\ 'async' : 1
			\ }


"=====================
" Lua-based Config
"=====================
lua require('config.lsp')
lua require('config.rust')
"lua require('config.rusttools')
lua require('config.autocomplete')
lua require('config.treesitter')
lua require('config.editor')
lua require('config.tree')
lua require('config.tagbar')
lua require('config.keys')
lua require('config.claude')
lua require('config.cursor')
"=====================
" Restore colorscheme
"=====================
"colorscheme gruvbox
colorscheme PaperColor
"lua require('claude-code').setup()

" Claude API key
"=====================
" Misc mappings
"=====================
nnoremap <leader>U :UndotreeToggle<CR>

" Fold settings
set foldmethod=indent
" Optional: open folds manually as needed.

" FZF remaps
" If migrating from FZF, add this after fzf is installed:
" nnoremap <leader>pf :Telescope find_files<CR>
" nnoremap <leader>ps :Telescope live_grep<CR>
nnoremap <leader>et :tabe ~/.config/nvim/init.vim<CR>
inoremap jj <esc>
" Easier to remember to exit terminal input mode
tnoremap <C-j><C-k> <C-\><C-n>
