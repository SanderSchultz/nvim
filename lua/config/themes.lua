---@diagnostic disable: undefined-global

local function apply_transparent_highlights()
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
end

local function set_theme_for_filetype(colorscheme, lualine_theme, transparent)
	vim.schedule(function()
		vim.cmd.colorscheme(colorscheme)

		if transparent then
			apply_transparent_highlights()
		end

		require('lualine').setup {
			options = {
				theme = lualine_theme
			}
		}
	end)
end

local M = {}

vim.cmd.colorscheme('nordic')

-- vim.api.nvim_create_autocmd('ColorScheme', {
-- 	pattern = '*',
-- 	callback = apply_transparent_highlights,
-- })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'c' },
	callback = function()
		set_theme_for_filetype('github_dark', 'nordic', false) -- was true
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'rust', 'rs' },
	callback = function()
		set_theme_for_filetype('gruvbox', 'gruvbox_dark', false) -- was true
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'lua' },
	callback = function()
		set_theme_for_filetype('nordic', 'nordic', false) -- was true
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'cpp', 'cppm' },
	callback = function()
		set_theme_for_filetype('tokyonight-night', 'tokyonight-night', false)
	end,
})

return M
