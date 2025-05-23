---@diagnostic disable: undefined-global

vim.keymap.set("c", "?", function()
  if vim.fn.getcmdpos() == 1 then
    return vim.api.nvim_replace_termcodes("Oil oil-ssh://", true, false, true)
  end
  return "?"
end, { expr = true, noremap = true, desc = "Oil-SSH prefix when cmdline is empty" })

-- In command‐line mode, make <CR> “smart” for Oil-SSH URIs
vim.keymap.set("c", "<CR>", function()
  if vim.fn.getcmdline():match("^Oil%s+oil%-ssh://[^/]+$") then
    return vim.api.nvim_replace_termcodes("/\r", true, false, true)
  end
  return vim.api.nvim_replace_termcodes("\r", true, false, true)
end, { expr = true, noremap = true, desc = "Oil-SSH: append slash before Enter" })

-- See diagnostics of error, Ctrl + e
vim.keymap.set('n', '<C-e>', ':lua vim.diagnostic.open_float(nil, {focus = false})<CR>',
	{ noremap = true, silent = true })

--Rename all variables, Ctrl + r
vim.keymap.set('n', '<C-r>', ':%s/')

--Undoes the undo (U undoes u)
vim.keymap.set("n", "U", function()
	vim.cmd("redo")
end, { noremap = true, silent = true })

--Changes keymapping for end of line and beginning of line
vim.keymap.set('n', '<Space>', '$', { noremap = true })
vim.keymap.set('n', 'n', '^', { noremap = true })

--Toggles between last 2 files in buffer
vim.keymap.set('n', '<C-f>', '<C-^>')

--Replaces C-w to ALT + these keys, for windows movement and splitting
local map = vim.keymap.set
map('n', '<M-h>', '<C-w>h')
map('n', '<M-j>', '<C-w>j')
map('n', '<M-k>', '<C-w>k')
map('n', '<M-l>', '<C-w>l')
map('n', '<M-w>', '<C-w>w')
map('n', '<M-s>', '<C-w>s') -- Horizontal split
map('n', '<M-v>', '<C-w>v') -- Vertical split

--Changes / search to 's'
vim.keymap.set('n', 's', '/', { noremap = true })

--Formats file by LSP standard
vim.keymap.set('n', '=G', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

--Changes Ctrl+n to move to next instance in search, SHIFT+n to go backwards
vim.keymap.set('n', '<C-n>', 'n', { noremap = true });

--To unmark what has been marked by search
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true, silent = true })

-- Opens Oil
vim.keymap.set('n', '-', '<cmd>Oil<CR>')

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

--Make deleting files interact with clipboard
vim.keymap.set('n', 'dd', '"+dd', { noremap = true })
vim.keymap.set('v', 'd', '"+d', { noremap = true })

--Sets Ctrl + z to go back just like 'u'
vim.keymap.set('n', '<C-z>', ':undo<CR>', { noremap = true })

--Sets Ctrl + s to save file like :w
vim.keymap.set('n', '<C-s>', '<Cmd>update<CR>', { silent = true })
vim.keymap.set('i', '<C-s>', '<Esc><Cmd>update<CR>a', { silent = true })

--Sets Ctrl + s to save file like :w
vim.keymap.set('n', '<C-q>', '<Cmd>quit<CR>', { silent = true })
vim.keymap.set('i', '<C-q>', '<Esc><Cmd>quit<CR>a', { silent = true })

--Sets mappings to complete parentheses and quotes
vim.keymap.set('i', '(', '()<Left>', {})
vim.keymap.set('i', '[', '[]<Left>', {})
vim.keymap.set('i', '{', '{}<Left>', {})
vim.keymap.set('i', '"', '""<Left>', {})
vim.keymap.set('i', '\'', '\'\'<Left>', {})

--Opens the Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
