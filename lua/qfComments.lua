local get_comments_for_current_pr = function()
  local pr_number = vim.fn.input("PR number: ")
  local comments = vim.fn.systemlist("gh pr view " .. pr_number .. " --json comments")
  local comments_json = table.concat(comments, "")
  local comments_table = vim.fn.json_decode(comments_json)
  local comments_for_current_pr = {}
  for _, comment in ipairs(comments_table) do
    if comment.path == vim.fn.expand("%") then
      table.insert(comments_for_current_pr, comment)
    end
  end
  return comments_for_current_pr
end
