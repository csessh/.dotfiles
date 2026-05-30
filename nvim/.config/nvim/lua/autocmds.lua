if vim.fn.executable "ibus" == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("ime_force_english", { clear = true }),
    desc = "Force ibus to English on leaving insert mode",
    callback = function()
      vim.system({ "ibus", "engine", "xkb:au::eng" }, { detach = true })
    end,
  })
end
