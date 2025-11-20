return {
    "Wansmer/symbol-usage.nvim",
    event = "BufReadPre",
    config = function()
        require("symbol-usage").setup {
            text_format = function(symbol)
                local usage = symbol.references <= 1 and "reference" or "references"
                return ("%s %s"):format(symbol.references, usage)
            end,
        }
    end,
}
