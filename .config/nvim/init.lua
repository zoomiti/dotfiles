vim.pack.add({
	{ src = "https://github.com/zoomiti/firewatch" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = 'https://github.com/folke/which-key.nvim' },
	{ src = 'https://github.com/LunarWatcher/auto-pairs' },
	{ src = 'https://github.com/tpope/vim-fugitive' },
	{ src = 'https://github.com/airblade/vim-gitgutter' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
	{ src = 'https://github.com/rayliwell/tree-sitter-rstml' },
	{ src = 'https://github.com/Saghen/blink.cmp' }
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.signcolumn = 'yes'
vim.opt.smartindent = true
vim.opt.title = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3
vim.g.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
vim.g.encoding = 'utf-8'
-- vim.opt.hidden = true

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'n'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set("x", "/", "<Esc>/\\%V", { desc = 'Search forward within visual selection' })
vim.keymap.set("x", "?", "<Esc>?\\%V", { desc = 'Search forward within visual selection' })

require "mini.pick".setup()
vim.keymap.set('n', '<leader>b', '<CMD>Pick buffers<CR>', { desc = "Buffers" })
vim.keymap.set('n', '<leader>f', '<CMD>Pick files<CR>')

vim.keymap.set('n', '<leader>s',
	'<CMD>update ~/.config/nvim/init.lua<CR><CMD>source ~/.config/nvim/init.lua<CR>', { desc = "Update Config" })
vim.keymap.set('n', '<leader>w', '<CMD>write<CR>', { desc = "Write File" })

-- Terminal Mode
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-W>h', '<C-\\><C-n><C-W>h')
vim.keymap.set('t', '<C-W>j', '<C-\\><C-n><C-W>j')
vim.keymap.set('t', '<C-W>k', '<C-\\><C-n><C-W>k')
vim.keymap.set('t', '<C-W>l', '<C-\\><C-n><C-W>l')
vim.keymap.set('t', '<C-W><Left>', '<C-\\><C-n><C-W><Left>')
vim.keymap.set('t', '<C-W><Down>', '<C-\\><C-n><C-W><Down>')
vim.keymap.set('t', '<C-W><Up>', '<C-\\><C-n><C-W><Up>')
vim.keymap.set('t', '<C-W><Right>', '<C-\\><C-n><C-W><Right>')
vim.api.nvim_create_autocmd('BufEnter', { pattern = 'term://*', command = 'startinsert' })
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = 'term://*',
	callback = function(args)
		vim.keymap.set('n', '<C-c>', 'i<C-c><C-\\><C-n>', { buffer = args.buf })
	end
})

-- Colorscheme
vim.opt.termguicolors = true
vim.g.dark_transp_bg = 1
vim.cmd("colorscheme fire")

-- LSP
vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })
vim.keymap.set({ 'n', 'v', 'x' }, 'grf', vim.lsp.buf.format, { desc = "LSP Format" })
vim.lsp.inlay_hint.enable(true)
vim.g.c_syntax_for_h = 1
require('blink.cmp').setup({
	signature = { enabled = true }
})
vim.lsp.enable({ 'lua_ls', 'ccls' })
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		if client:supports_method('textDocument/formatting', args.buf) then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
				end
			})
		end
	end
})
vim.diagnostic.config({
	jump = {
		virtual_lines = true
	},
	virtual_text = {
		prefix = '■',
		source = true,
	},
	severity_sort = true,
	float = {
		source = "if_many"
	},
	virtual_lines = {
		source = "if_many",
		current_line = true,
	}
})



-- Fugitive
vim.keymap.set('n', '<leader>gs', '<CMD>G<CR>', { desc = "Git Status" })
vim.keymap.set('n', '<leader>gp', '<CMD>G pull<CR>', { desc = "Git Pull" })
vim.keymap.set('n', '<leader>gP', '<CMD>G push<CR>', { desc = "Git Push" })
vim.keymap.set('n', '<leader>gP', '<CMD>G push<CR>', { desc = "Git Push" })

local wk = require "which-key"
wk.add({
	{ "<leader>g", group = "git" },
})

local statusline = {
	'%{%v:lua.StatuslineHighlight("Left")%}',
	'%{v:lua.StatuslineMode()}',
	'%{%v:lua.StatuslineHighlight("Secondary")%}',
	'%{v:lua.StatuslineBranch()}',
	' %{v:lua.StatuslineFilename()} ',
	'%{%v:lua.StatuslineReadOnly()%}',
	'%m',
	'%{%v:lua.StatuslineHighlight("Middle")%}',
	'%=',
	' ',
	'%{&ff}',                -- File Format
	' | ',
	'%{&fenc!=#""?&fenc:&enc}', -- File Encoding
	' | ',
	'%{&ft!=#""?&ft:"no ft"}', -- File Type
	' ',
	'%{%v:lua.StatuslineHighlight("Secondary")%}',
	' ',
	'%3p%%', -- Percent
	' ',
	'%{%v:lua.StatuslineHighlight("Right")%}',
	' ',
	'%3l:%-2c', -- Line Info
	' ',
}

local mode_map = {
	['n']     = 'NORMAL',
	['no']    = 'O-PENDING',
	['nov']   = 'O-PENDING',
	['noV']   = 'O-PENDING',
	['no\22'] = 'O-PENDING',
	['niI']   = 'NORMAL',
	['niR']   = 'NORMAL',
	['niV']   = 'NORMAL',
	['nt']    = 'NORMAL',
	['v']     = 'VISUAL',
	['vs']    = 'VISUAL',
	['V']     = 'V-LINE',
	['Vs']    = 'V-LINE',
	['\22']   = 'V-BLOCK',
	['\22s']  = 'V-BLOCK',
	['s']     = 'SELECT',
	['S']     = 'S-LINE',
	['\19']   = 'S-BLOCK',
	['i']     = 'INSERT',
	['ic']    = 'INSERT',
	['ix']    = 'INSERT',
	['R']     = 'REPLACE',
	['Rc']    = 'REPLACE',
	['Rx']    = 'REPLACE',
	['Rv']    = 'V-REPLACE',
	['Rvc']   = 'V-REPLACE',
	['Rvx']   = 'V-REPLACE',
	['c']     = 'COMMAND',
	['cv']    = 'EX',
	['ce']    = 'EX',
	['r']     = 'REPLACE',
	['rm']    = 'MORE',
	['r?']    = 'CONFIRM',
	['!']     = 'SHELL',
	['t']     = 'TERMINAL',
}

local mode_map_hi = {
	['n']     = 'NORMAL',
	['no']    = 'NORMAL',
	['nov']   = 'NORMAL',
	['noV']   = 'NORMAL',
	['no\22'] = 'NORMAL',
	['niI']   = 'NORMAL',
	['niR']   = 'NORMAL',
	['niV']   = 'NORMAL',
	['nt']    = 'NORMAL',
	['v']     = 'VISUAL',
	['vs']    = 'VISUAL',
	['V']     = 'VISUAL',
	['Vs']    = 'VISUAL',
	['\22']   = 'VISUAL',
	['\22s']  = 'VISUAL',
	['s']     = 'VISUAL',
	['S']     = 'VISUAL',
	['\19']   = 'VISUAL',
	['i']     = 'INSERT',
	['ic']    = 'INSERT',
	['ix']    = 'INSERT',
	['R']     = 'REPLACE',
	['Rc']    = 'REPLACE',
	['Rx']    = 'REPLACE',
	['Rv']    = 'REPLACE',
	['Rvc']   = 'REPLACE',
	['Rvx']   = 'REPLACE',
	['c']     = 'NORMAL',
	['cv']    = 'NORMAL',
	['ce']    = 'NORMAL',
	['r']     = 'REPLACE',
	['rm']    = 'REPLACE',
	['r?']    = 'REPLACE',
	['!']     = 'TERMINAL',
	['t']     = 'TERMINAL',
}

local fmt = string.format

vim.cmd [[
 hi StatusLine_NORMAL_Left guifg=#c8c6c5 guibg=#2e2828 gui=BOLD cterm=NONE
 hi StatusLine_NORMAL_Right guifg=#c8c6c5 guibg=#2e2828 gui=NONE cterm=NONE
 hi StatusLine_NORMAL_Secondary guifg=#807970 guibg=#423838 gui=NONE cterm=NONE
 hi StatusLine_NORMAL_Middle guifg=#423838 guibg=#807970 gui=NONE cterm=NONE

 hi StatusLine_VISUAL_Left guifg=#8c9440 guibg=#2e2828 gui=BOLD cterm=NONE
 hi StatusLine_VISUAL_Right guifg=#8c9440 guibg=#2e2828 gui=NONE cterm=NONE
 hi StatusLine_VISUAL_Secondary guifg=#807970 guibg=#423838 gui=NONE cterm=NONE
 hi StatusLine_VISUAL_Middle guifg=#423838 guibg=#c8c6c5 gui=NONE cterm=NONE

 hi StatusLine_INSERT_Left guifg=#f0b94e guibg=#2e2828 gui=BOLD cterm=NONE
 hi StatusLine_INSERT_Right guifg=#f0b94e guibg=#2e2828 gui=NONE cterm=NONE
 hi StatusLine_INSERT_Middle guifg=#423838 guibg=#c8c6c5 gui=NONE cterm=NONE
 hi StatusLine_INSERT_Secondary guifg=#423838 guibg=#807970 gui=NONE cterm=NONE

 hi StatusLine_REPLACE_Left guifg=#de803f guibg=#2e2828 gui=BOLD cterm=NONE
 hi StatusLine_REPLACE_Right guifg=#de803f guibg=#2e2828 gui=NONE cterm=NONE
 hi StatusLine_REPLACE_Middle guifg=#423838 guibg=#c8c6c5 gui=NONE cterm=NONE
 hi StatusLine_REPLACE_Secondary guifg=#423838 guibg=#807970 gui=NONE cterm=NONE

 hi StatusLine_TERMINAL_Left guifg=#8abeb7 guibg=#2e2828 gui=BOLD cterm=NONE
 hi StatusLine_TERMINAL_Right guifg=#8abeb7 guibg=#2e2828 gui=NONE cterm=NONE
 hi StatusLine_TERMINAL_Secondary guifg=#807970 guibg=#423838 gui=NONE cterm=NONE
 hi StatusLine_TERMINAL_Middle guifg=#423838 guibg=#807970 gui=NONE cterm=NONE
]]


function StatuslineHighlight(part)
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = mode_map_hi[mode] or mode
	return fmt('%%#StatusLine_%s_%s#', mode_name, part)
end

function StatuslineMode()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = mode_map[mode] or mode
	return fmt('  %s ', mode_name)
end

function SpecialBuffer()
	local pattern = '\v(help|fugitive|qf|Trouble)'
	return string.match(pattern, vim.bo.filetype) ~= nil and true or false
end

function StatuslineReadOnly()
	return SpecialBuffer() and '' or '%r'
end

function StatuslineBranch()
	local head = vim.fn.FugitiveHead()
	return SpecialBuffer() ~= true and head ~= '' and fmt('  %s |', head) or ''
end

function StatuslineFilename()
	local special_files = {
		['help'] = "Help",
		['qf'] = 'QuickFix',
		['fugitive'] = vim.fn.FugitiveStatusline()
	}

	local filename = vim.fn.expand('%:t')

	return special_files[vim.bo.filetype] or filename == "" and '[No Name]' or filename
end

vim.opt.statusline = table.concat(statusline, '')

require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "c", "lua" },
	--ensure_installed = {},
	sync_install = false,
	auto_install = false,
	ignore_install = { "javascript" },
	highlight = { enable = true },
	indent = { enable = true },
}

require("tree-sitter-rstml").setup()

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "single"
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local floaterm_state = {
	floating = {
		buf = -1,
		win = -1,
	}
}

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(floaterm_state.floating.win) then
		floaterm_state.floating = create_floating_window({ buf = floaterm_state.floating.buf })
		if vim.bo[floaterm_state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
			vim.cmd.startinsert()
		end
	else
		vim.api.nvim_win_hide(floaterm_state.floating.win)
	end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, { desc = "Toggles a floating terminal" })
vim.keymap.set({ "n", "t" }, "<leader>t", toggle_terminal, { desc = "Toggles a floating terminal" })
