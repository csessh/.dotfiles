return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = { char = "▏" },
		scope = {
			char = "\\",
			show_end = false,
		},
		exclude = {
			filetypes = { "help", "git", "dashboard", "checkhealth", "snippets" },
			buftypes = { "terminal", "nofile", "prompt", "quickfix" },
		},
	},
}
