return {
	setup = function()
		vim.api.nvim_create_user_command("Lint", "cexpr system('biome check --max-diagnostics=1000')", {})
	end,
}
