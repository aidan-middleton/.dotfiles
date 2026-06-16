-- vim options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true

vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldenable = false

vim.o.ttimeoutlen = 750

-- Optional: diagnostics config
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
})

-- Setup commands
vim.cmd('colorscheme blackula')
