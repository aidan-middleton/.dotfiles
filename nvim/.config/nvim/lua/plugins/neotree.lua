vim.pack.add({ 
    {
        src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
        version = vim.version.range('3')
    },
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
})

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
