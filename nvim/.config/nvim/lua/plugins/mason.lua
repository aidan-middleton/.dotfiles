vim.pack.add({ 
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/jay-babu/mason-nvim-dap.nvim',
})

require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb" },
    automatic_installation = true,
})