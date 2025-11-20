return {
  "soulis-1256/eagle.nvim",
  keys = {
    {
      "g?",
      ":EagleWin<CR>",
      silent = true,
      noremap = true,
    },
  },
  opts = {
    show_headers = true,
    order = 1,
    improved_markdown = true,
    mouse_mode = false,
    keyboard_mode = true,
    logging = false,
    close_on_cmd = true,
    show_lsp_info = true,
    scrollbar_offset = 0,
    max_width_factor = 2,
    max_height_factor = 2.5,
    render_delay = 500,
    detect_idle_timer = 50,
    window_row = 1,
    window_col = 5,
    border = "rounded",
  },
}
