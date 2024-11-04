return {
    "karb94/neoscroll.nvim",
    opts = {
        mappings = {
            "<C-u>",
            "<C-d>",
            "<C-b>",
            "<C-f>",
            "<C-y>",
            "<C-e>",
            "zt",
            "zz",
            "zb",
        },
        hide_cursor = false,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = false,
        easing = "linear",
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
        ignored_events = {
            "WinScrolled",
            "CursorMoved",
        },
    },
}
