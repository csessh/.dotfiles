---Generate a random emoticons from a pre-defined list.
---Used to populate tabname when a tab doesn't have a name.
---@return string
local get_random_tabname = function()
    local emoticons = {
        "¯\\_(ツ)_/¯",
        "(⌐⊙_⊙)",
        "(҂◡_◡)",
        "(❍ᴥ❍ʋ)",
        "ᕕ(⌐■_■)ᕗ ♪♬",
        "x⸑x",
        "ヽ( •_)ᕗ",
    }

    return emoticons[math.random(#emoticons)]
end

return {
    "crispgm/nvim-tabline",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        show_index = true,
        show_modify = true,
        show_icon = true,
        modify_indicator = "[+]",
        no_name = get_random_tabname(),
        brackets = { "", "" },
        inactive_tab_max_length = 0,
    },
}
