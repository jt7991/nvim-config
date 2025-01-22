return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
		},
	},
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	vim.keymap.set("n", "<leader>fb", "<CMD>Oil --float<CR>", { desc = "Open parent directory" }),
}
