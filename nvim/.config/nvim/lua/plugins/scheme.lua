return {
    {
        "zaldih/themery.nvim",
        opts = {
            livePreview = true,
            themes = {
                "eldritch",
                "cyberdream",
                "nightfox",
            },
        },
    },
    {
        "eldritch-theme/eldritch.nvim",
        lazy = true,
        priority = 1000,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = true,
        priority = 1000,
        opts = {
            italic_comments = true,
            borderless_telescope = false,
            cache = true,
        },
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
        priority = 1000,
    },
}
