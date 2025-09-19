return {
	"dmmulroy/tsc.nvim",
	config = function()
		require("tsc").setup({
			run_as_monorepo = false,
			use_diagnostics = false,
			flags = "--noEmit --emitDeclarationOnly false",
		})
	end,
}
