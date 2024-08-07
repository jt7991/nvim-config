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
          jestConfigFile = function(file)
            if string.match(file, "%.ign%.test%.ts$") then
              return "jest.luna.integration.config.ts"
            end

            if string.match(file, "%.unit%.test%.ts$") then
              return "jest.luna.unit.config.ts"
            end
            error("Not a valid test file")
          end,
        }),
      },
      cwd = function(file)
        if string.find(file, "server/functions") then
          return string.match(file, "(.-/[^/]+/server/functions)")
        end
      end,
    })
  end,
  vim.keymap.set("n", "<leader>tt", function()
    require("neotest").run.run(vim.fn.expand("%"))
  end, { desc = "Run test file" }),

  vim.keymap.set("n", "<leader>tr", function()
    require("neotest").run.run()
  end, { desc = "Run Nearest" }),

  vim.keymap.set("n", "<leader>to", function()
    require("neotest").output_panel.toggle()
  end, { desc = "Toggle output panel" }),

  vim.keymap.set("n", "<leader>tw", function()
    require("neotest").run.run()
  end, { desc = "Run test file in watch mode" }),
}
