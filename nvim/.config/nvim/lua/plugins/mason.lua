return {
    {
        "williamboman/mason.nvim",
        config = true,
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
    {
        "LittleEndianRoot/mason-conform",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                "beautysh",
                "clang-format",
                "goimports",
                "isort",
                "ruff",
                "stylua",
            },
        },
    },
}
