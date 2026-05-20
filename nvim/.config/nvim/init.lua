-- ~/.config/nvim/init.lua

-- custom variables
local theme = "blackula"

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

-- Optional: diagnostics config
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
})

-- Setup commands
vim.cmd("colorscheme " .. theme)

-- Format on paste
vim.api.nvim_create_autocmd("TextChangedP", {
    callback = function()
        local start = vim.fn.getpos("'[")
        local finish = vim.fn.getpos("']")

        vim.lsp.buf.format({
            range = {
                ["start"] = { start[2] - 1, start[3] - 1 },
                ["end"] = { finish[2] - 1, finish[3] },
            },
        })
    end,
})


--
-- Tab line
--

vim.o.tabline = "%!v:lua.TabLine()"

function TabLine()
    local s = ""
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tabs = vim.api.nvim_list_tabpages()

    for i, tab in ipairs(tabs) do
        local tab_number = i
        local wins = vim.api.nvim_tabpage_list_wins(tab)
        local bufname = ""

        -- Get filename of first window in tab
        if #wins > 0 then
            local buf = vim.api.nvim_win_get_buf(wins[1])
            bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") -- filename only
        end

        -- Highlight current tab
        if tab == current_tab then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end

        -- Add tab number and filename
        s = s .. " " .. tab_number .. " " .. (bufname ~= "" and bufname or "[No Name]") .. " "
    end

    s = s .. "%#TabLineFill#"
    return s
end

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
                      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                      ['<C-f>'] = cmp.mapping.scroll_docs(4),
                      ['<C-Space>'] = cmp.mapping.complete(),
                      ['<C-e>'] = cmp.mapping.abort(),
                      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
            local telescope = require 'telescope'
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
            vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = 'Telescope help tags' })
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope key maps' })
            vim.keymap.set('n', '<leader>fa', builtin.commands, { desc = 'Telescope help tags' })
            vim.keymap.set("n", "<leader>fe", function()
                telescope.extensions.file_browser.file_browser()
            end, { desc = 'Telescope file browser'})
            telescope.setup {
                defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
                extensions = {
                    file_browser = { theme = "ivy", hijack_netrw = true },
                },
            }
            require 'telescope'.load_extension "file_browser"
        end
    },
    { "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    { "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    { "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
                automatic_installation = true,
            })
        end
    },
    { "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dapui = require("dapui")
            dapui.setup()
            local dap = require("dap")
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
            vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
        end
    },
    { "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb,
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Attach",
                    type = "codelldb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
            }
            dap.configurations.c = dap.configurations.cpp

            vim.keymap.set("n", "<F5>",  dap.continue,          { desc = "DAP continue" })
            vim.keymap.set("n", "<F10>", dap.step_over,         { desc = "DAP step over" })
            vim.keymap.set("n", "<F11>", dap.step_into,         { desc = "DAP step into" })
            vim.keymap.set("n", "<F12>", dap.step_out,          { desc = "DAP step out" })
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end, { desc = "DAP conditional breakpoint" })
            vim.keymap.set("n", "<leader>dt", dap.terminate,    { desc = "DAP terminate" })
        end
    },
    { "mfussenegger/nvim-jdtls" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>e", "<Cmd>Neotree<CR>")
            require("neo-tree").setup({
                window = {
                    position = "float",
                    width = 80,
                    height = 20,
                    popup = {
                        border = "rounded",
                    },
                },
                default_component_configs = {
                    indent = {
                        with_expanders = true,
                        expander_collapsed = "",
                        expander_expanded = "",
                        expander_highlight = "NeoTreeExpander",
                    },
                },
                filesystem = {
                    scan_mode = "deep",
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_hidden = true,
                        hide_by_name = {},
                        hide_by_pattern = {},
                    },
                    follow_current_file = true,
                    group_empty_dirs = true, -- this collapses empty folders visually
                },
            })
        end
    },
    { "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = { "nvim-lua/plenary.nvim" },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        }
    },
    { "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup {
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)

                    -- Actions
                    map('n', '<leader>hs', gitsigns.stage_hunk)
                    map('n', '<leader>hr', gitsigns.reset_hunk)

                    map('v', '<leader>hs', function()
                        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end)

                    map('v', '<leader>hr', function()
                        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end)

                    map('n', '<leader>hS', gitsigns.stage_buffer)
                    map('n', '<leader>hR', gitsigns.reset_buffer)
                    map('n', '<leader>hp', gitsigns.preview_hunk)
                    map('n', '<leader>hi', gitsigns.preview_hunk_inline)

                    map('n', '<leader>hb', function()
                        gitsigns.blame_line({ full = true })
                    end)

                    map('n', '<leader>hd', gitsigns.diffthis)

                    map('n', '<leader>hD', function()
                        gitsigns.diffthis('~')
                    end)

                    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
                    map('n', '<leader>hq', gitsigns.setqflist)

                    -- Toggles
                    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                    map('n', '<leader>tw', gitsigns.toggle_word_diff)

                    -- Text object
                    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
                end
            }
        end
    }
})
