vim.o.tabline = "%!v:lua.TabLine()"

function TabLine()
    local s = ""
    local current_tab = vim.api.nvim_get_current_tabpage()
    local tabs = vim.api.nvim_list_tabpages()

    for i, tab in ipairs(tabs) do
        local tab_number = i
        local wins = vim.api.nvim_tabpage_list_wins(tab)
        local bufname = ""

        -- Get filename of first window in tab
        if #wins > 0 then
            local buf = vim.api.nvim_win_get_buf(wins[1])
            bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t") -- filename only
        end

        -- Highlight current tab
        if tab == current_tab then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end

        -- Add tab number and filename
        s = s .. " " .. tab_number .. " " .. (bufname ~= "" and bufname or "[No Name]") .. " "
    end

    s = s .. "%#TabLineFill#"
    return s
end