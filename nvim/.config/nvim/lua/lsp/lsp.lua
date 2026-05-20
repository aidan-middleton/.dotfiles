local function setup_lsp(name, configs)
    if type(name) ~= "string" then
        error("Name must be a string")
    end
    if configs ~= nil then
        if type(configs) ~= "table" then
            error("Configs must be a table")
        end
        vim.lsp.config(name, configs)
    end
    vim.lsp.enable(name)
end
