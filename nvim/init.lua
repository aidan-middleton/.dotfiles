-- ~/.config/nvim/init.lua
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true

-- Set up lazy.nvim runtime path (MUST come before require("lazy"))
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- Optional: auto-clone if not found
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "neovim/nvim-lspconfig" },  -- LSP support
  { "hrsh7th/nvim-cmp" },       -- Completion plugin
  { "hrsh7th/cmp-nvim-lsp" },   -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip" },       -- Snippet engine
  { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
  {"nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"}
})

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }
})

local lspconfig = require("lspconfig")

-- Enable pyright for Python
lspconfig.pyright.setup{}

-- Optional: diagnostics config
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

