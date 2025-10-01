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
        config = function(_, opts)
            require("mason").setup(opts)

            -- Auto-install LSP servers
            local ensure_installed = {
                "bash-language-server",
                "clangd",
                "docker-compose-language-service",
                "dockerfile-language-server",
                "lua-language-server",
                "markdown-oxide",
                "pyright",
                "ruff",
                "taplo",
                "typescript-language-server",
            }

            local registry = require "mason-registry"
            for _, name in ipairs(ensure_installed) do
                local package = registry.get_package(name)
                if not package:is_installed() then
                    package:install()
                end
            end
        end,
    },
    {
        "rshkarin/mason-nvim-lint",
        commit = "910dadb99cb2bf0d5176026c7a4ab1861c4e561f",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "cpplint",
                "jsonlint",
                "ruff",
                "selene",
                "shellcheck",
                "yamllint",
                "eslint_d",
            },
        },
    },
}
