return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup()
      vim.keymap.set({ "n", "v" }, "<leader>ca", function()
        require("tiny-code-action").code_action {}
      end, { noremap = true, silent = true })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,
    config = function()
      -- Get capabilities from cmp_nvim_lsp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local mason_bin = vim.fn.stdpath "data" .. "/mason/bin/"

      -- List of LSP servers with their configurations
      local servers = {
        bashls = {
          cmd = { mason_bin .. "bash-language-server", "start" },
          filetypes = { "sh", "bash" },
        },
        clangd = {
          cmd = { mason_bin .. "clangd" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        },
        docker_compose_language_service = {
          cmd = { mason_bin .. "docker-compose-langserver", "--stdio" },
          filetypes = { "yaml.docker-compose" },
        },
        dockerls = {
          cmd = { mason_bin .. "docker-langserver", "--stdio" },
          filetypes = { "dockerfile" },
        },
        markdown_oxide = {
          cmd = { mason_bin .. "markdown-oxide" },
          filetypes = { "markdown" },
        },
        pyright = {
          cmd = { mason_bin .. "pyright-langserver", "--stdio" },
          filetypes = { "python" },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
          before_init = function(_, config)
            local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.filereadable(venv_path) == 1 then
              config.settings.python.pythonPath = venv_path
            end
          end,
        },
        ruff = {
          cmd = { mason_bin .. "ruff", "server" },
          filetypes = { "python" },
        },
        taplo = {
          cmd = { mason_bin .. "taplo", "lsp", "stdio" },
          filetypes = { "toml" },
        },
        ts_ls = {
          cmd = { mason_bin .. "typescript-language-server", "--stdio" },
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        },
        lua_ls = {
          cmd = { mason_bin .. "lua-language-server" },
          filetypes = { "lua" },
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/love2d/library",
                },
                userThirdParty = { os.getenv "HOME" .. "/.local/share/LuaAddons" },
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- Configure and enable each server
      for name, config in pairs(servers) do
        -- Merge with shared capabilities and root markers
        config.capabilities = capabilities
        config.root_markers = { ".git" }

        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      -- Create LspInfo command as alias to checkhealth
      vim.api.nvim_create_user_command("LspInfo", function()
        vim.cmd "checkhealth vim.lsp"
      end, { desc = "Show LSP client information" })

      -- Setup keymaps on LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set(
            "n",
            "<leader>rn",
            vim.lsp.buf.rename,
            { buffer = ev.buf, noremap = true, desc = "LSP rename variable" }
          )

          vim.keymap.set("n", "<leader>fm", function()
            vim.lsp.buf.format { async = false }
          end, { buffer = ev.buf, noremap = true, desc = "LSP format current buffer" })
        end,
      })
    end,
  },
}
