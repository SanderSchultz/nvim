-- LSP Configuration & Plugins (native API)
return {
	'neovim/nvim-lspconfig', -- still fine to keep installed for extras, but we won't use its setup()
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		{ 'j-hui/fidget.nvim', opts = { notification = { window = { winblend = 0 } } } },
		'hrsh7th/cmp-nvim-lsp',
	},

	config = function()
		-- on-attach keymaps (kept)
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
				end
				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
				map('gR', vim.lsp.buf.rename, '[R]e[n]ame')
				map('gC', vim.lsp.buf.incoming_calls, 'Incoming Calls')
				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
				map('K', vim.lsp.buf.hover, 'Hover Documentation')
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			end,
		})

		local capabilities = vim.tbl_deep_extend(
			'force',
			vim.lsp.protocol.make_client_capabilities(),
			require('cmp_nvim_lsp').default_capabilities()
		)

		-- Mason only installs tools (not clangd, since we use system one)
		require('mason').setup()
		require('mason-tool-installer').setup {
			ensure_installed = { 'pylsp' },
		}

		-- ========= NATIVE LSP CONFIG =========
		-- clangd (system) — matches your compiler & modules setup
		vim.lsp.config('clangd', {
			cmd = {
				'/usr/bin/clangd',
				'--compile-commands-dir=build',
				'--background-index',
				'--query-driver=/usr/bin/clang++,/usr/bin/g++',
				'--offset-encoding=utf-16',
			},
			filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
			root_markers = { 'compile_commands.json', '.git', '.clangd' }, -- native root detection
			single_file_support = false,
			capabilities = capabilities,
		})

		-- pylsp (via mason-installed binary on PATH)
		vim.lsp.config('pylsp', {
			settings = {
				pylsp = {
					configurationSources = { 'pycodestyle' },
					plugins = {
						jedi = { environment = "/workspaces/web_synpop/.venv", auto_import = true },
						pycodestyle = { enabled = true, ignore = { "E501", "E262", "W503", "E266", "E402" }, maxLineLength = 999 },
						flake8 = { enabled = true, ignore = { "E501", "E262", "W503", "E266", "N8", "E402" } },
						pylint = { enabled = false, args = { "--disable=C0301, C0103, C0411" } },
					},
				},
			},
			capabilities = capabilities,
		})

		-- Enable both
		vim.lsp.enable('clangd')
		vim.lsp.enable('pylsp')

		-- your filetype tweaks (kept)
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = { "*.qss" }, command = "setfiletype css" })
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" },
			{ pattern = { "*.js", "*.jsx", "*.tsx" }, command = "setfiletype typescript" })
	end,
}
