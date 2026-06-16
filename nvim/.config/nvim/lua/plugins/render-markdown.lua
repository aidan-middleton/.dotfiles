vim.pack.add {
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {}

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.conceallevel = 2
    end,
})
