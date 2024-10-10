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
        lazy = false,
        priority = 1000,
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
    },
}
