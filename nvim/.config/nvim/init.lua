-- ~/.config/nvim/init.lua

-- custom variables

local theme = "my-theme"

-- vim options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true 

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- Set space as leader key (optional, if not already set)
vim.g.mapleader = " "

-- Copy to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })        -- Visual selection
vim.keymap.set("n", "<leader>Y", '"+yg_', { noremap = true, silent = true })      -- From cursor to end of line
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true })        -- Normal mode
vim.keymap.set("n", "<leader>yy", '"+yy', { noremap = true, silent = true })      -- Yank entire line

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true })        -- After cursor
vim.keymap.set("n", "<leader>P", '"+P', { noremap = true, silent = true })        -- Before cursor
vim.keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true })        -- Replace visual with clipboard
vim.keymap.set("v", "<leader>P", '"+P', { noremap = true, silent = true })        -- Paste before selection

-- Optional: diagnostics config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

-- Setup commands
vim.cmd("colorscheme " .. theme)

-- Load plugins
require("plugins.lazy") 
