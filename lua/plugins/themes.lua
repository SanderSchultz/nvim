--Themes in telescope
return {
	-- Nordic theme
	{
		'AlexvZyl/nordic.nvim',
		lazy = false,
		priority = 1000,
	},
	-- GitHub theme
	{
		'projekt0n/github-nvim-theme',
		lazy = false,
		priority = 1000,
	},
	-- Gruvbox theme
	{
		'ellisonleao/gruvbox.nvim',
		lazy = false,
		priority = 1000,
	},
	-- Tokyo Night theme
	{
		'folke/tokyonight.nvim',
		lazy = false,
		priority = 1000,
	},

	{
		'shatur/neovim-ayu',
		lazy = false,
		priority = 1000,
	},
	-- Telescope themes extension
	{
		'andrew-george/telescope-themes',
		config = function()
			require('telescope').load_extension('themes')
		end
	},
}
