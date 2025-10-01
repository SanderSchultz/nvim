--LSP Configuration & Plugins
return {
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for neovim
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',

		-- Useful status updates for LSP.
		{
			'j-hui/fidget.nvim',
			opts = {
				notification = {
					window = {
						winblend = 0,
					}
				}
			}
		},
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
				-- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

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
				map('gR', vim.lsp.buf.rename, '[R]e[n]ame')

				map('gC', vim.lsp.buf.incoming_calls, 'Incoming Calls')
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
								environment = "/workspaces/web_synpop/.venv",
								auto_import = true,
							},
							pycodestyle = {
								enabled = true,
								ignore = { "E501", "E262", "W503", "E266", "E402" },
								maxLineLength = 999,
							},
							flake8 = {
								enabled = true,
								ignore = { "E501", "E262", "W503", "E266", "N8", "E402" },
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
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.qss" },
			command = "setfiletype css",
		})

		--Sets js files to be interpreted as ts
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.js", "*.jsx", "*.tsx" },
			command = "setfiletype typescript",
		})

		--Formats file by LSP standard
		vim.keymap.set('n', '=G', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

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
}
