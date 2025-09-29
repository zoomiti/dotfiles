-- vim: foldmethod=marker foldlevel=0

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require "pack".add({
	{
		"zoomiti/firewatch",
		config = function()
			vim.opt.termguicolors = true
			vim.g.dark_transp_bg = 1
			vim.cmd.colorscheme("fire")
		end
	},
	{
		"nvim-mini/mini.icons",
		setup = true
	},
	{
		"nvim-mini/mini.pick",
		setup = true,
		config = function()
			vim.keymap.set('n', '<leader>b', '<CMD>Pick buffers<CR>', { desc = "Buffers" })
			vim.keymap.set('n', '<leader>f', '<CMD>Pick files<CR>', { desc = "Files" })
		end
	},
	{
		"nvim-mini/mini.surround",
		setup = {
			custom_surroundings = nil,
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = 'gs', -- Add surrounding in Normal and Visual modes
				delete = 'ds', -- Delete surrounding
				find = '', -- Find surrounding (to the right)
				find_left = '', -- Find surrounding (to the left)
				highlight = '', -- Highlight surrounding
				replace = 'cs', -- Replace surrounding

				suffix_last = '', -- Suffix to search with "prev" method
				suffix_next = '', -- Suffix to search with "next" method
			},
			respect_selection_type = true,
			search_method = 'cover_or_next',
		}
	},
	{
		"nvim-mini/mini.pairs",
		setup = {
			mappings = {
				['('] = { neigh_pattern = '[^\\]%s' },
				['['] = { neigh_pattern = '[^\\]%s' },
				['{'] = { neigh_pattern = '[^\\]%s' },

				[')'] = { neigh_pattern = '[^\\]%s' },
				[']'] = { neigh_pattern = '[^\\]%s' },
				['}'] = { neigh_pattern = '[^\\]%s' },

				['"'] = { neigh_pattern = '[^\\]%s' },
				["'"] = { neigh_pattern = '[^%a\\]%s' },
				['`'] = { neigh_pattern = '[^\\]%s' },
			},
		}
	},
	"neovim/nvim-lspconfig",
	"mrcjkb/rustaceanvim",
	{
		"folke/which-key.nvim",
		config = function()
			local wk = require("which-key")
			wk.add({
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "git_hunk" }
			})
		end
	},
	{ "nvim-lua/plenary.nvim" },
	{
		"NeogitOrg/neogit",
		config = function()
			vim.keymap.set('n', '<leader>gs', '<CMD>Neogit kind=split_above_all cwd=%:p:h<CR>', { desc = "Git Status" })
			vim.keymap.set('n', '<leader>gp', '<CMD>Neogit pull cwd=%:p:h<CR>', { desc = "Git Pull" })
			vim.keymap.set('n', '<leader>gP', '<CMD>Neogit push cwd=%:p:h<CR>', { desc = "Git Push" })
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		setup = {
			-- {{{ gitsigns on_attach
			on_attach = function(bufnr)
				local gitsigns = require('gitsigns')

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then
						vim.cmd.normal({ ']c', bang = true })
					else
						gitsigns.nav_hunk('next')
					end
				end, { desc = "next hunk" })

				map('n', '[c', function()
					if vim.wo.diff then
						vim.cmd.normal({ '[c', bang = true })
					else
						gitsigns.nav_hunk('prev')
					end
				end, { desc = "prev hunk" })

				-- Actions
				map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "(un)stage hunk" })
				map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "reset hunk" })

				map('v', '<leader>hs', function()
					gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end, { desc = "(un)stage hunk" })

				map('v', '<leader>hr', function()
					gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
				end, { desc = "reset hunk" })

				--map('n', '<leader>hS', gitsigns.stage_buffer)
				--map('n', '<leader>hR', gitsigns.reset_buffer)
				map('n', '<leader>hp', gitsigns.preview_hunk, { desc = "preview hunk" })
				map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = "preview hunk inline" })

				map('n', '<leader>hb', function()
					gitsigns.blame_line({ full = true })
				end, { desc = "blame line" })

				map('n', '<leader>hd', gitsigns.diffthis, { desc = "diff buffer" })

				map('n', '<leader>hD', function()
					gitsigns.diffthis('~')
				end, { desc = "diff buffer to HEAD" })

				map('n', '<leader>hQ', function() gitsigns.setqflist('all') end,
					{ desc = "set qflist with changes in all files and cwd" })
				map('n', '<leader>hq', gitsigns.setqflist, { desc = "set qflist with changes in current buffer" })

				-- Toggles
				map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = "toggle current line blame" })
				map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = "toggle word diff" })

				-- Text object
				map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = "inner hunk" })
			end
			-- }}}
		}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		module = 'nvim-treesitter.configs',
		setup = {
			ensure_installed = { "c", "lua" },
			sync_install = false,
			auto_install = false,
			ignore_install = { "javascript" },
			highlight = { enable = true },
			indent = { enable = true },
		}
	},
	{ "rayliwell/tree-sitter-rstml", setup = true },
	{
		"Saghen/blink.cmp",
		version = vim.version.range("v1.*"),
		build = "cargo build --release",
		setup = {
			signature = { enabled = true }
		}
	},
	{
		"stevearc/oil.nvim",
		setup = true,
		config = function()
			vim.keymap.set("n", "-", vim.cmd.Oil, { desc = "Open Parent Directory" })
		end
	},
	{
		"catgoose/nvim-colorizer.lua",
		setup = {
			user_default_options = {
				names = true, -- "Name" codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
				names_opts = { -- options for mutating/filtering names.
					lowercase = false, -- name:lower(), highlight `blue` and `red`
					camelcase = true, -- name, highlight `Blue` and `Red`
					uppercase = true, -- name:upper(), highlight `BLUE` and `RED`
					strip_digits = true, -- ignore names with digits,
					-- highlight `blue` and `red`, but not `blue3` and `red4`
				},
				xterm = true,
			}
		}
	},
	{
		"alexghergh/nvim-tmux-navigation",
		-- {{{ nvim-tmux-navigation config
		config = function()
			local nvim_tmux_nav = require('nvim-tmux-navigation')

			nvim_tmux_nav.setup {
				disable_when_zoomed = true -- defaults to false
			}

			vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

			-- Custom keymaps that work with your Ctrl-w workflow
			vim.keymap.set('n', '<C-w><C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = 'Navigate left' })
			vim.keymap.set('n', '<C-w><C-j>', nvim_tmux_nav.NvimTmuxNavigateDown, { desc = 'Navigate down' })
			vim.keymap.set('n', '<C-w><C-k>', nvim_tmux_nav.NvimTmuxNavigateUp, { desc = 'Navigate up' })
			vim.keymap.set('n', '<C-w><C-l>', nvim_tmux_nav.NvimTmuxNavigateRight, { desc = 'Navigate right' })

			-- Also support single letters after Ctrl-w (like standard Vim)
			vim.keymap.set('n', '<C-w>h', nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = 'Navigate left' })
			vim.keymap.set('n', '<C-w>j', nvim_tmux_nav.NvimTmuxNavigateDown, { desc = 'Navigate down' })
			vim.keymap.set('n', '<C-w>k', nvim_tmux_nav.NvimTmuxNavigateUp, { desc = 'Navigate up' })
			vim.keymap.set('n', '<C-w>l', nvim_tmux_nav.NvimTmuxNavigateRight, { desc = 'Navigate right' })

			vim.keymap.set('n', '<C-w><Left>', nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = 'Navigate left' })
			vim.keymap.set('n', '<C-w><Down>', nvim_tmux_nav.NvimTmuxNavigateDown, { desc = 'Navigate down' })
			vim.keymap.set('n', '<C-w><Up>', nvim_tmux_nav.NvimTmuxNavigateUp, { desc = 'Navigate up' })
			vim.keymap.set('n', '<C-w><Right>', nvim_tmux_nav.NvimTmuxNavigateRight, { desc = 'Navigate right' })

			-- Previous pane/split
			vim.keymap.set('n', '<C-w><C-w>', nvim_tmux_nav.NvimTmuxNavigateLastActive,
				{ desc = 'Navigate to previous' })
			vim.keymap.set('n', '<C-w>w', nvim_tmux_nav.NvimTmuxNavigateLastActive,
				{ desc = 'Navigate to previous' })
		end
		-- }}}
	}
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

vim.g.clipboard = {
	name = 'OSC 52',
	copy = {
		['+'] = require('vim.ui.clipboard.osc52').copy '+',
		['*'] = require('vim.ui.clipboard.osc52').copy '*',
	},
	paste = {
		['+'] = require('vim.ui.clipboard.osc52').paste '+',
		['*'] = require('vim.ui.clipboard.osc52').paste '*',
	},
}

-- {{{ Return to last position in file
vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		local ft = vim.bo.filetype
		local last_pos = vim.fn.line("'\"")
		local last_line = vim.fn.line("$")

		if not string.match(ft, "commit") and
			not string.match(ft, "rebase") and
			last_pos > 1 and
			last_pos <= last_line then
			vim.cmd('silent! normal! g`"')
			vim.cmd('silent! foldopen!')
			vim.cmd('silent! normal! zz')
		end
	end,
}) ---}}}

vim.keymap.set("x", "/", "<Esc>/\\%V", { desc = 'Search forward within visual selection' })
vim.keymap.set("x", "?", "<Esc>?\\%V", { desc = 'Search forward within visual selection' })

vim.keymap.set('n', '<leader>s',
	'<CMD>update ~/.config/nvim/init.lua<CR><CMD>source ~/.config/nvim/init.lua<CR>', { desc = "Update Config" })
vim.keymap.set('n', '<leader>w', '<CMD>write<CR>', { desc = "Write File" })

-- {{{ Terminal Mode
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>')
vim.api.nvim_create_autocmd('BufEnter', { pattern = 'term://*', command = 'startinsert' })
vim.api.nvim_create_autocmd('TermOpen', {
	callback = function(args)
		vim.keymap.set('n', '<C-c>', 'i<C-c><C-\\><C-n>', { buffer = args.buf })
	end
})
-- }}}

-- {{{ Undo File

vim.opt.undofile = true

-- Clean old undo files
vim.api.nvim_create_user_command("UndoClean", function()
	local undo_dir = vim.o.undodir
	vim.fn.system("find " .. undo_dir .. " -type f -mtime +30 -delete")
	print("Cleaned undo files older than 30 days")
end, {})



-- }}}

-- {{{ LSP
vim.o.foldlevel = 1
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.g.c_syntax_for_h = true
vim.lsp.enable({ 'lua_ls', 'ccls' })
vim.g.auto_format = true
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then return end

		vim.lsp.inlay_hint.enable(true)
		vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = "vim.lsp.buf.definition" })

		if client:supports_method('textDocument/formatting', args.buf) then
			vim.keymap.set({ 'n', 'v', 'x' }, 'grf', vim.lsp.buf.format, { desc = "LSP Format" })
			vim.b.auto_format = true
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("AutoFormat", { clear = true }),
				buffer = args.buf,
				callback = function()
					if vim.g.auto_format and vim.b.auto_format then
						vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
					end
				end
			})
		end
		if client:supports_method('textDocument/foldingRange') then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
		end
		if client:supports_method('textDocument/documentColor') then
			vim.lsp.document_color.enable(true, args.buf)
		end
	end
})
-- {{{ Commands to toggle auto format
vim.api.nvim_create_user_command("FormatToggle", function()
	vim.g.auto_format = not vim.g.auto_format
	print("Auto format " .. (vim.g.auto_format and "enabled" or "disabled"))
end, {})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.g.auto_format = true
	print("Auto format enabled")
end, {})

vim.api.nvim_create_user_command("FormatDisable", function()
	vim.g.auto_format = false
	print("Auto format disabled")
end, {})

vim.api.nvim_create_user_command("FormatToggleBuffer", function()
	vim.b.auto_format = not vim.b.auto_format
	print("Auto format " .. (vim.b.auto_format and "enabled" or "disabled"))
end, {})

vim.api.nvim_create_user_command("FormatEnableBuffer", function()
	vim.b.auto_format = true
	print("Auto format enabled")
end, {})

vim.api.nvim_create_user_command("FormatDisableBuffer", function()
	vim.b.auto_format = false
	print("Auto format disabled")
end, {})
-- }}}

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
-- }}}

-- {{{ Status Line

local statusline = {
	'%{%v:lua.StatuslineHighlight("Left")%}',
	'%{v:lua.StatuslineMode()}',
	'%{%v:lua.StatuslineHighlight("Secondary")%}',
	'%{v:lua.StatuslineBranch()}',
	'%{%v:lua.StatuslineFilename()%} ',
	'%(',
	'%{%v:lua.StatuslineReadOnly()%}',
	'%{%v:lua.StatuslineModified()%}',
	'%)',
	'%{%v:lua.StatuslineHighlight("Middle")%}',
	'%=',
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

local highlights = {
	["NORMAL"] = {
		["Left"] = { fg = "#c8c6c5", bg = "#2e2828", bold = true, },
		["Right"] = { fg = "#c8c6c5", bg = "#2e2828", },
		["Secondary"] = { fg = "#807970", bg = "#2e2828", },
		["Middle"] = { fg = "#423838", bg = "#807970", }
	},
	["VISUAL"] = {
		["Left"] = { fg = "#8c9440", bg = "#2e2828", bold = true, },
		["Right"] = { fg = "#8c9440", bg = "#2e2828", },
		["Secondary"] = { fg = "#807970", bg = "#2e2828", },
		["Middle"] = { fg = "#423838", bg = "#807970", }
	},
	["TERMINAL"] = {
		["Left"] = { fg = "#8abeb7", bg = "#2e2828", bold = true, },
		["Right"] = { fg = "#8abeb7", bg = "#2e2828", },
		["Secondary"] = { fg = "#807970", bg = "#2e2828", },
		["Middle"] = { fg = "#423838", bg = "#807970", }
	},
	["INSERT"] = {
		["Left"] = { fg = "#f0b94e", bg = "#2e2828", bold = true },
		["Right"] = { fg = "#f0b94e", bg = "#2e2828" },
		["Secondary"] = { fg = "#423838", bg = "#807970" },
		["Middle"] = { fg = "#423838", bg = "#807970", }
	},
	["REPLACE"] = {
		["Left"] = { fg = "#de803f", bg = "#2e2828", bold = true },
		["Right"] = { fg = "#de803f", bg = "#2e2828" },
		["Secondary"] = { fg = "#423838", bg = "#807970" },
		["Middle"] = { fg = "#423838", bg = "#807970", }
	},
}

for mode, colors in pairs(highlights) do
	for highlight, color in pairs(colors) do
		vim.api.nvim_set_hl(0, "StatusLine_" .. mode .. "_" .. highlight, color)
	end
end

function StatuslineHighlight(part)
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = mode_map_hi[mode] or mode
	return '%#StatusLine_' .. mode_name .. '_' .. part .. '#'
end

function StatuslineMode()
	local mode = vim.api.nvim_get_mode().mode
	local mode_name = mode_map[mode] or mode
	return '  ' .. mode_name .. ' '
end

function SpecialBuffer()
	local pattern = '\v(help|oil|qf|NeogitStatus)'
	return string.match(pattern, vim.bo.filetype) ~= nil and true or false
end

function StatuslineReadOnly()
	return SpecialBuffer() and '' or '%r'
end

function StatuslineModified()
	return vim.bo.modifiable and '%m ' or ''
end

function StatuslineBranch()
	local head = vim.b.gitsigns_head
	return SpecialBuffer() ~= true and head ~= nil and '  git(' .. head .. ') | ' or ''
end

function StatuslineFilename()
	local special_files = {
		['help'] = "  Help",
		['qf'] = ' %q ' .. (vim.w.quickfix_title or ""),
		['NeogitStatus'] = '  ' .. (vim.b.gitsigns_head or "")
	}

	local filename = vim.fn.expand('%:t')

	return special_files[vim.bo.filetype] or filename == "" and '[No Name]' or filename
end

vim.opt.showmode = false
vim.opt.statusline = table.concat(statusline, '')
vim.g.qf_disable_statusline = true

-- }}}

-- {{{ Floaterminal
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
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "Toggles a floating terminal" })

-- }}}
