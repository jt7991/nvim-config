local M = {}

local function generate_test_file(file_path)
  local test_filename = file_path:gsub(".ts$", ".test.ts")
  local test_filepath = test_filename:gsub("/server/functions/(.+)", "/server/functions/test/%1")

  -- Create a new buffer for the test file
  local test_buffer = vim.fn.bufadd(test_filepath)

  local test_file_exists = vim.fn.filereadable(test_filepath) == 1
  if not test_file_exists then
    -- create folder if it doesn't exists
    local test_folder = test_filepath:gsub("/[^/]+$", "")
    vim.fn.mkdir(test_folder, "p")
    -- Write the Jest test template to the test buffer
    vim.api.nvim_buf_set_lines(test_buffer, 0, -1, false, {
      "describe('" .. test_filename .. "', () => {",
      "    it('should have some test cases', () => {",
      "        // Your test code here",
      "    });",
      "});",
    })
  end

  vim.cmd("e " .. test_filepath) -- Open the test file in a new buffer
end

local function go_to_tested_file(file_path)
  local tested_filename =
      file_path:gsub("/server/functions/test/(.+)", "/server/functions/%1"):gsub(".test.ts$", ".ts")

  vim.cmd("e " .. tested_filename)
end

function M.test_ease()
  local current_filename = vim.fn.expand("%:p")
  if current_filename:find("server") == nil then
    print("Not a server file")
    return
  end

  if current_filename:find("/test/") then
    return go_to_tested_file(current_filename)
  end
  generate_test_file(current_filename)
end

return M
