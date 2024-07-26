return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = "powerline_dark",
			globalstatus = false,
			always_divide_middle = true,
			disabled_filetypes = {
				statusline = { "neo-tree" },
				winbar = { "neo-tree" },
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "filename" },
			lualine_c = { "diagnostics" },
			lualine_x = { "filesize", "encoding", "filetype" },
			lualine_y = { 'os.date("!%d-%m %H:%M")' }, -- UTC
			lualine_z = { 'os.date("%d-%m %H:%M")' }, -- Local time
		},
	},
}
