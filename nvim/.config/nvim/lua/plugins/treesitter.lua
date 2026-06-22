return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {}

      local ensure_installed = {
        "bash", "c", "cpp", "css", "diff", "dockerfile",
        "gitcommit", "git_config", "gitignore", "go", "html", "ini",
        "java", "javascript", "json", "jsonc", "lua",
        "markdown", "markdown_inline", "nix", "python", "query", "regex",
        "ruby", "rust", "sql", "terraform", "toml",
        "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
      }
      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = args.match
          local lang = vim.treesitter.language.get_lang(ft) or ft
          local installed = require("nvim-treesitter.config").get_installed("parsers")
          if not vim.tbl_contains(installed, lang) then
            pcall(require("nvim-treesitter").install, { lang })
          end
          pcall(vim.treesitter.start, args.buf, lang)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local select_keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      }
      for key, query in pairs(select_keymaps) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(query, "textobjects")
        end)
      end

      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]i", function() move.goto_next("@conditional.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]l", function() move.goto_next("@loop.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next("@fold", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[i", function() move.goto_previous("@conditional.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[l", function() move.goto_previous("@loop.outer", "textobjects") end)
      vim.keymap.set({ "n", "x", "o" }, "[z", function() move.goto_previous("@fold", "textobjects") end)
    end,
  },
}
