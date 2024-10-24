return {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cond = vim.fn.getcwd() == vim.fn.expand("~/Documents/Obsidian/Personal"),
    opts = {
        workspaces = {
            {
                name = "Personal",
                path = "~/Documents/Obsidian/Personal",
            },
        },
        notes_subdir = "Zettelkasten/Fleeting notes",
        new_notes_location = "notes_subdir",
        daily_notes = {
            folder = "Daily",
            default_tags = { "daily" },
            template = "Daily.md",
            date_format = "%Y-%m-%d",
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        templates = {
            folder = "Templates",
            date_format = "%d-%b-%Y",
            time_format = "%H:%M",
        },
        mappings = {
            ["gf"] = {
                action = function()
                    return require("obsidian").util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true },
            },
            ["<leader>x"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
        },
        attachments = {
            img_folder = "Files",
        },
        picker = {
            name = "telescope.nvim",
            note_mappings = {
                new = "<C-x>",
                insert_link = "<C-l>",
            },
            tag_mappings = {
                tag_note = "<C-x>",
                insert_tag = "<C-l>",
            },
        },
        ui = {
            enable = true,
            checkboxes = {
                [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                ["x"] = { char = "✔", hl_group = "ObsidianDone" },
            },
        },
        follow_img_func = function(img)
            vim.fn.jobstart({ "xdg-open", img })
        end,
        follow_url_func = function(url)
            vim.ui.open(url)
        end,
        note_id_func = function(title)
            local suffix = ""
            for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
            end
            return tostring(os.time()) .. "-" .. suffix
        end,
    },
}
