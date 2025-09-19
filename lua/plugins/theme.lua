return {
	"folke/tokyonight.nvim",
	priority = 1000,
	opts = {
		transparent = true,
		style = "moon",
		on_highlights = function(hl, c)
			local util = require("tokyonight.util")
			hl.DiagnosticUnnecessary = {
				fg = c.comment,
			}
			hl.CursorLineNr = {
				fg = "#ffffff",
			}
			hl.LineNr = {
				fg = c.cyan,
				bg = c.bg_highlight,
				bold = true,
				blend = 0,
			}
			hl.LineNrAbove = {
				fg = util.darken(c.cyan, 0.8),
			}
			hl.LineNrBelow = {
				fg = util.darken(c.cyan, 0.8),
			}
		end,
	},
	config = function(_, opts)
		require("tokyonight").setup(opts)
		vim.cmd.colorscheme("tokyonight")
		vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {
			fg = "#5e6080", -- A muted color that matches tokyonight's style
		})

		vim.api.nvim_set_hl(0, "CursorLineNr", {
			fg = "#ffff00", -- Bright yellow for the current line number
		})
	end,
}
