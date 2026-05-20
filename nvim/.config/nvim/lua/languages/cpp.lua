-- ~/.config/nvim/lua/lsp/cpp.lua
local setup_lsp = require('languages.__utils').setup_lsp

setup_lsp('clangd', {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--pch-storage=memory",
        "--query-driver=/usr/bin/clang*,/usr/bin/g++*,/usr/local/bin/clang*",
    },
    init_options = {
        fallbackFlags = { "--std=c++20" },
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
})
