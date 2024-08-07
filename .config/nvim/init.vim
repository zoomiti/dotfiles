" Plugged setup {{{
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" auto pairs
Plug 'LunarWatcher/auto-pairs'

" Lightline
Plug 'itchyny/lightline.vim'

" CSS-Color
Plug 'ap/vim-css-color'

"Surround
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" For snippets
Plug 'SirVer/ultisnips'

" Vifm replacing netrw
Plug 'vifm/vifm.vim'

" Git nuff said
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Latex
Plug 'lervag/vimtex'

" Rust
if has("nvim")
	Plug 'mrcjkb/rustaceanvim'
	Plug 'rayliwell/nvim-ts-autotag'
else
	Plug 'rust-lang/rust.vim'
	let g:rustfmt_autosave = 1
endif

" Markdown
Plug 'preservim/vim-markdown'

" Table mode
Plug 'dhruvasagar/vim-table-mode'

" Color schemes
Plug 'zoomiti/firewatch'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'sjl/badwolf'
if !has("nvim")
	Plug 'lifepillar/vim-colortemplate'
endif

if has("nvim")
" Neoconf
Plug 'folke/neoconf.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'

Plug 'andythigpen/nvim-coverage'

" Cmp
Plug 'hrsh7th/nvim-cmp'  
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'petertriho/cmp-git'
Plug 'f3fora/cmp-spell'
" Plug 'hrsh7th/cmp-copilot'
Plug 'onsails/lspkind.nvim'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Diagnostics
Plug 'folke/trouble.nvim'

" Telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'nvim-neorg/neorg-telescope'
Plug 'kyazdani42/nvim-web-devicons'

" Debugging
Plug 'mfussenegger/nvim-dap'

" Lean requires nvim
" Plug 'Julian/lean.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'andrewradev/switch.vim'  " For Lean switch support
Plug 'norcalli/nvim-colorizer.lua' " For colorizing

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/spellsitter.nvim'
Plug 'rayliwell/tree-sitter-rstml'

" Neorg
Plug 'nvim-neorg/neorg'

" Copilot
" Plug 'github/copilot.vim'

Plug 'folke/which-key.nvim'
endif

call plug#end()
" }}}

" Vim Config {{{

set encoding=utf-8

set completeopt=menu,menuone,noselect,noinsert

syntax on

" Uncomment the following to have Vim jump to the last position when
" reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


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
set incsearch          " Incremental search
set autowrite           " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a            " Enable mouse usage (all modes)
set mousemodel=popup
set number              " Enable line numbers
set relativenumber      " Enable relative line numbers
set title				" Changes terminal title when started
set scrolloff=15

" Vim remaps {{{
nnoremap <Space> <nop>
let mapleader=" "
let maplocalleader=" "
nnoremap <silent> <Enter> :nohl<CR><Enter>
if has('nvim') 
	nnoremap <leader>b <cmd>Telescope buffers<CR>
	nnoremap <C-/> <cmd>lua require("telescope.builtin").current_buffer_fuzzy_find(require('telescope.themes').get_ivy())<CR>
	nnoremap <leader>f <cmd>Telescope find_files<CR>
	nnoremap <leader>p <cmd>Telescope git_files<CR>
	nnoremap <leader>t <cmd>bel 15sp \| term<CR><cmd>startinsert<CR>
else
	nnoremap <leader>b <cmd>ls<CR>:b<Space>
	nnoremap <leader>s <cmd>ls<CR>:sb<Space>
	nnoremap <leader>t <cmd>bel term<CR>
endif


noremap ; l
noremap l k
noremap k j
noremap j h
noremap h ;

nnoremap [q <cmd>:cprev<CR>
nnoremap ]q <cmd>:cnext<CR>

noremap <C-W>j <C-\><C-N><C-W>h
noremap <C-W>k <C-\><C-N><C-W>j
noremap <C-W>l <C-\><C-N><C-W>k
noremap <C-W>; <C-\><C-N><C-W>l

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
	tnoremap <C-W>j <C-\><C-N><C-W>h
	tnoremap <C-W>k <C-\><C-N><C-W>j
	tnoremap <C-W>l <C-\><C-N><C-W>k
	tnoremap <C-W>; <C-\><C-N><C-W>l
	tnoremap <C-W><left> <C-\><C-N><C-W><left>
	tnoremap <C-W><down> <C-\><C-N><C-W><down>
	tnoremap <C-W><up> <C-\><C-N><C-W><up>
	tnoremap <C-W><right> <C-\><C-N><C-W><right>
endif

" }}}

" }}}

" Colors {{{
if has('termguicolors')
	if &term =~ 'alacritty'
		set t_8f=[38;2;%lu;%lu;%lum
		set t_8b=[48;2;%lu;%lu;%lum
	endif
	set termguicolors
endif
let g:dark_transp_bg = 1
" Deprecated becase of last line
" if has('nvim')
" 	au ColorScheme * hi Normal ctermbg=none guibg=none|hi LineNr guibg=none ctermbg=none|hi Folded guibg=none ctermbg=none|hi NonText guibg=none ctermbg=none|hi SpecialKey guibg=none ctermbg=none|hi VertSplit guibg=none ctermbg=none|hi SignColumn guibg=none ctermbg=none|hi EndOfBuffer guibg=none ctermbg=none
" endif
colorscheme fire
" }}}

" LightLine config {{{
set noshowmode
let g:lightline = {
	\ 'enable': {
	\ 	'statusline': 1,
	\ 	'tabline': 1,
	\ },
	\ 'colorscheme': 'fire',
	\ 'active' : {
	\ 'left' : [ [ 'mode', 'paste' ],
	\            [ 'readonly', 'branch', 'filename', 'modified' ]]
	\ },
	\ 'component_function': {
	\ 	'branch': 'LightlineBranch',
	\	'filename': 'LightlineFilename',
	\	'readonly': 'LightlineReadonly',
	\ },
	\ }

function! LightlineFilename()
  return &filetype ==# 'fugitive' ? fugitive#statusline() :
  		\ &filetype ==# 'qf' ? 'QuickFix' :
  		\ &filetype ==# 'Trouble' ? 'Trouble' :
        \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !~# '\v(help|fugitive|Trouble)' ? 'RO' : ''
endfunction

function! LightlineBranch()
	return &filetype !~# '\v(help|fugitive|qf|Trouble)' ? FugitiveHead() : ''
endfunction

" }}}

" Conceal options {{{
hi clear Conceal
set conceallevel=2
set concealcursor=n
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" UltiSnips Config {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" }}}

" Fugitive Config {{{
nnoremap <leader>gs :G<CR>
nnoremap <leader>gp :G pull<CR>
nnoremap <leader>gP :G push<CR>
set updatetime=100
" }}}

" VIFM {{{
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let g:vifm_replace_netrw = 1
let g:vifm_embed_split = 1
let g:vifm_exec = "vifmrun"
nnoremap <silent> gx :!xdg-open <c-r>=shellescape(expand('<cfile>'))<cr><cr>
command! Vex vertical VsplitVifm
command! Sex SplitVifm
command! Ex Vifm
" }}}

" Markdown config {{{
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_folding_disabled = 1

" }}}

" Auto-Pairs config {{{
let g:AutoPairsMapBS = 1

" }}}


" Autocompile dwmblocks {{{
if has("nvim")
	autocmd BufWritePost ~/desktop/dwmblocks/blocks.h :term cd ~/desktop/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks > /dev/null 2> /dev/null ; }
else
	autocmd BufWritePost ~/desktop/dwmblocks/blocks.h !cd ~/desktop/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks > /dev/null 2> /dev/null & }
endif
" }}}

" Make
" set makeprg=make\ --silent\ 2>&1\ \\\|\ grep\ -E\ \"^([^:\\S]+):\\S+:.+\"


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
	source /etc/vim/vimrc.local
endif

" Lua Setup {{{

if has("nvim")
	lua << EOF
	vim.loader.enable()
	require('neoconf').setup{}

	require('telescope').setup{}

	require('telescope').load_extension('fzf')
	require('telescope').load_extension('ui-select')
	
	
	-- Setup treesitter
	require'nvim-treesitter.configs'.setup { --{{{
		-- A list of parser names, or "all"
		ensure_installed = { "c", "lua", "vim" }, --"rust"

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- List of parsers to ignore installing (for "all")
		ignore_install = { "javascript" },

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			disable = { 'latex', 'markdown' },

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
			},

		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
				}
			},

		indent = {
			enable = true,
			},

		playground = {
			enable = true,
			},
		} --}}}
	require('spellsitter').setup()
	require('tree-sitter-rstml').setup()
	require('nvim-ts-autotag').setup()

	require'colorizer'.setup()

	-- Setup nvim-cmp.
	-- {{{
	local cmp = require'cmp'
	local lspkind = require'lspkind'
	local cmp_ultisnips_mappings = require'cmp_nvim_ultisnips.mappings'

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body) 
			end,
		},
		mapping = {
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
			['<tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
				end
			end, { 'i', 's' }),
			['<S-tab>'] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					cmp_ultisnips_mappings.jump_backwards(fallback)
				end
			end, { 'i', 's' }),
		},
		sources = cmp.config.sources({
			{ name = 'path' },
			{ name = 'nvim_lsp' },
			{ name = 'nvim_lsp_signature_help' },
			{ name = 'neorg' },
			{ name = 'nvim_lua' },
			{ name = 'ultisnips' },
			{ name = 'spell',
			  option = {
				  enable_in_context = function()
                      return true --require('cmp.config.context').in_treesitter_capture('spell')
                  end,
			  },
			  keyword_length = 3,
			},
			{ name = "git" },
		}, {
			{ name = 'buffer', keyword_length = 5},
		}),
		--{{{
		--window = {
		--	completion = cmp.config.window.bordered(),
		--	documentation = cmp.config.window.bordered(),
		--},
		--}}}
		formatting = {
			format = lspkind.cmp_format {
				with_text = true,
				menu = {
					buffer = "[buf]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[api]",
					path = "[path]",
					ultisnips = "[snip]",
					spell = "[spell]",
					git = "[git]"
					--copilot = "[cop]",
				},
			},
		},
	})
	require("cmp_git").setup()
	-- }}}

	-- Setup lspconfig.
	local capabilities = require('cmp_nvim_lsp').default_capabilities()

	local function on_attach(client, bufnr)
		vim.lsp.inlay_hint.enable(bufnr, true)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
		buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
		buf_set_keymap('n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', {noremap = true})
		buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', {noremap = true})
		buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {noremap = true})
		buf_set_keymap('n', '<leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
		buf_set_keymap('n', '<leader>d', '<Cmd>Trouble workspace_diagnostics<CR>', {noremap = true})
		buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', {noremap = true})
		buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', {noremap = true})
		buf_set_keymap('n', '<C-Space>', '<Cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})
		buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
		buf_set_keymap('n', '<RightMouse>', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
	end

	require('lspconfig')['ccls'].setup({ capabilities = capabilities, on_attach = on_attach })

	require('lspconfig')['pyright'].setup({ capabilities = capabilities, on_attach = on_attach })

	require('lspconfig')['texlab'].setup({ capabilities = capabilities, on_attach = on_attach })

	vim.opt.exrc = true
	vim.g.rustaceanvim = {
		-- LSP configuration
		server = {
			capabilities = capabilities, 
			on_attach = function(client, bufnr)
				-- you can also put keymaps in here
				on_attach(client, bufnr);
				-- client.server_capabilities.semanticTokensProvider = nil
				vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = {"*"}, command = "lua vim.lsp.buf.format()" })
				local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
				buf_set_keymap('n', 'J', "<Cmd>RustLsp joinLines<CR>", {noremap = true})
				buf_set_keymap('n', '<C-Space>', "<Cmd>RustLsp codeAction<CR>", {noremap = true})
				buf_set_keymap('n', '<leader>c', "<Cmd>RustLsp openCargo<CR>", {noremap = true})
				buf_set_keymap('n', 'gD', '<Cmd>RustLsp openDocs<CR>', {noremap = true})
			end,
			cmd = {"ra-multiplex", "client"},
			load_vscode_settings = true,

			default_settings = {
				-- rust-analyzer language server configuration
				['rust-analyzer'] = {
					cargo = {
						features = "all",
						targetDir = true,
					},
					checkOnSave = true,
					check = {
						command = "clippy",
						allfeatures = true,
						extrArgs = {"--no-deps"},
					},
					rustfmt = {
						overrideCommand = {"/home/zoomiti/.cargo/bin/leptosfmt", "--stdin", "--rustfmt"},
					},
					procMacro = {
						enable = true
					},

				},
			},
		},
	}

	--[[
	require('lean').setup{ --{{{
	-- Enable the Lean language server(s)?
	--
	-- false to disable, otherwise should be a table of options to pass to
	--	`leanls` and/or `lean3ls`.
	--
	-- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#leanls for details.

	-- Lean 4
	lsp = { on_attach = on_attach },

	-- Lean 3
	lsp3 = { on_attach = on_attach },

	-- What filetype should be associated with standalone Lean files?
	-- Can be set to "lean3" if you prefer that default.
	-- Having a leanpkg.toml or lean-toolchain file should always mean
	-- autodetection works correctly.
	ft = { default = "lean3" },

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
	} -- }}}
	--]]

	require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
	}

	--[[
	require('neorg').setup {
		load = {
        	["core.defaults"] = {},
			["core.norg.completion"] = {
				config = { -- Note that this table is optional and doesn't need to be provided
					engine = 'nvim-cmp',
				}
			},
			["core.integrations.nvim-cmp"] = {
				config = { -- Note that this table is optional and doesn't need to be provided
					-- Configuration here
				}
			},
			["core.norg.concealer"] = {
				config = { -- Note that this table is optional and doesn't need to be provided
					-- Configuration here
				}
			},
			["core.norg.dirman"] = {
				config = {
					workspaces = {
						example_gtd = "~/GitHub/example_workspaces/gtd",
						neorg = "~/neorg",
					},
					default_workspace = "neorg",
				},
			},
			["core.gtd.base"] = {
				config = {
					workspace = "neorg",
				},
			},
			["core.integrations.telescope"] = {}, -- Enable the telescope module
    	}
	}
	--]]

	require("coverage").setup()

	require("which-key").setup {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	}
EOF
endif

" }}}
