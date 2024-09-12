return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("hlchunk").setup {
            chunk = {
                enable = true,
                style = "#806d9c",
            },
            line_num = {
                enable = true,
                style = "#806d9c",
                use_treesitter = false,
            },
        }
    end,
}
