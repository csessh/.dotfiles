return {
    "epwalsh/obsidian.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cond = vim.fn.getcwd() == vim.fn.expand("~/Documents/Obsidian/Personal"),
    config = function()
        require("obsidian").setup {
            workspaces = {
                {
                    name = "Personal",
                    path = "~/Documents/Obsidian/Personal",
                },
            },
            notes_subdir = "Zettelkasten/Inbox",
            new_notes_location = "notes_subdir",
            daily_notes = {
                folder = "Daily",
                default_tags = { "daily" },
                template = "Daily template.md",
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
                },
                tag_mappings = {
                    tag_note = "<C-x>",
                },
            },
            ui = {
                enable = false,
                checkboxes = {
                    [" "] = { char = "☐", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "✔", hl_group = "ObsidianDone" },
                },
            },
        }

        -- Create new notes
        vim.keymap.set("n", "<leader>ob", ":ObsidianOpen<CR>", { desc = "Open Obsidian app" })
        vim.keymap.set("n", "<leader>obn", ":ObsidianNew<CR>", { desc = "Create new Obsidian note" })
        vim.keymap.set("n", "<leader>obN", ":ObsidianNewFromTemplate<CR>",
            { desc = "Create new Obsidian note from template" })
        vim.keymap.set("n", "<leader>obT", ":ObsidianTemplate<CR>", { desc = "Insert a template to a note" })
        vim.keymap.set("n", "<leader>obt", ":ObsidianTags<CR>", { desc = "Lookup tags" })
        vim.keymap.set("n", "<leader>obd", ":ObsidianToday<CR>", { desc = "Open today's daily note" })
        vim.keymap.set("n", "<leader>obs", ":ObsidianSearch<CR>", { desc = "Search Obsidian notes" })
        vim.keymap.set("n", "<leader>obl", ":ObsidianTOC<CR>", { desc = "Show current notes' TOC" })
        vim.keymap.set("n", "<leader>obrn", ":ObsidianRename<CR>", { desc = "Rename current file across vault" })
    end
}
