---@diagnostic disable: undefined-global

local M = {}

local function get_ts_utils()
	return require('nvim-treesitter.ts_utils')
end

-- Function to process call_expression node
local function process_call_expression(node)
	if not node or node:type() ~= 'call_expression' then
		print("Node is not a call_expression.")
		return
	end

	-- Locate the argument_list
	for child in node:iter_children() do
		if child:type() == 'argument_list' then
			print("Processing arguments:")
			-- Process meaningful arguments
			for arg in child:iter_children() do
				local arg_type = arg:type()
				local arg_text = vim.treesitter.get_node_text(arg, 0)

				-- Ignore delimiters like `(`, `,`, and `)`
				if arg_type ~= '(' and arg_type ~= ',' and arg_type ~= ')' then
					print("Argument - Type:", arg_type, "Text:", arg_text)
				end
			end
			return
		end
	end
	print("No argument_list found.")
end

-- Main function to analyze the node under cursor
local function analyze_node()
	local parser = vim.treesitter.get_parser(0)
	local tree = parser:parse()[1]
	local root = tree:root()

	-- Get the current node under the cursor
	local node = ts_utils.get_ts_utils.get_node_at_cursor()
	if not node then
		print("No node under cursor.")
		return
	end

	print("Node Under Cursor - Type:", node:type(), "Text:", vim.treesitter.get_node_text(node, 0))

	-- Traverse up to find the parent if the node isn't a call_expression
	local parent = node:parent()
	while parent do
		print("Parent Node - Type:", parent:type(), "Text:", vim.treesitter.get_node_text(parent, 0))
		if parent:type() == 'call_expression' then
			process_call_expression(parent)
			return
		end
		parent = parent:parent()
	end

	print("No call_expression found in parent hierarchy.")
end

-- ###########################################################################################################
-- ###########################################################################################################
-- ###########################################################################################################

-- Helper function to filter unwanted node types
local function is_valid_node(node)
	local invalid_types = { ['('] = true, [')'] = true, [','] = true }
	return not invalid_types[node:type()]
end

local function split_arguments_by_commas(argument_list_node)
	local arguments = {}
	local current_argument = {}

	for child in argument_list_node:iter_children() do
		if child:type() == ',' then
			if #current_argument > 0 then
				table.insert(arguments, current_argument)
				current_argument = {}
			end
		elseif is_valid_node(child) then
			table.insert(current_argument, child)
		end
	end

	if #current_argument > 0 then
		table.insert(arguments, current_argument)
	end

	return arguments
end

local function delete_next_argument(arguments, current_index)
	local next_index = current_index + 1
	if next_index > #arguments then next_index = 1 end

	local argument_group = arguments[next_index]
	local s_row, s_col, e_row, e_col = argument_group[1]:range()
	for _, item in ipairs(argument_group) do
		local item_s_row, item_s_col, item_e_row, item_e_col = item:range()
		s_row, s_col = math.min(s_row, item_s_row), math.min(s_col, item_s_col)
		e_row, e_col = math.max(e_row, item_e_row), math.max(e_col, item_e_col)
	end

	vim.api.nvim_buf_set_text(0, s_row, s_col, e_row, e_col, {})
	vim.api.nvim_win_set_cursor(0, { s_row + 1, s_col })
	vim.cmd('startinsert')
end

local function delete_item(argument_list_node, cursor_row, cursor_col)
	local arguments = split_arguments_by_commas(argument_list_node)
	for i, argument_group in ipairs(arguments) do
		local s_row, s_col, e_row, e_col = argument_group[1]:range()
		for _, item in ipairs(argument_group) do
			local item_s_row, item_s_col, item_e_row, item_e_col = item:range()
			s_row, s_col = math.min(s_row, item_s_row), math.min(s_col, item_s_col)
			e_row, e_col = math.max(e_row, item_e_row), math.max(e_col, item_e_col)
		end

		if cursor_row >= s_row and cursor_row <= e_row and cursor_col >= s_col and cursor_col <= e_col then
			-- Delete the next argument instead of the current one
			delete_next_argument(arguments, i)
			return
		end
	end
	-- If cursor is on the function name or no match, delete the first argument
	delete_next_argument(arguments, 0)
end

local function handle_delete_arg()
	local node = ts_utils.get_node_at_cursor()
	while node and not (node:type() == 'call_expression' or
			node:type() == 'function_declarator' or
			node:type() == 'function_definition' or
			node:type() == 'declaration' or
			node:type() == 'macro_type_specifier' or
			node:type() == 'ERROR') do
		node = node:parent()
	end
	if not node then return print("No valid node found.") end

	local cursor = vim.api.nvim_win_get_cursor(0)
	if node:type() == 'call_expression' then
		-- Handle arguments
		for child in node:iter_children() do
			if child:type() == 'argument_list' then
				delete_item(child, cursor[1] - 1, cursor[2])
				return
			end
		end
	elseif node:type() == 'function_declarator' or node:type() == 'function_definition' or
		node:type() == 'declaration' or node:type() == 'macro_type_specifier' or
		node:type() == 'ERROR' then
		-- Handle parameters
		for child in node:iter_children() do
			if child:type() == 'parameter_list' or child:type() == 'ERROR' then
				delete_item(child, cursor[1] - 1, cursor[2])
				return
			end
		end
	end

	print("No arguments or parameters found.")
end










-- ###########################################################################################################
-- ###########################################################################################################
-- ###########################################################################################################

-- Public setup function
function M.setup()
	vim.keymap.set('n', 'dn', handle_delete_arg, { noremap = true, silent = true })
	vim.api.nvim_create_user_command('AnalyzeNode', analyze_node, {})
end

return M
