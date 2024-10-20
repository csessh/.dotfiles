return {
    "ptdewey/pendulum-nvim",
    opts = {
        log_file = vim.fn.expand "/var/tmp/pendulum/report.csv",
        timeout_len = 300,
        timer_len = 60,
        gen_reports = true,
        top_n = 5,
        report_excludes = {
            filetype = {
                "neo-*",
                "TelescopePrompt",
                "qf",
            },
            branch = {
                "unknow-branch",
            },
            directory = {},
            project = {
                "unknown_project",
            },
            file = {
                "filesystem",
            },
        },
        report_section_excludes = {
            "branch",
        },
    },
}
