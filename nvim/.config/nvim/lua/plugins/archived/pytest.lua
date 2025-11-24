return {
  "richardhapb/pytest.nvim",
  enabled = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    open_output_onfail = false,
    keymaps_callback = function(bufnr)
      vim.keymap.set("n", "<leader>pt", "<CMD>Pytest<CR>", { buffer = bufnr, desc = "Run Pytest" })
      vim.keymap.set("n", "<leader>pta", "<CMD>PytestAttach<CR>", { buffer = bufnr, desc = "Attach Pytest to buffer" })
      vim.keymap.set("n", "<leader>ptd", "<CMD>PytestDetach<CR>", { buffer = bufnr, desc = "Detach Pytest" })
    end,
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "python", "xml" },
    }

    require("pytest").setup(opts)
  end,
}
