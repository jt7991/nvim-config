local function open_lazygit_in_kitty()
	-- Get the current working directory of Neovim
	local cwd = vim.fn.getcwd()

	-- The command to run: kitty, set the directory, then run lazygit,
	-- and put it in the background (&) so Neovim is not blocked.
	local command = string.format("kitty --single-instance --directory %s lazygit &", vim.fn.shellescape(cwd))

	-- Execute the command asynchronously
	-- NOTE: vim.fn.system() is often sufficient for a fire-and-forget background process,
	-- but vim.loop.spawn (used by vim.fn.jobstart) is generally the preferred modern way.
	vim.fn.jobstart(command, { detach = true })
end

return {
	open_lazygit_in_kitty = open_lazygit_in_kitty,
}
