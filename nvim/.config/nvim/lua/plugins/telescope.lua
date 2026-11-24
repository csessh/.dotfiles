return {
  { "nvim-telescope/telescope-ui-select.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ff",
        function() require("telescope.builtin").find_files() end,
        desc = "Telescope find files",
      },
      {
        "<leader>gr",
        function() require("telescope.builtin").live_grep() end,
        desc = "Telescope live grep",
      },
      {
        "<leader>gw",
        function() require("telescope.builtin").grep_string() end,
        desc = "Telescope grep string under cursor",
      },
      {
        "<leader>bf",
        function() require("telescope.builtin").buffers() end,
        desc = "Telescope show available buffers",
      },
    },
    config = function()
      local telescope = require "telescope"
      telescope.setup {
        defaults = {
          path_display = { "smart" },
          layout_strategy = "bottom_pane",
          initial_mode = "insert",
          file_ignore_patterns = {
            "^.git/*",
            ".DS_Store",
            ".venv",
            ".ruff_cache",
            "__pycache__",
          },
        },
        pickers = {
          find_files = { hidden = true, no_ignore = true },
          live_grep = {
            additional_args = { "--hidden" },
          },
          grep_string = {
            initial_mode = "normal",
            additional_args = { "--hidden" },
          },
          buffers = {
            initial_mode = "normal",
            cwd_only = true,
            sort_lastused = true,
          },
        },
      }

      telescope.load_extension "ui-select"
    end,
  },
}
