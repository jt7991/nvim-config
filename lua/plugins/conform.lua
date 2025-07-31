return { -- Autoformat
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			return {
				timeout_ms = 1000,
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			go = { "gofmt", "goimports" },
			templ = { "templ_fmt" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			typescriptreact = { "prettier" },
			svelte = { "prettier" },
			json = { "prettier" },
			blade = { "blade-formatter" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
		},
		formatters = {
			templ_fmt = {
				command = "templ",
				args = { "fmt" },
			},
		},
	},
}
