local function runQuickLint()
  local git_output = vim.api.nvim_exec("!git status --porcelain=1", true)
  local files = vim.split(git_output, "\n")
  local files_to_lint = {}
  for _, file in ipairs(files) do
    local _, file_path = file:match("^%s*([MA])%s+(.+)$")
    if file_path ~= nil then
      table.insert(files_to_lint, file_path)
    end
  end

  local file_paths = table.concat(files_to_lint, " ")

  local lint_output = vim.api.nvim_exec("!npx eslint " .. file_paths .. " --format unix", true)
  local lines = vim.split(lint_output, "\n")
  local errors = {}
  for _, line in ipairs(lines) do
    local parts = vim.split(line, ":")
    print(vim.inspect(parts))
    if #parts > 1 and line:match("%[Error") then
      local file = parts[1]
      local line_number = parts[2]
      local col = parts[3]
      table.insert(errors, {
        text = parts[4],
        filename = file,
        lnum = line_number,
        col = col,
      })
    end
  end
  vim.fn.setqflist(errors, "r")
  vim.api.nvim_exec("copen", true)
end

return {
  runQuickLint = runQuickLint,
}
