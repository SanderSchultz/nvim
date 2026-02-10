local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.select_target = function(opts)
	opts = opts or {}

	local cmake = require("cmake-tools")
	local targets = cmake.get_launch_targets()

	if not targets or not targets.data or not targets.data.targets then
		vim.notify("No CMake targets found. Run :CMakeGenerate first.", vim.log.levels.WARN)
		return
	end

	local target_list = targets.data.targets
	local current_target = targets.data.current

	pickers.new(opts, {
		prompt_title = "CMake Targets",
		finder = finders.new_table({
			results = target_list,
			entry_maker = function(entry)
				local display = entry
				if entry == current_target then
					display = entry .. " (current)"
				end
				return {
					value = entry,
					display = display,
					ordinal = entry,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					cmake.set_launch_target(selection.value)
					vim.notify("CMake target set to: " .. selection.value)
				end
			end)
			return true
		end,
	}):find()
end

M.select_build_type = function(opts)
	opts = opts or {}

	local cmake = require("cmake-tools")
	local build_types = { "Debug", "Release", "RelWithDebInfo", "MinSizeRel" }

	pickers.new(opts, {
		prompt_title = "CMake Build Type",
		finder = finders.new_table({
			results = build_types,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					cmake.set_build_type(selection.value)
					vim.notify("CMake build type set to: " .. selection.value)
				end
			end)
			return true
		end,
	}):find()
end

M.select_configure_preset = function(opts)
	opts = opts or {}

	local cmake = require("cmake-tools")
	local presets = cmake.get_configure_presets()

	if not presets or not presets.data or not presets.data.presets then
		vim.notify("No configure presets found.", vim.log.levels.WARN)
		return
	end

	local preset_list = presets.data.presets
	local current_preset = presets.data.current

	pickers.new(opts, {
		prompt_title = "CMake Configure Presets",
		finder = finders.new_table({
			results = preset_list,
			entry_maker = function(entry)
				local display = entry
				if entry == current_preset then
					display = entry .. " (current)"
				end
				return {
					value = entry,
					display = display,
					ordinal = entry,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					cmake.set_configure_preset(selection.value)
					vim.notify("Configure preset set to: " .. selection.value)
				end
			end)
			return true
		end,
	}):find()
end

M.select_build_preset = function(opts)
	opts = opts or {}

	local cmake = require("cmake-tools")
	local presets = cmake.get_build_presets()

	if not presets or not presets.data or not presets.data.presets then
		vim.notify("No build presets found.", vim.log.levels.WARN)
		return
	end

	local preset_list = presets.data.presets
	local current_preset = presets.data.current

	pickers.new(opts, {
		prompt_title = "CMake Build Presets",
		finder = finders.new_table({
			results = preset_list,
			entry_maker = function(entry)
				local display = entry
				if entry == current_preset then
					display = entry .. " (current)"
				end
				return {
					value = entry,
					display = display,
					ordinal = entry,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					cmake.set_build_preset(selection.value)
					vim.notify("Build preset set to: " .. selection.value)
				end
			end)
			return true
		end,
	}):find()
end

M.setup = function()
	vim.api.nvim_create_user_command("CMakeTelescopeTarget", function()
		M.select_target()
	end, {})

	vim.api.nvim_create_user_command("CMakeTelescopeBuildType", function()
		M.select_build_type()
	end, {})

	vim.api.nvim_create_user_command("CMakeTelescopeConfigurePreset", function()
		M.select_configure_preset()
	end, {})

	vim.api.nvim_create_user_command("CMakeTelescopeBuildPreset", function()
		M.select_build_preset()
	end, {})
end

return M
