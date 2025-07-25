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

local lazy = require("lazy")

-- Plugins
lazy.setup({
  { "neovim/nvim-lspconfig" },  -- LSP support
  { "hrsh7th/nvim-cmp" },       -- Completion plugin
  { "hrsh7th/cmp-nvim-lsp" },   -- LSP source for nvim-cmp
  { "L3MON4D3/LuaSnip" },       -- Snippet engine
  { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
  { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate"},
  { "norcalli/nvim-colorizer.lua" },
})
