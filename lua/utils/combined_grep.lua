local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require "telescope.config".values

local M = {}

-- Priority: 1. Current file's parent dir, 2. Oil directory, 3. nil (cwd fallback)
local function get_base_directory()
	local bufname = vim.api.nvim_buf_get_name(0)

	-- Use current file's directory if it's a normal file
	if bufname ~= "" and not bufname:match("^oil://") and
		vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "" then
		local file_dir = vim.fn.expand('%:p:h')
		if vim.fn.isdirectory(file_dir) == 1 then return file_dir end
	end

	-- Try Oil directory
	local ok, oil = pcall(require, "oil")
	if ok then
		local oil_dir = oil.get_current_dir()
		if oil_dir then return oil_dir end

		-- Search any loaded Oil buffer
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local buf_name = vim.api.nvim_buf_get_name(bufnr)
				local dir_path = buf_name:match("^oil://(.+)")
				if dir_path and vim.fn.isdirectory(dir_path) == 1 then
					return dir_path
				end
			end
		end
	end
end

local live_combined_grep = function(opts)
	opts = opts or {}
	local default_cwd = vim.uv.cwd()
	opts.cwd = opts.cwd or default_cwd
	local captured_base = get_base_directory() or default_cwd

	local finder = finders.new_async_job {
		command_generator = function(prompt)
			if not prompt or prompt == "" then return nil end

			local args = { "rg" }
			local directory, file_pattern = nil, nil
			local search_parts = {}

			-- Parse tokens: @dir, #pattern, or search terms
			for token in prompt:gmatch("%S+") do
				if token:match("^@") then
					directory = token:sub(2)
				elseif token:match("^#") then
					file_pattern = token:sub(2)
				else
					table.insert(search_parts, token)
				end
			end

			-- Add search term
			if #search_parts > 0 then
				table.insert(args, "-e")
				table.insert(args, table.concat(search_parts, " "))
			end

			-- Add file pattern
			if file_pattern then
				vim.list_extend(args, { "-g", "*" .. file_pattern })
			end

			-- Standard rg flags
			vim.list_extend(args, {
				"--color=never", "--no-heading", "--with-filename",
				"--line-number", "--column", "--smart-case"
			})

			-- Handle directory search (non-recursive)
			if directory then
				table.insert(args, "--max-depth=1")
				local dir = vim.trim(directory)

				local search_path = dir == "." and captured_base or
					dir:match("^[/~]") and vim.fn.expand(dir) or
					captured_base:gsub("/$", "") .. "/" .. dir

				search_path = vim.fn.fnamemodify(search_path, ":p"):gsub("/$", "")

				if vim.fn.isdirectory(search_path) == 0 then
					vim.notify("Warning: Directory '" .. search_path .. "' may not exist", vim.log.levels.WARN)
				end
				table.insert(args, search_path)
			end

			return args
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	}

	pickers.new(opts, {
		debounce = 100,
		prompt_title = "Combined Grep (pattern @dir #filetype)",
		finder = finder,
		previewer = conf.grep_previewer(opts),
		sorter = require("telescope.sorters").empty(),
	}):find()
end

M.setup = function()
	vim.keymap.set("n", "<A-c>", live_combined_grep, { desc = "Combined grep with @dir and pattern support" })
end

return M
