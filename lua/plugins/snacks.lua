return {
	"folke/snacks.nvim",
	vim.keymap.set("n", "<leader>lg", function()
		require("snacks").lazygit()
	end),
}
