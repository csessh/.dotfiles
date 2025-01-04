return {
    {
        "zaldih/themery.nvim",
        opts = {
            livePreview = true,
            themes = {
                "eldritch",
                "cyberdream",
            },
        },
    },
    {
        "eldritch-theme/eldritch.nvim",
        lazy = true,
        priority = 1000,
        config = function()
            -- https://github.com/ggandor/leap.nvim/issues/250
            vim.cmd "hi def link LeapLabel IncSearch"
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            italic_comments = true,
            borderless_telescope = true,
            cache = true,
            terminal_colors = true,
        },
    },
}
