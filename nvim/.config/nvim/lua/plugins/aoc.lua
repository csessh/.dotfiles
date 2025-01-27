return {
    "csessh/aoc.nvim",
    cond = string.find(vim.fn.getcwd(), vim.fn.expand "~/Documents/AoC/"),
    opts = {
        session_filepath = "/var/tmp/aoc/session.txt",
        puzzle_input = {
            filename = "puzzle.txt",
            save_to_current_dir = true,
        },
    },
}
