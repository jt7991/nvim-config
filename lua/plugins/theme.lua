return {
  "folke/tokyonight.nvim",
  priority = 1000,
  transparent = true,
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}
