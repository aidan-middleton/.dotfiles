-- Set space as leader key (optional, if not already set)
vim.g.mapleader = " "

-- Copy to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy visual selection to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { noremap = true, silent = true, desc = "Copy from cursor to end of line to clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { noremap = true, silent = true, desc = "Copy entire line" })

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste after cursor" })
vim.keymap.set("n", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before cursor" })
vim.keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Pate and replace visual selection"})
vim.keymap.set("v", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before visual selection"})

-- Diagnostic bindings
vim.keymap.set('n', '<Leader>dd', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true, desc = "Show all diagnostics on current line in floating window" })
vim.keymap.set('n', '<Leader>dn', ':lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true, desc = "Go to next diagnostic" })
vim.keymap.set('n', '<Leader>dp', ':lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true, desc = "Go to previous diagnostic" })
