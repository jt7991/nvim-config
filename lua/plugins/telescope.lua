return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-lua/plenary.nvim",
		"kiyoon/telescope-insert-path.nvim",
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-live-grep-args.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("telescope").setup({
			extensions = {
				file_browser = {
					hijack_netrw = false,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
			defaults = {
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-d>"] = false,
					},
					n = {
						["<C-p>"] = require("telescope_insert_path").insert_reltobufpath_insert,
					},
				},
			},
		})
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "live_grep_args")
		pcall(require("telescope").load_extension, "ui-select")

		require("telescope").load_extension("file_browser")
		vim.keymap.set(
			"n",
			"<leader>?",
			require("telescope.builtin").oldfiles,
			{ desc = "[?] Find recently opened files" }
		)
		vim.keymap.set(
			"n",
			"<leader><space>",
			require("telescope.builtin").buffers,
			{ desc = "[ ] Find existing buffers" }
		)
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })
		vim.keymap.set("n", "<leader>ff", function()
			require("telescope.builtin").find_files({ hidden = true, respect_gitignore = true })
		end, { desc = "[F]ind [F]iles" })
		vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
		vim.keymap.set(
			{ "n", "v" },
			"<leader>fw",
			require("telescope.builtin").grep_string,
			{ desc = "[F]ind current [W]ord" }
		)
		vim.keymap.set(
			"n",
			"<leader>fg",
			require("telescope").extensions.live_grep_args.live_grep_args,
			{ desc = "[F]ind by [G]rep" }
		)

		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").pickers, { desc = "[F]ind [R]esume" })

		vim.keymap.set("n", "<leader>fq", require("telescope.builtin").quickfixhistory, { desc = "[F]ind [Q]uickfix" })

		vim.keymap.set("n", "<leader>fm", function()
			require("telescope.builtin").live_grep({ additional_args = { "-U" } })
		end, { desc = "[F]ind by [M]ultiline grep" })

		vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })

		vim.keymap.set(
			"n",
			"<leader>fs",
			require("telescope.builtin").lsp_dynamic_workspace_symbols,
			{ desc = "[F]ind [S]ymbols" }
		)

		vim.keymap.set("n", "<leader>gb", require("telescope.builtin").git_branches, { desc = "[G]it [B]ranches" })
		vim.keymap.set("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "[G]it [S]tatus" })
	end,
}
