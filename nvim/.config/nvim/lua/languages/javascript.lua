-- ~/.config/nvim/lua/lsp/javascript.lua
local setup_lsp = require('languages.__utils').setup_lsp

setup_lsp('ts_ls')
setup_lsp('eslint')
