-- ~/.config/nvim/lua/plugin/gitsigns.lua
vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
    on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(t)
            vim.keymap.set(t.mode, t.keys, t.action, {desc = t.desc, buffer = bufnr })
        end

        -- Navigation
        map({
            mode = 'n',
            keys = ']c',
            action = 
                function()
                    if vim.wo.diff then
                        vim.cmd.normal { ']c', bang = true }
                    else
                        gitsigns.nav_hunk 'next'
                    end
                end,
            desc = 'Jump to next git [c]hange'
        })
    
        map({
            mode = 'n', 
            keys = '[c',
            action = 
                function()
                    if vim.wo.diff then
                        vim.cmd.normal { '[c', bang = true }
                    else
                        gitsigns.nav_hunk 'prev'
                    end
                end, 
            desc = 'Jump to previous git [c]hange'
        })

        -- Actions
        -- visual mode
        map({
            mode = 'v',
            keys = '<leader>hs',
            action = 
                function() 
                    gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } 
                end,
            desc = 'git [s]tage hunk'
        })
        map({
            mode = 'v',
            keys = '<leader>hr',
            action = 
                function() 
                    gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } 
                end,
            desc = 'git [r]eset hunk'
        })
        -- normal mode
        map({
            mode = 'n',
            keys = '<leader>hs',
            action = gitsigns.stage_hunk, 
            desc = 'git [s]tage hunk'
        })
        map({
            mode = 'n',
            keys = '<leader>hr',
            action = gitsigns.reset_hunk, 
            desc = 'git [r]eset hunk'
        })
        map({
            mode = 'n',
            keys = '<leader>hS',
            action = gitsigns.stage_buffer, 
            desc = 'git [S]tage buffer'
        })
        map({
            mode = 'n',
            keys = '<leader>hR',
            action = gitsigns.reset_buffer, 
            desc = 'git [R]eset buffer'
        })
        map({
            mode = 'n',
            keys = '<leader>hp',
            action = gitsigns.preview_hunk, 
            desc = 'git [p]review hunk'
        })
        map({
            mode = 'n',
            keys = '<leader>hi',
            action = gitsigns.preview_hunk_inline, 
            desc = 'git preview hunk [i]nline'
        })
        map({
            mode = 'n',
            keys = '<leader>hb',
            action = 
                function() 
                    gitsigns.blame_line { full = true } 
                end, 
            desc = 'git [b]lame line'
        })
        map({
            mode = 'n',
            keys = '<leader>hd',
            action = gitsigns.diffthis, 
            desc = 'git [d]iff against index'
        })
        map({
            mode = 'n',
            keys = '<leader>hD',
            action = 
                function() 
                    gitsigns.diffthis '@' 
                end, 
            desc = 'git [D]iff against last commit'
        })
        map({
            mode = 'n',
            keys = '<leader>hQ',
            action = 
                function() 
                    gitsigns.setqflist 'all' 
                end,
            desc = 'git hunk [Q]uickfix list (all files in repo)'
        })
        map({
            mode = 'n',
            keys = '<leader>hq',
            action = gitsigns.setqflist, 
            desc = 'git hunk [q]uickfix list (all changes in this file)'
        })
        -- Toggles
        map({
            mode = 'n',
            keys = '<leader>tb',
            action = gitsigns.toggle_current_line_blame, 
            desc = '[T]oggle git show [b]lame line'
        })
        map({
            mode = 'n',
            keys = '<leader>tw',
            action = gitsigns.toggle_word_diff, 
            desc = '[T]oggle git intra-line [w]ord diff'
        })

        -- Text object
        map({
            mode = { 'o', 'x' }, 
            keys = 'ih', 
            action = gitsigns.select_hunk,
            desc = ''
        })
    end,
}
