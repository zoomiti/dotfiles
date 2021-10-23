let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" CSS-Color
Plug 'ap/vim-css-color'

"Surround
Plug 'tpope/vim-surround'

"Latex
Plug 'lervag/vimtex'

" For snippets
Plug 'SirVer/ultisnips'

if has("nvim")
" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'  " For LSP completion

"Lean requires nvim
Plug 'Julian/lean.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'andrewradev/switch.vim'  " For Lean switch support
end

call plug#end()

" Conceal options
hi clear Conceal
set conceallevel=2
set concealcursor=n

" UltiSnips Config
let g:UltiSnipsExpandTrigger="<tab>"                                            
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"                                    

set encoding=utf-8

set completeopt=menu,menuone,noselect

" Tab AutoComplete
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction

inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Make
set makeprg=make\ --silent\ 2>&1\ \\\|\ grep\ -E\ \"^([^:\\S]+):\\S+:.+\"

syntax on

" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Autocompile dwmblocks
if has("nvim")
  autocmd BufWritePost ~/desktop/dwmblocks/blocks.h :term cd ~/desktop/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks > /dev/null 2> /dev/null ; }
else
  autocmd BufWritePost ~/desktop/dwmblocks/blocks.h !cd ~/desktop/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks > /dev/null 2> /dev/null & }
end

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on
" show existing tab with 4 spaces width"
set tabstop=4
" when indenting with '>', use 4 spaces width"
set shiftwidth=4
" On pressing tab, insert 4 spaces"
"set expandtab

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd            " Show (partial) command in status line.
set showmatch           " Show matching brackets.
"set ignorecase         " Do case insensitive matching
set smartcase           " Do smart case matching
"set incsearch          " Incremental search
set autowrite           " Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a            " Enable mouse usage (all modes)
set number              " Enable line numbers
set relativenumber      " Enable relative line numbers

" Terminal Settings
if has("nvim")
	" Enter terminal-mode automatically
	" autocmd TermOpen * startinsert
	autocmd BufEnter term://* startinsert
	" Disable line numbers on terminals
	autocmd TermOpen * :setlocal nonumber norelativenumber
	" allows you to use Ctrl-c on terminal window
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c><C-\><C-n>
	" Allows for esc to leave insert mode
	tnoremap <Esc> <C-\><C-n>
	" Allows for window navigation
	tnoremap <C-W><C-W> <C-\><C-N><C-W><C-W>
	tnoremap <C-W><C-N> <C-\><C-N>
	tnoremap <C-W>h <C-\><C-N><C-W>h
	tnoremap <C-W>j <C-\><C-N><C-W>j
	tnoremap <C-W>k <C-\><C-N><C-W>k
	tnoremap <C-W>l <C-\><C-N><C-W>l
	tnoremap <C-W><left> <C-\><C-N><C-W><left>
	tnoremap <C-W><down> <C-\><C-N><C-W><down>
	tnoremap <C-W><up> <C-\><C-N><C-W><up>
	tnoremap <C-W><right> <C-\><C-N><C-W><right>
end

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

" LSP Setup
if has("nvim")
lua <<EOF

	-- Setup nvim-cmp.
	local cmp = require'cmp'

	cmp.setup({
		snippet = {
			expand = function(args)
				-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				-- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
			end,
		},
		mapping = {
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			-- { name = 'vsnip' }, -- For vsnip users.
			-- { name = 'luasnip' }, -- For luasnip users.
			{ name = 'ultisnips' }, -- For ultisnips users.
			-- { name = 'snippy' }, -- For snippy users.
		}, {
			{ name = 'buffer' },
		})
	})

	-- Setup lspconfig.
	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	require('lspconfig')['texlab'].setup { capabilities = capabilities }

	local function on_attach(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
		buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
		buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	end
	require('lean').setup{
        -- Enable the Lean language server(s)?
        --
        -- false to disable, otherwise should be a table of options to pass to
        --  `leanls` and/or `lean3ls`.
        --
        -- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#leanls for details.

        -- Lean 4
        lsp = { on_attach = on_attach },

        -- Lean 3
        lsp3 = { on_attach = on_attach },

        -- Abbreviation support
        abbreviations = {
			-- Set one of the following to true to enable abbreviations
			builtin = true, -- built-in expander
			compe = false, -- nvim-compe source
			snippets = false, -- snippets.nvim source
			-- additional abbreviations:
			extra = {
				-- Add a \wknight abbreviation to insert ♘
				--
				-- Note that the backslash is implied, and that you of
				-- course may also use a snippet engine directly to do
				-- this if so desired.
				wknight = '♘',
			},
			-- Change if you don't like the backslash
			-- (comma is a popular choice on French keyboards)
			leader = '\\',
        },

        -- Enable suggested mappings?
        --
        -- false by default, true to enable
        mappings = true,

        -- Infoview support
        infoview = {
			-- Automatically open an infoview on entering a Lean buffer?
			autoopen = true,
			-- Set the infoview windows' widths
			width = 30,
        },

        -- Progress bar support
        progress_bars = {
			-- Enable the progress bars?
			enable = true,
			-- Use a different priority for the signs
			priority = 10,
        },
    }
EOF
end
