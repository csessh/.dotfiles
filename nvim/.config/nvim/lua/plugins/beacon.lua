return {
    "csessh/beacon.nvim",
    opts = {
        enabled = true,
        speed = 2,
        width = 50,
        winblend = 70,
        fps = 60,
        min_jump = 20,
        cursor_events = {},
        window_events = { "WinEnter", "FocusGained" },
        highlight = { bg = "green", ctermbg = 15 },
    },
}
