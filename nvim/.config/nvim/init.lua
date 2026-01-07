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
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy visual selection to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { noremap = true, silent = true, desc = "Copy from cursor to end of line to clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { noremap = true, silent = true, desc = "Copy entire line" })

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste after cursor" })
vim.keymap.set("n", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before cursor" })
vim.keymap.set("v", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Pate and replace visual selection"})
vim.keymap.set("v", "<leader>P", '"+P', { noremap = true, silent = true, desc = "Paste before visual selection"})

-- Optional: diagnostics config
vim.diagnostic.config({
    virtual_text = true,
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
        "--query-driver=/usr/bin/clang++",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git"},
})
setup_lsp('codelld')

-- LANGUAGE: Go
setup_lsp('gopls', {
    cmd = {"gopls"},  -- optional if gopls is in PATH
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                nilness = true,
                shadow = true,
            },
            staticcheck = true,
            gofumpt = true,  -- strict formatting
        },
    },
})

-- LANGUAGE: Rust

setup_lsp('rust-analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local is_library = function()
            local user_home = vim.fs.normalize(vim.env.HOME)
            local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
            local registry = cargo_home .. '/registry/src'
            local git_registry = cargo_home .. '/git/checkouts'

            local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
            local toolchains = rustup_home .. '/toolchains'

            for _, item in ipairs { toolchains, registry, git_registry } do
                if vim.fs.relpath(item, fname) then
                    local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
                    return #clients > 0 and clients[#clients].config.root_dir or nil
                end
            end
        end
        local reused_dir = is_library()
        if reused_dir then
            on_dir(reused_dir)
            return
        end

        local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
        local cargo_workspace_root

        if cargo_crate_dir == nil then
            on_dir(
                vim.fs.root(fname, { 'rust-project.json' })
                    or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            )
            return
        end

        local cmd = {
            'cargo',
            'metadata',
            '--no-deps',
            '--format-version',
            '1',
            '--manifest-path',
            cargo_crate_dir .. '/Cargo.toml',
        }

        vim.system(cmd, { text = true }, function(output)
            if output.code == 0 then
                if output.stdout then
                    local result = vim.json.decode(output.stdout)
                    if result['workspace_root'] then
                        cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
                    end
                end

                on_dir(cargo_workspace_root or cargo_crate_dir)
            else
                vim.schedule(function()
                    vim.notify(('[rust_analyzer] cmd failed with code %d: %s\n%s'):format(output.code, cmd, output.stderr))
                end)
            end
        end)
    end,
    capabilities = {
        experimental = {
            serverStatusNotification = true,
            commands = {
                commands = {
                    'rust-analyzer.showReferences',
                    'rust-analyzer.runSingle',
                    'rust-analyzer.debugSingle',
                },
            },
        },
    },
    before_init = function(init_params, config)
        -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
        if config.settings and config.settings['rust-analyzer'] then
            init_params.initializationOptions = config.settings['rust-analyzer']
        end
        ---@param command table{ title: string, command: string, arguments: any[] }
        vim.lsp.commands['rust-analyzer.runSingle'] = function(command)
            local r = command.arguments[1]
            local cmd = { 'cargo', unpack(r.args.cargoArgs) }
            if r.args.executableArgs and #r.args.executableArgs > 0 then
                vim.list_extend(cmd, { '--', unpack(r.args.executableArgs) })
            end

            local proc = vim.system(cmd, { cwd = r.args.cwd })

            local result = proc:wait()

            if result.code == 0 then
                vim.notify(result.stdout, vim.log.levels.INFO)
            else
                vim.notify(result.stderr, vim.log.levels.ERROR)
            end
        end
    end,
    on_attach = function(_, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
            local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
            for _, client in ipairs(clients) do
                vim.notify 'Reloading Cargo Workspace'
                client:request('rust-analyzer/reloadWorkspace', nil, function(err)
                    if err then
                        error(tostring(err))
                    end
                    vim.notify 'Cargo workspace reloaded'
                end, 0)
            end
        end, { desc = 'Reload current cargo workspace' })
    end,
})

-- LANGUAGE: java 
setup_lsp("jdtls",{
    cmd = { 'jdtls' },
    root_markers = { '.git', 'pom.xml', 'build.gradle' },
    settings = {
        java = {
            project = {
                outputPath = "build/classes"
            }
        }
    },
})

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
    { "mfussenegger/nvim-dap" },
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
