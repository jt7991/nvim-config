return {
	branch = "canary",
	"CopilotC-Nvim/CopilotChat.nvim",
	opts = function()
		local user = vim.env.USER or "User"
		user = user:sub(1, 1):upper() .. user:sub(2)
		return {
			model = "gpt-4",
			auto_insert_mode = true,
			show_help = true,
			question_header = "  " .. user .. " ",
			answer_header = "  Copilot ",
			window = {
				width = 0.4,
			},
			mappings = {
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<C-l>",
				},
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				reset = {
					normal = "<leader>r",
					insert = "<C-x>",
				},
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				yank_diff = {
					normal = "gy",
					register = '"',
				},
				show_diff = {
					normal = "gd",
				},
				show_system_prompt = {
					normal = "gp",
				},
				show_user_selection = {
					normal = "gs",
				},
			},
			selection = function(source)
				local select = require("CopilotChat.select")
				return select.visual(source) or select.buffer(source)
			end,
		}
	end,
	config = function(_, opts)
		local chat = require("CopilotChat")

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-chat",
			callback = function()
				vim.opt_local.relativenumber = false
			end,
		})

		chat.setup(opts)
	end,

	vim.keymap.set({ "n", "v" }, "<leader>aa", function()
		require("CopilotChat").toggle()
	end, { desc = "CopilotChat toggle" }),

	vim.keymap.set({ "n", "v" }, "<leader>ax", function()
		require("CopilotChat").reset()
	end, { desc = "CopilotChat clear" }),

	vim.keymap.set({ "n", "v" }, "<leader>aq", function()
		local input = vim.fn.input("Quick Chat: ")
		if input ~= "" then
			require("CopilotChat").ask(input)
		end
	end, {
		desc = "Quick Chat (CopilotChat)",
	}),
}
