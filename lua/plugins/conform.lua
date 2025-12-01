-- Custom command to format selection as SQL
vim.api.nvim_create_user_command("FormatSQLSelection", function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line_0 = opts.line1 - 1 -- Convert 1-indexed to 0-indexed for API start
  local end_line_0 = opts.line2 -- API end is exclusive, so opts.line2 works as the exclusive end

  -- 1. Get the content of the selected range (0-indexed line range)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line_0, end_line_0, false)
  -- Join lines with newline, ensuring a trailing newline for robustness with CLI tools
  local content = table.concat(lines, "\n") .. "\n"

  -- 2. Create a unique temporary filename
  local temp_filename = vim.fn.tempname()

  print(temp_filename)
  local file = io.open(temp_filename, "w")
  if not file then
    vim.notify("Error: Could not open temporary file for writing.", vim.log.levels.ERROR)
    return
  end
  file:write(content)
  file:close()

  vim.defer_fn(function()
    vim.loop.fs_unlink(temp_filename, function() end)
  end, 0)

  local formatter_command =
    string.format("sql-formatter --language=postgresql --fix %s", vim.fn.shellescape(temp_filename))

  -- Run the command synchronously and capture output (or error message)
  local output = vim.fn.system(formatter_command)

  if vim.v.shell_error ~= 0 then
    vim.notify("Formatter failed: " .. output, vim.log.levels.ERROR)
    return
  end

  -- 5. Read the formatted content back from the file
  -- vim.fn.readfile returns a list of strings (lines)
  local formatted_content = vim.fn.readfile(temp_filename)

  -- 6. Replace the original range with the new content
  vim.api.nvim_buf_set_lines(bufnr, start_line_0, end_line_0, false, formatted_content)

  vim.notify("SQL Selection formatted successfully.", vim.log.levels.INFO)
end, { range = true })

-- Optional keymap for visual mode
vim.keymap.set("v", "<leader>fs", ":FormatSQLSelection<CR>", { desc = "Format selection as SQL" })

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
      typescript = { "biome-check", "prettier", stop_after_first = true },
      javascript = { "biome-check", "prettier", stop_after_first = true },
      typescriptreact = { "biome-check", "prettier", stop_after_first = true },
      svelte = { "prettier" },
      json = { "biome" },
      blade = { "blade-formatter" },
      sql = { "sql_formatter" },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
    },
    formatters = {
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      templ_fmt = {
        command = "templ",
        args = { "fmt" },
      },
      injected = {
        lang_to_ext = {
          sql = "sql",
        },
      },
    },
  },
}
