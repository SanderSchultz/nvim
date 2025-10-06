--Fuzzy finder in buffer, can use Ctrl+x to open buffer, Ctrl+v to open in new pane
return {
	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-ui-select.nvim' },
		{ 'nvim-tree/nvim-web-devicons' },
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local actions = require 'telescope.actions'
		local action_state = require 'telescope.actions.state'

		-- Custom action to open files in a new terminal session
		local open_in_new_terminal = function(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			local filepath = selection.path

			local cmd = string.format("kitty nvim '%s' &", filepath)
			actions.close(prompt_bufnr)
			vim.fn.system(cmd)
		end

		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						['<C-v>'] = open_in_new_terminal, -- Insert mode
					},
					n = {
						['<C-v>'] = open_in_new_terminal, -- Normal mode
					},

				},

				file_ignore_patterns = { "build/.*", "node_modules/.*", "obj/.*", "lib/.*", "bin/.*" },
			},
			extensions = {
				fzf = {}
			},
		}

		require('telescope').load_extension('fzf')
		require("utils.combined_grep").setup()

		-- See `:help telescope.builtin`
		local builtin = require 'telescope.builtin'

		--Opens fuzzy finder for files in the same folder that was opened
		vim.keymap.set('n', '<C-x>', function()
			require('telescope.builtin').find_files({
				file_ignore_patterns = { "node_modules", "target", "build" }
			})
		end)

		--Opens fuzzy finder for files related to Git
		-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		-- vim.keymap.set('n', 's', builtin.current_buffer_fuzzy_find, {})
	end,
}
