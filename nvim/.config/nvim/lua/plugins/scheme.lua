return {
	"eldritch-theme/eldritch.nvim",
	lazy = false,
	name = "eldritch",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("eldritch")
	end,
}
