---@diagnostic disable: undefined-global

-- NOTE: Note -- NOTE:
-- TODO: Todo -- TODO:
-- FIXME: Fix me --FIXME:
-- WARNING: Warning -- WARNING:

--For jumping between split-windows do Ctrl+w w, it will jump to next windows or do Ctrl + hjkl to go to specific
--For checking diagnostics of an error do <leader>d
--For opening fzf in normal terminal do Alt+c
--Telescope file finder Ctrl+X, press C-v for vsplit, C-x for split, C-t for new tab
--For jumping back do Ctrl+o, for jumping forward do Ctrl+i
--For deleting next argument in functions() do 'dn'

--Different commands using i/a (inside and around) and n/l (next, last) = diq (delete inside quotes) dif (delete inside function) dib (delete inside brackets) daa (delet around argument) dana (delete around next argument) dala (delete inside last argument). di? is a custom edge delete

--Disables built in mode-selection (insert, normal) because lualine is used
vim.opt.showmode = false

--Sets netrw to display tree
vim.g.netrw_liststyle = 3

--Disables showing dotfiles on launch in netrw, use 'gh' to toggle
-- vim.g.netrw_list_hide = '\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

--Enables line numbers in margin
vim.opt.nu = true

-- Ignore case in search
vim.opt.ignorecase = true

-- Override ignorecase if search contains uppercase letters
vim.opt.smartcase = true

--Enables relativenumber in margin
vim.opt.relativenumber = true

--Highlights where cursor is positioned
vim.opt.cursorline = true

--Sets number of spaces that a tab character represents
vim.opt.tabstop = 4

--Sets tab count while editing
vim.opt.softtabstop = 4

--Determines numbers of spaces used for each indentation
vim.opt.shiftwidth = 4

--Converts tabs into spaces
vim.opt.expandtab = false

--Inserts indentaiton in a smart way based on code structure
vim.opt.smartindent = true

--Disables swapfiles to store changes not written to disk yet
vim.opt.swapfile = false

--Disables backupfiles, which is used before overwriting
vim.opt.backup = false

--Sets the dir where vim stores undo files
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'

--Enables persistent undo, which is saved to undo files
vim.opt.undofile = true

--Highlights all matches of the search pattern
vim.opt.hlsearch = true

--Enables incremental search, results are shown as you type
vim.opt.incsearch = true

--Enables true colors support in terminal
vim.opt.termguicolors = true

--Keeps x amount of lines above and below cursor while scrolling
vim.opt.scrolloff = 8

--Always show sign column/margin
vim.opt.signcolumn = 'yes'

--Adds @-@  to list of valid characters in file names, filenames can now include @
vim.opt.isfname:append '@-@'

--How fast vim triggers the CursorHold event
vim.opt.updatetime = 10

--Hardsets .h files to be interpreted as .c files
vim.cmd("autocmd BufRead,BufNewFile *.h set filetype=c")

--Opens a new terminal in the same dir with Ctrl+t
-- vim.keymap.set('n', '<C-t>', ':!konsole --workdir %:p:h & disown<CR><CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', ':!kitty --directory %:p:h & disown<CR><CR>', { noremap = true, silent = true })

-- Go to the next tab using Tab
-- vim.keymap.set('n', '<C-i>', '<C-i>', { noremap = true, silent = true })

--Sets the mapleader key
vim.g.mapleader = ','

--See diagnostic of error, leader d
vim.keymap.set('n', '<C-i>', ':lua vim.diagnostic.open_float(nil, {focus = false})<CR>', { noremap = true, silent = true })

--Rename all variables, Ctrl + r
vim.keymap.set('n', '<C-r>', ':%s/')

--Opens the netrw dir
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

--Changes keymapping for end of line and beginning of line
vim.keymap.set('n', '<Space>', '$', { noremap = true })
vim.keymap.set('n', 'n', '^', { noremap = true })
vim.keymap.set('i', '<A-Space>', '<Esc>', { noremap = true })

--Changes / search to 's'
vim.keymap.set('n', 's', '/', { noremap = true })

--Changes Ctrl+n to move to next instance in search, SHIFT+n to go backwards
vim.keymap.set('n', '<C-n>', 'n', {noremap = true});

--To unmark what has been marked by search
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true, silent = true })

-- Opens Oil
vim.keymap.set('n', '-', '<cmd>Oil<CR>')

-- -- Bind the function to a shortcut
-- vim.keymap.set('n', 'dn', cycle_arguments, { noremap = true, silent = true })

--Sets df to delete backwards similar to dt, using dT
vim.keymap.set('n', 'df', 'dT', {noremap = true});

--Moves highlighted lines up and down inside the file
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

--Makes what is highlighted copied or pasted from/to clipboard
vim.keymap.set('n', 'y', '"+y')
vim.keymap.set('v', 'y', '"+y')
vim.keymap.set('n', 'Y', '"+Y')

vim.keymap.set('n', 'p', '"+p')
vim.keymap.set('v', 'p', '"+p')
vim.keymap.set('n', 'P', '"+P')

function print_treesitter_node_info()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  if node then
    print("Node type: " .. node:type())
    print("Node text: " .. vim.treesitter.get_node_text(node, 0))
    if node:parent() then
      print("Parent type: " .. node:parent():type())
    end
    print("Children:")
    for child, _ in node:iter_children() do
      print("  - " .. child:type() .. ": " .. vim.treesitter.get_node_text(child, 0))
    end
  else
    print("No Treesitter node found at cursor")
  end
end

vim.api.nvim_create_user_command('TSNodeInfo', print_treesitter_node_info, {})

--Make deleting files interact with clipboard
vim.keymap.set('n', 'dd', '"+dd', {noremap = true})
vim.keymap.set('v', 'd', '"+d', {noremap = true})

--Sets Ctrl + z to go back just like 'u'
vim.keymap.set('n', '<C-z>', ':undo<CR>', { noremap = true })

--Sets Ctrl + s to save file like :w
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true })

--Sets Ctrl + q to quit like :q!
vim.keymap.set('n', '<C-q>', ':q!<CR>', { noremap = true })

--Sets mappings to complete parentheses and quotes
vim.keymap.set('i', '(', '()<Left>', {})
vim.keymap.set('i', '[', '[]<Left>', {})
vim.keymap.set('i', '{', '{}<Left>', {})
vim.keymap.set('i', '"', '""<Left>', {})
vim.keymap.set('i', '\'', '\'\'<Left>', {})

--Opens the Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

--Signs to be used in margin
local signs = { Error = ' ', Warning = ' ', Hint = ' ', Information = ' ' }
for type, icon in pairs(signs) do
	local hl = 'DiagnosticSign' .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

local function wait_for_window_to_close(bufname, callback)
	local timer = vim.loop.new_timer()
	timer:start(100, 100, vim.schedule_wrap(function()
		local bufnr = vim.fn.bufnr(bufname)
		if bufnr == -1 or not vim.api.nvim_buf_is_loaded(bufnr) then
			timer:stop()
			timer:close()
			callback()
		end
	end))
end

local function update_all()
	vim.cmd 'TSUpdate'

	wait_for_window_to_close('TSUpdate', function()
		vim.cmd 'Mason'

		wait_for_window_to_close('Mason', function()
			vim.cmd 'Lazy'
		end)
	end)
end

--Runs the update_all function
vim.api.nvim_create_user_command('UpdateAll', update_all, {})

--Highlight for LazyGit
vim.cmd([[
augroup LazyGitColors
autocmd!
autocmd ColorScheme * highlight LazyGitBorder guifg=#1e222a
augroup END
]])

-- Create an autocommand group for LaTeX specific settings
vim.api.nvim_create_augroup('LaTeX', { clear = true })

-- Autocommands for LaTeX files
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'tex',
	group = 'LaTeX',
	callback = function()
		-- Remap when in a .tex file
		vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', '$', 'g<space>', { noremap = true, silent = true })
		vim.api.nvim_buf_set_keymap(0, 'n', '0', 'gn', { noremap = true, silent = true })
	end,
})

--Highlights text when yanking/copying
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


--Initializes lazy
require('lazy').setup {

	--Toggle terminal with Ctrl+b
	{'akinsho/toggleterm.nvim',
	version = '*',
	config = function()
		require("toggleterm").setup{
			size = 20,
			open_mapping = [[<c-b>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = '1',
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = 'horizontal',
			close_on_exit = true,
			shell = vim.o.shell,
			float_opts = {
				border = 'curved',
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				}
			}
		}
	end
},

--Configures LazyGit
{'kdheepak/lazygit.nvim',
cmd = {
	"LazyGit",
	"LazyGitConfig",
	"LazyGitCurrentFile",
	"LazyGitFilter",
	"LazyGitFilterCurrentFile",
},
dependencies = {
	"nvim-lua/plenary.nvim",
},
-- setting the keybinding for LazyGit with 'keys' is recommended in
-- order to load the plugin when the command is run for the first time
keys = {
	{ "<A-g>", "<cmd>LazyGit<cr>", desc = "LazyGit" }
}
	},

	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			keymaps = {
				['<C-s>'] = false, -- Disable Oil's Ctrl+S keybinding
				["gg"] = { "actions.toggle_hidden", mode = "n" },
			}
		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},

	--Enables jupyter notebook
	--<leader>os for opening split view with jupyter notebook, then press <Enter> on line to run
	--<leader>co or <leader>cO to create new cells, then press <leader><Space> to run cell
	--<leader>do for clearing history
-- 	{'luk400/vim-jukit',
-- 	ft = { 'python', 'json' },
-- 	config = function()
--
-- 		vim.g.jukit_show_execution_signs = 1
--
-- 		vim.g.jukit_shell_cmd = '/workspace/.venv/bin/python -m IPython --no-autoindent'
-- 		-- Resets jukit history and converts to .ipynb file
-- 		vim.api.nvim_set_keymap('n', '<leader>nno', ":call jukit#cells#delete_outputs(1) | call jukit#convert#notebook_convert('jupyter-notebook')<CR>", { noremap = true, silent = true })
-- 		vim.api.nvim_set_keymap('n', '<leader>a', ":call jukit#convert#notebook_convert('script')", { noremap = true, silent = true })
--
-- 		-- Map <leader>all to execute all cells in vim-jukit
-- 		vim.api.nvim_set_keymap('n', '<leader>all', ':call jukit#send#all()<CR>', { noremap = true, silent = true })
--
-- 		-- Sets default mappings
-- 		vim.g.jukit_mappings_use_default = 0
-- 	end,
-- },

--Vimtex is a vim version of LaTeX
-- 'lervag/vimtex',

--Vimsmoothie makes the vim Ctrl+U/D scrolling smooth
'psliwka/vim-smoothie',

--Harpoon, saving files in buffer, Ctrl+e for list, leader+a to add to list
'ThePrimeagen/harpoon',

--Enables undotree to get visual of undo files, leader+u
'mbbill/undotree',

--Lets you do diq (delete inside quotes) dif (delete inside function) dib (delete inside brackets)
{
	'echasnovski/mini.ai',
	version = '*',
	config = function()
		require('mini.ai').setup()
	end
},

--Integrates Git into the nvim terminal, ':Git pull' example
-- 'tpope/vim-fugitive',

--Enables lualine, the line at the bottom, this has to be included this way with brackets!
{ 'nvim-lualine/lualine.nvim', opts = {} },

--Use "gc" to comment visual regions/lines
{ 'numToStr/Comment.nvim',     opts = {} },

--Fuzzy finder in buffer, can use Ctrl+x to open buffer, Ctrl+v to open in new pane
{'nvim-telescope/telescope.nvim',
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

	require ("multigrep").setup()

	-- See `:help telescope.builtin`
	local builtin = require 'telescope.builtin'

	--Opens fuzzy finder for files in the same folder that was opened
	vim.keymap.set('n', '<C-x>', builtin.find_files, {})

	--Opens fuzzy finder for files related to Git
	-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
	-- vim.keymap.set('n', 's', builtin.current_buffer_fuzzy_find, {})
end,
	},

	--Themes in telescope
	{
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
		'AlexvZyl/nordic.nvim',
		-- lazy = false,    -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()

			-- Set highlights AFTER the colorscheme is loaded
			vim.api.nvim_create_autocmd('ColorScheme', {
				pattern = '*',
				callback = function()
					local hl_groups = {
						'Normal',
						'NormalNC',
						'EndOfBuffer',
						'SignColumn',
						'TelescopeNormal',
						'TelescopeBorder',
						'TelescopePromptNormal',
						'TelescopePromptBorder',
						'TelescopeResultsNormal',
						'TelescopeResultsBorder',
						'TelescopePreviewNormal',
						'TelescopePreviewBorder',
					}

					for _, group in ipairs(hl_groups) do
						vim.api.nvim_set_hl(0, group, { bg = 'none' })
					end

					vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#484F58' })
					vim.api.nvim_set_hl(0, 'TelescopePreviewLine', { bg = '#484F58' })
					vim.api.nvim_set_hl(0, 'TelescopeSelection', { bg = '#484F58', fg = '#ffffff' })
					vim.api.nvim_set_hl(0, 'Comment', { fg = '#B0B0B0', italic = true })

				end,
			})

			-- Set Nordic theme globally
			vim.cmd.colorscheme 'nordic'

			--Sets specific theme for .c and .cpp files
			vim.api.nvim_create_autocmd('FileType', {
				pattern = { 'c', 'cpp' },
				callback = function()
					vim.schedule(function()
						vim.cmd.colorscheme 'github_dark'

						-- Remove the background (applies globally, but you can limit it to filetype-specific logic)
						vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
						vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
						vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
						vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
						vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#484F58' })
						vim.api.nvim_set_hl(0, 'Comment', { fg = '#B0B0B0', italic = true })

						require('lualine').setup {
							options = {
								theme = 'nordic'
							}
						}
					end)
				end,
			})

		end,
	},

	--LSP Configuration & Plugins
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- Useful status updates for LSP.
			{ 'j-hui/fidget.nvim', opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)

					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-T> or <C-o>.
					map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

					-- Find references for the word under your cursor.
					map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					-- map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

					-- Fuzzy find all the symbols in your current workspace
					--  Similar to document symbols, except searches over your whole project.
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map('K', vim.lsp.buf.hover, 'Hover Documentation')

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {
				pylsp = {
					settings = {
						pylsp = {
							-- Specify the Python path for Poetry's virtual environment
							configurationSources = { "pycodestyle" },
							plugins = {
								jedi = {
									-- This is specifically for pylsp to work in poetry container!
									environment = "/workspace/.venv",
									auto_import = true,
								},
								pycodestyle = {
									enabled = true,
									ignore = { "E501", "E262", "W503", "E266", "E402" },
									maxLineLength = 999,
								},
								flake8 = {
									enabled = true,
									ignore = { "E501", "E262", "W503", "E266", "N8", "E402"},
								},
								pylint = {
									enabled = false,
									args = { "--disable=C0301, C0103, C0411" },
								},
							},
						},
					},
				},
			}

			--For lsp management use ':Mason'
			require('mason').setup()
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			--Sets qss files to be interpreted as css
			vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
				pattern = {"*.qss"},
				command = "setfiletype css",
			})

			--Sets js files to be interpreted as ts
			vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
				pattern = {"*.js", "*.jsx", "*.tsx"},
				command = "setfiletype typescript",
			})

			--Sets ibpn files to be interpreted as python
			-- vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
			-- 	pattern = {"*.ipynb"},
			-- 	command = "setfiletype python",
			-- })

			--Local harpoon variables
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")
			vim.keymap.set("n", "<leader>a", mark.add_file)
			vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
			vim.keymap.set("n", "<C-f>", function() ui.nav_next() end)

			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for tsserver)
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			}
		end,
	},

	-- Autocompletion
	{'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			'L3MON4D3/LuaSnip',
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This step is not supported in many windows environments
				-- Remove the below condition to re-enable on windows
				if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
					return
				end
				return 'make install_jsregexp'
			end)(),
		},
		'saadparwaiz1/cmp_luasnip',

		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
	},
	config = function()
		-- See `:help cmp`
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = 'menu,menuone,noinsert' },

			mapping = cmp.mapping.preset.insert {

				['<TAB>'] = cmp.mapping.confirm { select = true },
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
			},
		}
	end,
},

{
	'morhetz/gruvbox',
	lazy = true,
},
{
	'olimorris/onedarkpro.nvim',
	lazy = true,
},
{
	'projekt0n/github-nvim-theme',
	lazy = true,
},

-- Highlight  NOTE: etc in comments
{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

{
	'nvim-treesitter/playground',
	cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' }, -- Load only when needed
},

-- Highlight, edit, and navigate code
{
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require('nvim-treesitter.configs').setup {
			ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = { enable = true },
			-- indent = { enable = true },
		}

		require ("treesitter_utils").setup()


	end,
},

}
