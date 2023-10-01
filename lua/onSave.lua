-- Define the autocmd group

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
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
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
