let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'ap/vim-css-color'

"Surround
Plug 'tpope/vim-surround'

"Latex
Plug 'lervag/vimtex'

"LEAN REQUIRES NVIM
if has("nvim")
Plug 'Julian/lean.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'

Plug 'hrsh7th/nvim-compe'  " For LSP completion
Plug 'hrsh7th/vim-vsnip'   " For snippets
Plug 'andrewradev/switch.vim'  " For Lean switch support
end
call plug#end()

" Conceal options
hi clear Conceal
set conceallevel=2
set concealcursor=n

set encoding=utf-8

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

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

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
    -- If you don't already have a preferred neovim LSP setup, you may want
	-- to reference the nvim-lspconfig documentation, which can be found at:
	-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
	-- For completeness (of showing this plugin's settings), we show
	-- a barebones LSP attach handler (which will give you Lean LSP
	-- functionality in attached buffers) here:
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
        builtin = false, -- built-in expander
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
        mappings = false,

        -- Infoview support
        infoview = {
        -- Automatically open an infoview on entering a Lean buffer?
        autoopen = true,
        -- Set the infoview windows' widths
        width = 50,
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
