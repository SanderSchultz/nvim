vim.opt.showmode = false

local signs = { Error = ' ', Warning = ' ', Hint = ' ', Information = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

vim.opt.updatetime = 50
--For checking diagnostics of an error do <leader>d
--For opening fzf in normal terminal do Alt+c
--Telescope file finder Ctrl+X, press C-v for vsplit, C-x for split, C-t for new tab

local function update_all()
    vim.cmd 'TSUpdate'
    vim.cmd 'Mason'
    vim.cmd 'Lazy'
end

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

--Goes to definition
-- vim.keymap.set('n', 'gd', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })

--Runs the update_all function
vim.api.nvim_create_user_command('UpdateAll', update_all, {})

--Opens a new terminal in the same dir
vim.keymap.set('n', '<C-t>', ':!konsole --workdir %:p:h & disown<CR><CR>', { noremap = true, silent = true })

--Sets the mapleader key
vim.g.mapleader = ','

--Sets the keymaps open diagnostic on error I am on
vim.keymap.set('n', '<leader>d', ':lua vim.diagnostic.open_float(nil, {focus = false})<CR>',
    { noremap = true, silent = true })

--Sets the keymaps to replace name of variables at once
vim.keymap.set('n', '<leader>r', ':%s/')

--Opens the netrw dir
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

--Changes keymapping for end of line and beginning of line
vim.keymap.set('n', '<Space>', '$', { noremap = true })
vim.keymap.set('n', 'n', '^', { noremap = true })

--Moves highlighted lines up and down inside the file
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

--Makes what is highlighted copied to clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')

--Sets Ctrl + z to go back just like u
vim.keymap.set('n', '<C-z>', ':undo<CR>', { noremap = true })

--Sets Ctrl + s to save file like :w
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true })

--Sets Ctrl + q to quit like :q!
vim.keymap.set('n', '<C-q>', ':q!<CR>', { noremap = true })

--Sets mappings to complete parentheses and quotes
vim.keymap.set('i', '(', '()<Left>', {})
vim.keymap.set('i', '[', '[]<Left>', {})
vim.keymap.set('i', '{', '{}<Left>', {})
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {

    -- Use `opts = {}` to force a plugin to be loaded.
    'lervag/vimtex',
    'psliwka/vim-smoothie',
    'ThePrimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    { 'nvim-lualine/lualine.nvim', opts = {} },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim',     opts = {} },

    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-ui-select.nvim' },

            -- Useful for getting pretty icons, but requires special font.
            --  If you already have a Nerd Font, or terminal set up with fallback fonts
            --  you can enable this
            { 'nvim-tree/nvim-web-devicons' },
        },
        config = function()
            local actions = require 'telescope.actions'
            local action_state = require 'telescope.actions.state'

            -- Custom action to open files in a new terminal session
            local open_in_new_terminal = function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local filepath = selection.path
                -- Adjust the terminal command according to your setup
                local cmd = string.format("konsole -e nvim '%s' &", filepath)
                actions.close(prompt_bufnr)
                -- vim.cmd(string.format('!%s', cmd))
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
                },
            }

            -- See `:help telescope.builtin`
            local builtin = require 'telescope.builtin'
            --Opens fuzzy finder for files in the same folder that was opened
            vim.keymap.set('n', '<C-x>', builtin.find_files, {})

            --Opens fuzzy finder for files related to Git
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '/', builtin.current_buffer_fuzzy_find, {})
        end,
    },

    { -- LSP Configuration & Plugins
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
                    -- NOTE: Remember that lua is a real programming language, and as such it is possible
                    -- to define small helper and utility functions so you don't have to repeat yourself
                    -- many times.
                    --
                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-T>.
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
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

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

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP Specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {}

            --    :Mason
            require('mason').setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }

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

    -- { -- Autoformat
    --     'stevearc/conform.nvim',
    --     opts = {
    --         notify_on_error = false,
    --         format_on_save = {
    --             timeout_ms = 500,
    --             lsp_fallback = true,
    --         },
    --     },
    -- },

    { -- Autocompletion
        'hrsh7th/nvim-cmp',
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
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
        'AlexvZyl/nordic.nvim',
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.cmd.colorscheme 'nordic'
        end,
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Highlight, edit, and navigate code
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
        end,
    },
}
