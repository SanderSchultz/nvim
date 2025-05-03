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


--Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


--Initializes lazy
require('lazy').setup {

	{ import = "plugins" },

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

	--Enables lualine, the line at the bottom, this has to be included this way with brackets!
	{ 'nvim-lualine/lualine.nvim', opts = {} },

	--Use "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim',     opts = {} },

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

}

require("utils.treesitter_utils")
require("config.highlights")
require("config.autocmds")
require("config.keymaps")
