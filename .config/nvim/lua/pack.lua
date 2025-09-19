local M = {}

local function normalize_url(src)
	-- Check for nil first
	if not src or type(src) ~= "string" or src == "" then
		error("Plugin source must be a non-empty string, got: " .. tostring(src))
	end

	-- Already a full URL (http/https/git)
	if src:match("^https?://") or src:match("^git@") then
		return src
	end

	-- SSH format: git@github.com:user/repo.git
	if src:match("^git@[%w%.%-]+:") then
		return src
	end

	-- GitHub shorthand: user/repo or user/repo.git
	if src:match("^[%w-_%.]+/[%w-_%.]+%.?g?i?t?$") then
		local clean_src = src:gsub("%.git$", "")
		return "https://github.com/" .. clean_src .. ".git"
	end

	-- Local path or other format - pass through
	return src
end

local function extract_plugin_name(original_src)
	if not original_src then return nil end

	-- Extract repo name from various formats
	local repo = original_src:match("([^/]+)$") -- Get last part after /
	if repo then
		-- Remove common suffixes
		repo = repo:gsub("%.git$", "")
		repo = repo:gsub("%.nvim$", "")
		repo = repo:gsub("%.lua$", "")
		repo = repo:gsub("^nvim%-", "")
		return repo
	end
	return original_src
end

local function is_single_plugin_spec(plugins)
	-- Check if it's a single plugin spec vs array of plugin specs
	if type(plugins) ~= "table" then
		return false
	end

	-- If plugins[1] is a string, it's a single spec: {"user/repo", setup = {...}}
	if type(plugins[1]) == "string" then
		return true
	end

	-- If it has src but plugins[1] is not a table, it's a single spec: {src = "user/repo"}
	if plugins.src and type(plugins[1]) ~= "table" then
		return true
	end

	-- Otherwise it's an array: {{src = "..."}, {src = "..."}} or {"user/repo", "user/repo2"}
	return false
end

function M._do_setup(spec, src)
	local function do_setup()
		-- vim.notify("Setting up " .. src)
		if spec.setup then
			local plugin_name = spec.module or extract_plugin_name(src)
			if not plugin_name then
				error("Could not determine plugin name for setup")
			end

			if spec.setup == true then
				-- Auto-setup with defaults
				require(plugin_name).setup()
			elseif type(spec.setup) == "table" then
				-- Setup with config
				require(plugin_name).setup(spec.setup)
			end
		end
		if spec.config then
			if type(spec.config) == "function" then
				spec.config()
			end
		end
	end

	if spec.config or spec.setup or spec.build then
		local setup_ok, setup_err = pcall(do_setup)
		if not setup_ok then
			vim.notify("Failed to setup " .. (src or "unknown") .. ": " .. setup_err, vim.log.levels.WARN)
		end
	end
end

-- Main function - handles single plugin or multiple plugins
function M.add(plugins)
	-- Single string plugin
	if type(plugins) == "string" then
		if plugins == "" then
			error("Plugin source cannot be empty string")
		end
		local ok, err = pcall(vim.pack.add, normalize_url(plugins))
		if not ok then
			vim.notify("Failed to add plugin " .. plugins .. ": " .. err, vim.log.levels.ERROR)
		end
		return
	end

	if type(plugins) == "table" then
		-- Check if it's a single plugin spec
		if is_single_plugin_spec(plugins) then
			local plugin = plugins
			local src = plugin[1] or plugin.src
			if not src or src == "" then
				error("Plugin src is required and cannot be empty")
			end

			-- Normalize and modify in place
			local normalized_src = normalize_url(src)
			local original_src = src

			-- Store build spec for event handling
			if plugin.build then
				plugin.data = plugin.data or {}
				plugin.data.build = plugin.build
			end

			-- Create clean spec for vim.pack.add
			local pack_spec = {}
			for k, v in pairs(plugins) do
				if k ~= "config" and k ~= "setup" and k ~= "module" and k ~= "build" and k ~= 1 then
					pack_spec[k] = v
				end
			end
			pack_spec.src = normalized_src

			local ok, err = pcall(vim.pack.add, pack_spec)
			if not ok then
				vim.notify("Failed to add plugin " .. src .. ": " .. err, vim.log.levels.ERROR)
				return
			end

			-- Do setup if needed
			M._do_setup(plugin, original_src)
			return
		end

		-- Multiple plugins - modify in place and collect setup specs
		local setup_specs = {}

		for i, plugin in ipairs(plugins) do
			if type(plugin) == "string" then
				if not plugin or plugin == "" then
					vim.notify("Plugin " .. i .. " is empty or nil, skipping", vim.log.levels.WARN)
					-- Replace with nil to skip
					plugins[i] = nil
					goto continue
				end

				-- Convert string to table
				plugins[i] = { src = normalize_url(plugin) }
			elseif type(plugin) == "table" then
				local src = plugin[1] or plugin.src
				if not src or type(src) ~= "string" or src == "" then
					vim.notify("Plugin " .. i .. " missing or invalid src, skipping", vim.log.levels.WARN)
					plugins[i] = nil
					goto continue
				end

				local original_src = src
				local normalized_src = normalize_url(src)

				-- Store build spec for event handling
				if plugin.build then
					plugin.data = plugin.data or {}
					plugin.data.build = plugin.build
				end

				-- Cache setup info if needed
				if plugin.config or plugin.setup then
					setup_specs[#setup_specs + 1] = {
						spec = {
							config = plugin.config, -- Save the actual function/table
							setup = plugin.setup,
							module = plugin.module,
						},
						original_src = original_src
					}
				end

				-- Normalize src and remove our custom keys
				plugin.src = normalized_src
				plugin.config = nil
				plugin.setup = nil
				plugin.module = nil
				plugin.build = nil
				plugin[1] = nil -- Remove positional src
			else
				vim.notify("Plugin " .. i .. " must be string or table, got " .. type(plugin), vim.log.levels.WARN)
				plugins[i] = nil
			end

			::continue::
		end

		-- Remove nil entries
		local clean_plugins = {}
		for _, plugin in ipairs(plugins) do
			if plugin then
				clean_plugins[#clean_plugins + 1] = plugin
			end
		end

		-- Download all plugins in one call
		if #clean_plugins > 0 then
			local ok, err = pcall(vim.pack.add, clean_plugins)
			if not ok then
				vim.notify("Failed to add plugin batch: " .. err, vim.log.levels.ERROR)
				return
			end
		end

		-- Now do setup for plugins that need it
		for _, setup_info in ipairs(setup_specs) do
			M._do_setup(setup_info.spec, setup_info.original_src)
		end
	else
		error("plugins must be a string or table, got: " .. type(plugins))
	end
end

-- Alias for convenience
M.use = M.add

function M._run_build_command(build_cmd, plugin_dir, plugin_name, on_success)
	if not build_cmd then return end

	local cmd_type = type(build_cmd)

	if cmd_type == "string" then
		vim.notify("Building " .. plugin_name .. "...", vim.log.levels.INFO)

		vim.fn.jobstart({
			"sh", "-c",
			string.format("cd '%s' && %s", plugin_dir, build_cmd)
		}, {
			on_exit = function(_, exit_code)
				if exit_code == 0 then
					vim.notify("Build completed for " .. plugin_name, vim.log.levels.INFO)
					if on_success then on_success() end
				else
					vim.notify("Build failed for " .. plugin_name, vim.log.levels.ERROR)
				end
			end
		})
	elseif cmd_type == "function" then
		local ok, err = pcall(build_cmd, plugin_dir)
		if ok and on_success then
			on_success()
		elseif not ok then
			vim.notify("Build function failed for " .. plugin_name .. ": " .. err, vim.log.levels.ERROR)
		end
	end
end

--buf = 1,
--data = {
--  kind = "delete",
--  path = "/Users/zoomiti/.local/share/nvim/site/pack/core/opt/blink.cmp",
--  spec = {
--    name = "blink.cmp",
--    src = "https://github.com/Saghen/blink.cmp.git"
--  }
--},
--event = "PackChanged",
--file = "/Users/zoomiti/.local/share/nvim/site/pack/core/opt/blink.cmp",
--id = 14,
--match = "/Users/zoomiti/.local/share/nvim/site/pack/core/opt/blink.cmp"
local augroup = vim.api.nvim_create_augroup('most_basic_build_system', { clear = false })
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	pattern = "*",
	callback = function(ev)
		if ev.data.kind ~= 'delete' and ev.data.spec.data and ev.data.spec.data.build and type(ev.data.spec.data.build) == "string" then
			vim.system({ "sh", "-c" }, { stdin = 'cd' .. ev.data.path .. ' && ' .. ev.data.spec.data.build })
		end
	end
})

return M
