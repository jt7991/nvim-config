local organize_imports = function()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf_request_sync(0, "workspace/executeCommand", params, 500)
end

return { -- Autoformat
  "stevearc/conform.nvim",
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local jsFiletypes = { "javascript", "typescript", "typescriptreact" }
      if vim.tbl_contains(jsFiletypes, vim.api.nvim_buf_get_option(bufnr, "filetype")) then
        organize_imports()
      end
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports" },
      templ = { "templ_fmt" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
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
