return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
		cmdline = {
			view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
		},
		presets = {
			bottom_search = true,
			command_palette = false,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = true,
		},
	},
}
