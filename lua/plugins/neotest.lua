return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          jestConfigFile = "jest.luna.unit.config.ts",
        }),
      },
    })
  end,
  vim.keymap.set("n", "<leader>T", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end),
}
