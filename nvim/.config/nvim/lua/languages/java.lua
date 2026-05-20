-- ~/.config/nvim/lua/lsp/java.lua
local setup_lsp = require('languages.__utils').setup_lsp

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
