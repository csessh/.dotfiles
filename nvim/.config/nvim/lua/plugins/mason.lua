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
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "bashls",
                "clangd",
                "docker_compose_language_service",
                "dockerls",
                "gopls",
                "lua_ls",
                "markdown_oxide",
                "pyright",
                "ruff",
                "taplo",
            },
        },
    },
    {
        "rshkarin/mason-nvim-lint",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "cpplint",
                "golangci-lint",
                "jsonlint",
                "ruff",
                "selene",
                "shellcheck",
                "yamllint",
            },
        },
    },
}
