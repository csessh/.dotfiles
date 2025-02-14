return {
    "kdheepak/lazygit.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit" },
    keys = {
        { "\\g", "<cmd>LazyGit<cr>", desc = "Open floating LazyGit" }
    },
    config = function()
        vim.g.lazygit_floating_window_scaling_factor = 0.85
        vim.g.lazygit_floating_window_use_plenary = 1
    end
}
