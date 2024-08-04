return {
    {
        "zaldih/themery.nvim",
        opts = {
            livePreview = true,
            themes = { "eldritch", "dracula", "nordic" },
        },
    },
    {
        "eldritch-theme/eldritch.nvim",
        lazy = false,
        name = "eldritch",
        config = function()
            require 'eldritch'.load()
        end
    },
    {
        "Mofiqul/dracula.nvim",
        lazy = false,
        name = "dracula",
    },
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        name = "nordic",
    }
}
