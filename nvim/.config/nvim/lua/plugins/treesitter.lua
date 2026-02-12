return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {
        auto_install = true,
      }
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local ts_select = require("nvim-treesitter-textobjects.select")
      local ts_move = require("nvim-treesitter-textobjects.move")

      require("nvim-treesitter-textobjects").setup {
        select = { lookahead = true },
        move = { set_jumps = true },
      }

      -- Select keymaps
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
          ts_select.select_textobject(query)
        end)
      end

      -- Move keymaps
      vim.keymap.set({ "n", "x", "o" }, "]f", function() ts_move.goto_next_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() ts_move.goto_next_start("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]F", function() ts_move.goto_next_end("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]C", function() ts_move.goto_next_end("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() ts_move.goto_previous_start("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function() ts_move.goto_previous_start("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[F", function() ts_move.goto_previous_end("@function.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function() ts_move.goto_previous_end("@class.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]i", function() ts_move.goto_next("@conditional.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]l", function() ts_move.goto_next("@loop.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function() ts_move.goto_next("@fold") end)
      vim.keymap.set({ "n", "x", "o" }, "[i", function() ts_move.goto_previous("@conditional.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[l", function() ts_move.goto_previous("@loop.outer") end)
      vim.keymap.set({ "n", "x", "o" }, "[z", function() ts_move.goto_previous("@fold") end)
    end,
  },
}
