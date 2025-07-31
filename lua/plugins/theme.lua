return {
	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {
		transparent = false,
		style = "moon",
		on_highlights = function(hl, c)
			hl.DiagnosticUnnecessary = {
				fg = c.comment,
			}
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
	end,
}
