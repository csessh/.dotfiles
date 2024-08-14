return {
    {
        "zaldih/themery.nvim",
        opts = {
            livePreview = true,
            themes = { "eldritch", "everforest", "dracula", "nordic", "cyberdream" },
        },
    },
    {
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        name = "eldritch",
    },
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        name = "dracula",
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "AlexvZyl/nordic.nvim",
        lazy = false,
        name = "nordic",
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        name = "cyberdrem",
        priority = 1000, -- make sure to load this before all the other start plugins
    },
    {
        "neanias/everforest-nvim",
        version = false,
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("everforest").load()
        end,
    },
}
