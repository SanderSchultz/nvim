---@diagnostic disable: undefined-global

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local silent = { silent = true }
local no_remap = { noremap = true }

map('n', '<M-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<M-l>', '<Cmd>BufferNext<CR>', opts)
map('n', '<M-w>', '<Cmd>BufferClose<CR>', opts)

map("c", "?", function()
  if vim.fn.getcmdpos() == 1 then
    return vim.api.nvim_replace_termcodes("Oil oil-ssh://", true, false, true)
  end
  return "?"
end, { expr = true, noremap = true, desc = "Oil-SSH prefix when cmdline is empty" })

-- In command‐line mode, make <CR> “smart” for Oil-SSH URIs
map("c", "<CR>", function()
  if vim.fn.getcmdline():match("^Oil%s+oil%-ssh://[^/]+$") then
    return vim.api.nvim_replace_termcodes("/\r", true, false, true)
  end
  return vim.api.nvim_replace_termcodes("\r", true, false, true)
end, { expr = true, noremap = true, desc = "Oil-SSH: append slash before Enter" })

-- See diagnostics of error, Ctrl + e
map('n', '<C-e>', ':lua vim.diagnostic.open_float(nil, {focus = false})<CR>', opts)

--Rename all variables, Ctrl + r
map('n', '<C-r>', ':%s/')

--Undoes the undo (U undoes u)
map("n", "U", function()
	vim.cmd("redo")
end, opts)

--Changes keymapping for end of line and beginning of line
map('n', '<Space>', '$', no_remap)
map('n', 'n', '^', no_remap)

--Toggles between last 2 files in buffer
map('n', '<C-f>', '<C-^>')

--Replaces C-w to ALT + these keys, for windows movement and splitting
--THESE CONFLICT WITH BARBAR SHORTCUTS
-- map('n', '<M-h>', '<C-w>h')
-- map('n', '<M-j>', '<C-w>j')
-- map('n', '<M-k>', '<C-w>k')
-- map('n', '<M-l>', '<C-w>l')
-- map('n', '<M-w>', '<C-w>w')
-- map('n', '<M-s>', '<C-w>s') -- Horizontal split
-- map('n', '<M-v>', '<C-w>v') -- Vertical split

--Changes / search to 's'
map('n', 's', '/', no_remap)

--Formats file by LSP standard
map('n', '=G', ':lua vim.lsp.buf.format()<CR>', opts)

--Changes Ctrl+n to move to next instance in search, SHIFT+n to go backwards
map('n', '<C-n>', 'n', no_remap);

--To unmark what has been marked by search
map('n', '<Esc>', ':nohlsearch<CR><Esc>', opts)

-- Opens Oil
map('n', '-', '<cmd>Oil<CR>')

--Moves highlighted lines up and down inside the file
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

--Makes what is highlighted copied or pasted from/to clipboard
map('n', 'y', '"+y')
map('v', 'y', '"+y')
map('n', 'Y', '"+Y')

map('n', 'p', '"+p')
map('v', 'p', '"+p')
map('n', 'P', '"+P')

--Make deleting files interact with clipboard
map('n', 'dd', '"+dd', no_remap)
map('v', 'd', '"+d', no_remap)

--Sets Ctrl + z to go back just like 'u'
map('n', '<C-z>', ':undo<CR>', no_remap)

--Sets Ctrl + s to save file like :w
map('n', '<C-s>', '<Cmd>update<CR>', silent)
map('i', '<C-s>', '<Esc><Cmd>update<CR>a', silent)

--Sets Ctrl + s to save file like :w
map('n', '<C-q>', '<Cmd>quit<CR>', silent)
map('i', '<C-q>', '<Esc><Cmd>quit<CR>a', silent)

--Sets mappings to complete parentheses and quotes
map('i', '(', '()<Left>', {})
map('i', '[', '[]<Left>', {})
map('i', '{', '{}<Left>', {})
map('i', '"', '""<Left>', {})
map('i', '\'', '\'\'<Left>', {})

--Opens the Undotree
map('n', '<leader>u', vim.cmd.UndotreeToggle)
