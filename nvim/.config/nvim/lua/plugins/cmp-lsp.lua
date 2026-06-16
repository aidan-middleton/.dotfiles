vim.pack.add { 'https://github.com/hrsh7th/cmp-nvim-lsp'}

vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
