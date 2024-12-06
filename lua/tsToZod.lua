local function getVisualSelection(startLine, endLine)
  local lines = vim.fn.getline(startLine, endLine)
  local lines_str = table.concat(lines, "\n")
  return { lines_str, startLine, endLine }
end

local function convert_selected_to_zod(opts)
  print(vim.inspect(opts))
  local start_line = opts.line1
  local end_line = opts.line2
  local selection = getVisualSelection(start_line, end_line)
  -- write to temp file
  local temp_file = vim.fn.tempname() .. ".ts"
  local zod_temp_file = vim.fn.tempname() .. ".ts"
  local file = io.open(temp_file, "w")
  file:write(selection[1])
  file:close()
  local zod = vim.fn.system(string.format("npx ts-to-zod %q %q", "../../.." .. temp_file, "../../.." .. zod_temp_file))
  print(zod)
  local zodFile = io.open(zod_temp_file, "r")
  zod = zodFile:read("*a")

  local zod_lines = {}
  for line in zod:gmatch("([^\n]*)\n?") do
    table.insert(zod_lines, line)
  end

  vim.api.nvim_buf_set_lines(0, selection[2] - 1, selection[3], false, zod_lines)
end

return {
  convert_selected_to_zod = convert_selected_to_zod,
}
