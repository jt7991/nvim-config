return {
	-- Set lualine as statusline
	"nvim-lualine/lualine.nvim",
	-- See `:help lualine.txt`
	opts = {
		options = {
			icons_enabled = true,
			theme = "onedark",
			component_separators = "|",
			section_separators = "",
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
