vim.pack.add { 'https://github.com/norcalli/nvim-colorizer.lua' }

require 'colorizer'.setup {
    '*'; -- Highlight all files, but customize some others. (Note: use ! to exclude)
    css = { rgb_fn = true; }; -- Enable parsing rgb(...) functions in css.
}
