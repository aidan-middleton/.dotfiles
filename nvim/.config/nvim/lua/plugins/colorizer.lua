vim.pack.add { 'https://github.com/catgoose/nvim-colorizer.lua' }

require 'colorizer'.setup {
    filetypes = {
        '*', -- Highlight all files (use '!ft' to exclude a filetype).
        -- Named colors ("red", "white") are only meaningful in stylesheets/markup,
        -- so re-enable them just there to avoid highlighting identifiers in code.
        css = { names = true },
        scss = { names = true },
        sass = { names = true },
        less = { names = true },
        html = { names = true },
    },
    user_default_options = {
        names = false,       -- Named colors ("blue", "red") -- off by default (see filetypes).
        RGB = true,          -- #RGB hex
        RGBA = true,         -- #RGBA hex
        RRGGBB = true,       -- #RRGGBB hex
        RRGGBBAA = true,     -- #RRGGBBAA hex (with alpha)
        rgb_fn = true,       -- rgb() and rgba() functions
        hsl_fn = true,       -- hsl() and hsla() functions
        css = true,          -- Enable all CSS *features* (names, RGB, RGBA, ...).
        css_fn = true,       -- Enable all CSS *functions* (rgb_fn, hsl_fn).
    },
}
