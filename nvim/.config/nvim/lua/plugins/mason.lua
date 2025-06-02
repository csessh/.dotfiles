return {
    {
        "williamboman/mason.nvim",
        opts = {
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
            registries = { "github:mason-org/mason-registry" },
            providers = {
                "mason.providers.registry-api",
                "mason.providers.client",
            },
            ui = { check_outdated_packages_on_open = true },
        },
    },
}
