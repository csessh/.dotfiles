return {
    "folke/drop.nvim",
    opts = {
        theme = "auto",
        themes = {
            { theme = "arcade", month = 1, day = 19 },
            { theme = "valentines_day", month = 2, day = 5 },
            { theme = "emotional", month = 3, day = 11 },

            { theme = "new_year", month = 1, day = 1 },
            { theme = "valentines_day", month = 2, day = 14 },
            { theme = "easter", holiday = "easter" },
            { theme = "april_fools", month = 4, day = 1 },
            { theme = "halloween", month = 10, day = 31 },
            { theme = "xmas", from = { month = 12, day = 24 }, to = { month = 12, day = 25 } },

            { theme = "matrix", from = { month = 1, day = 1 }, to = { month = 12, day = 31 } },
        },
        max = 50,
        interval = 100,
        filetypes = { "dashboard", "alpha", "ministarter" },
        winblend = 100,
        screensaver = 1000 * 60 * 5,
    },
}
