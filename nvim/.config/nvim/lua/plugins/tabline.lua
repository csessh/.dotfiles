local random_faces = function()
    local funny_faces = {
        "(⌐⊙_⊙)",
        "(҂◡_◡)",
        "(❍ᴥ❍ʋ)",
        "ᕕ(⌐■_■)ᕗ ♪♬",
        "ヽ( •_)ᕗ",
        "x⸑x",
    }
    local idx = math.random(0, #funny_faces - 1)
    return funny_faces[idx]
end

return {
    "crispgm/nvim-tabline",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    opts = {
        show_index = true,
        show_modify = true,
        show_icon = true,
        modify_indicator = "[+]",
        no_name = random_faces(),
        brackets = { "", "" },
        inactive_tab_max_length = 0,
    },
}
