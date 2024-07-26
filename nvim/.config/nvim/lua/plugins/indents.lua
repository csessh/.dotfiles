return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = { char = "▏" },
		scope = {
			char = ":",
			show_end = false,
		},
		exclude = {
			filetypes = { "help", "git", "checkhealth", "markdown", "snippets", "gitconfig" },
			buftypes = { "terminal", "nofile", "prompt", "quickfix" },
		},
	},
}
