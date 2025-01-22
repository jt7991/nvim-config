-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
	clangd = {},
	gopls = {
		filetypes = { "go", "gomod" },
	},
	html = {
		filetypes = { "html", "templ", "eta" },
	},
	htmx = {
		filetypes = { "html", "templ", "eta" },
	},
	tailwindcss = {
		filetypes = {
			"html",
			"htmx",
			"css",
			"eta",
			"scss",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"templ",
		},
		init_options = {
			userLanguages = {
				templ = "html",
			},
		},
	},

	pyright = {},
	rust_analyzer = {},
	tsserver = {
		single_file_support = false,
	},
	svelte = { "svelte" },
	-- html = { filetypes = { 'html', 'twig', 'hbs'} },

	lua_ls = {
		Lua = {
			library = {
				"${3rd}/luv/library",
				unpack(vim.api.nvim_get_runtime_file("", true)),
			},
			workspace = { checkThirdParty = false },
			diagnostics = { globals = { "vim", "use", "packer_plugins" } },
			telemetry = { enable = false },
		},
	},
	denols = {},
}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", tag = "legacy", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},
	config = function()
		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = vim.tbl_keys(servers),
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()
		mason_lspconfig.setup_handlers({
			function(server_name)
				local config = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
					commands = (servers[server_name] or {}).commands,
					single_file_support = (servers[server_name] or {}).single_file_support,
				}
				if server_name == "tsserver" then
					config.root_dir = function(fname)
						local util = require("lspconfig").util
						return util.root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git")(fname)
					end
				end

				if server_name == "denols" then
					config.root_dir = function(fname)
						local util = require("lspconfig").util
						return util.root_pattern("deno.json", "deno.jsonc")(fname)
					end
				end
				require("lspconfig")[server_name].setup(config)
			end,
		})
		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
		vim.keymap.set("n", "<leader>ca", "<cmd>:lua vim.lsp.buf.code_action()<CR>")
	end,
}
