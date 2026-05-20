vim.pack.add { 
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range('>=0.1.8') },
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-file-browser.nvim',
}

local telescope = require 'telescope'
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope key maps' })
vim.keymap.set('n', '<leader>fa', builtin.commands, { desc = 'Telescope help tags' })
vim.keymap.set("n", "<leader>fe", function() telescope.extensions.file_browser.file_browser() end, { desc = 'Telescope file browser'})

telescope.setup {
    defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
    extensions = {
        file_browser = { theme = "ivy", hijack_netrw = true },
    },
}
telescope.load_extension "file_browser"
