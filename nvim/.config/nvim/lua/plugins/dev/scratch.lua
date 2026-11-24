return {
  "reybits/scratch.nvim",
  lazy = true,
  keys = {
    { "<leader>ts", "<cmd>ScratchToggle<cr>", desc = "Toggle Scratch Buffer" },
    { "<leader>ti", "<cmd>ScratchIssues<cr>", desc = "Toggle Scratch Issues" },
    { "<leader>tt", "<cmd>ScratchTask<cr>", desc = "New Scratch Task" },
  },
  cmd = {
    "ScratchToggle",
    "ScratchIssues",
    "ScratchTask",
  },
  opts = {
    title = "Scratch",
    border = "rounded",
    width = 0.7,
    height = 0.8,

    -- enable per-project notes
    local_notes = false,

    -- enable global notes
    global_notes = true,

    -- per-project directory holding the note and the issues
    -- local_dir = ".scratch",

    -- close the window when the focus leaves it
    close_on_leave = true,

    -- window-local options (vim.wo)
    win_opts = {
      wrap = true,
      linebreak = true,
      cursorline = true,
    },
  },
}
