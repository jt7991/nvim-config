-- Define the autocmd group

local organize_imports = function()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 500)
end

local function setupBuildSharedOnSave()
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "shared/*/*.ts",
		callback = function()
			-- run lerna build command
			vim.fn.jobstart("lerna run build --scope='@shared/*'", {
				on_exit = function()
					print("lerna build command run")
					-- restart lsp
					vim.cmd("LspRestart")
				end,
			})
		end,
	})
end

local function neoformatSetup()
	vim.api.nvim_create_user_command("OrganizeImports", organize_imports, {})
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.ts", "*.tsx", '*.lua', '*.js' },
		callback = function()
			organize_imports()
			vim.cmd("Neoformat")
		end,
	})
end

local function setup()
	setupBuildSharedOnSave()
	neoformatSetup()
end

return {
	setup = setup,
}
