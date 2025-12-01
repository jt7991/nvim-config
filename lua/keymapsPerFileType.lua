local setBufferKeymap = function(mode, keys, func, desc)
	vim.api.nvim_buf_set_keymap(0, mode, keys, func, {
		noremap = true,
		desc = desc,
	})
end

local keymaps_per_language = {
	{
		languages = { "typescript", "typescriptreact" },
		setupKeymaps = function()
			setBufferKeymap(
				"n",
				"<leader>cl",
				[[yiwo<C-r>=printf("console.log('%s',%s)",@", @")<CR><Esc>]],
				"Add log statement for variable under cursor"
			)
			setBufferKeymap(
				"v",
				"<leader>cl",
				[[yo<C-r>=printf("console.log('%s',%s)",@", @")<CR><Esc>]],
				"Add log statement for selected text"
			)
		end,
	},
}

return {
	setup = function()
		for index, item in ipairs(keymaps_per_language) do
			vim.api.nvim_create_autocmd("FileType", {
				pattern = item.languages,
				callback = item.setupKeymaps,
			})
		end
	end,
}
