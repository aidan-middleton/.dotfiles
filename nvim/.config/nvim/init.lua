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

vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.foldenable = false

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

--
-- LSP Setup
--

local function setup_lsp(name, configs)
    if type(name) ~= "string" then
        error("Name must be a string")
    end
    if configs ~= nil then
        if type(configs) ~= "table" then
            error("Configs must be a table")
        end
        vim.lsp.config(name, configs)
    end
    vim.lsp.enable(name)
end

setup_lsp('sonarlint-language-server')

-- LANGUAGE: Lua
setup_lsp('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                return
            end
        end
        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua', }, },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, '${3rd}/luv/library', '${3rd}/busted/library' } }
        })
  end,
  settings = {Lua = {}}
})

-- LANGAUGE: Python
setup_lsp('pyright')

-- LANGAUGE: C++
setup_lsp('clangd', {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git"},
})
setup_lsp('codelld')

--
-- PLUGINS
--

-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim setup
require("lazy").setup({
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp", -- Completion plugin
        config = function()
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
        end
    },
    { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
    { "L3MON4D3/LuaSnip" }, -- Snippet engine
    { "saadparwaiz1/cmp_luasnip" }, -- Snippet completions
    { "nvim-treesitter/nvim-treesitter",
        branch = 'master', lazy = false, build = ":TSUpdate",
        config = function()
            require 'nvim-treesitter.configs'.setup{
                ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "javascript" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    { "norcalli/nvim-colorizer.lua",
        config = function()
            require 'colorizer'.setup {
                '*'; -- Highlight all files, but customize some others. (Note: use ! to exclude)
                css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
            }
        end
    },
    { "nvim-telescope/telescope.nvim",
        tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        end
    },
    { "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
       "m4xshen/hardtime.nvim",
       lazy = false, dependencies = { "MunifTanjim/nui.nvim" }, opts = {},
    },
})
