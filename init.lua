vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.tabstop = 2
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.spelllang = "en_us"
vim.opt.spell = true
-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-abolish",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  -- "github/copilot.vim",
  "sbdchd/neoformat",
  "mbbill/undotree",
  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },
  { "folke/neodev.nvim",    opts = {} },
  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
  },

  { "numToStr/Comment.nvim", opts = {} },

  { import = "plugins" },

  {},
})
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Relative line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`

-- Copilot settings
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

-- vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "U", "<cmd>UndotreeToggle<CR>")

vim.api.nvim_create_user_command("QfLint", require("quickLint").addLintOutputToQf, {})
vim.api.nvim_create_user_command("QfTypes", require("quickLint").addTypeCheckOutputToQuickfixList, {})
vim.api.nvim_create_user_command("QfComments", require("qfComments").add_pr_comments_to_qf, {})
vim.api.nvim_create_user_command("QfAll", require("quickLint").addTypescriptDiagnosticsToQuickfix, {})
vim.api.nvim_create_user_command("TsToZod", require("tsToZod").convert_selected_to_zod, { range = true })

vim.api.nvim_create_user_command("PrCreate", ":!gh pr create --web", {})
vim.api.nvim_create_user_command("Env", function(opts)
  if opts.args == "prod" then
    print(vim.fn.system("lerna run switch-env:prod"))
  elseif opts.args == "staging" then
    print(vim.fn.system("lerna run switch-env:staging"))
  end
end, {
  nargs = "?",
  complete = function(arg_lead, cmd_line, cursor_pos)
    return { "prod", "staging" }
  end,
})

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

vim.g.neoformat_basic_format_retab = 1

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.code-snippets",
  callback = function()
    vim.bo.filetype = "json"
  end,
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
