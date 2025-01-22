-- Function to iterate through the quickfix list and prompt for changes
local function modify_console_interactively()
	local qflist = vim.fn.getqflist() -- Get the quickfix list
	for _, item in ipairs(qflist) do
		local bufnr = item.bufnr
		print("bufnr" .. bufnr)
		local lnum = item.lnum

		if not vim.api.nvim_buf_is_loaded(bufnr) then
			vim.fn.bufload(bufnr)
		end

		local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]

		if not vim.api.nvim_buf_is_valid(bufnr) or lnum > vim.api.nvim_buf_line_count(bufnr) then
			print("line not found in buffer")
		else
			-- Check if the line contains "console.log"
			if line:match("console%.log") then
				-- Open the buffer and jump to the line
				vim.api.nvim_command("buffer " .. bufnr)
				print("bufnr" .. bufnr)
				vim.api.nvim_win_set_cursor(0, { lnum, 0 })

				vim.api.nvim_buf_add_highlight(bufnr, -1, "Visual", lnum - 1, 0, -1)
				vim.cmd("redraw")
				-- Show the user the current line and ask for input
				print("Replace 'console.log' with:")
				print("[i] console.info | [e] console.error | [d] delete | [s] skip")

				-- Wait for user input
				local choice = vim.fn.getcharstr()

				if choice == "i" then
					-- Replace with console.info
					local new_line = line:gsub("console%.log", "console.info")
					vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
					print("Replaced with console.info")
				elseif choice == "e" then
					-- Replace with console.error
					local new_line = line:gsub("console%.log", "console.error")
					vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, { new_line })
					print("Replaced with console.error")
				elseif choice == "d" then
					-- Delete line
					vim.api.nvim_buf_set_lines(bufnr, lnum - 1, lnum, false, {})
					print("Line deleted")
				elseif choice == "s" then
					-- Skip the current line
					print("Skipped")
				else
					-- Invalid input; skip by default
					print("Invalid input. Skipped.")
				end
				vim.cmd("redraw")
				vim.api.nvim_buf_clear_namespace(bufnr, -1, lnum - 1, lnum)
			end
		end
	end

	print("Finished processing quickfix list.")
end

-- Command to start the interactive replacement process
vim.api.nvim_create_user_command("FixConsoleInteractive", modify_console_interactively, {})
