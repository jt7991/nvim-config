return {
  "axkirillov/easypick.nvim",
  requires = "nvim-telescope/telescope.nvim",
  config = function()
    local base_branch = "main"
    local easypick = require("easypick")
    easypick.setup({
      pickers = {
        -- add your custom pickers here
        -- below you can find some examples of what those can look like

        -- diff current branch with base_branch and show files that changed with respective diffs in preview
        {
          name = "changed_files",
          command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
          previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
        },

        -- list files that have conflicts with diffs in preview
        {
          name = "conflicts",
          command = "git diff --name-only --diff-filter=U --relative",
          previewer = easypick.previewers.file_diff(),
        },
      },
    })
    vim.keymap.set("n", "<leader>gc", "<cmd>Easypick changed_files<cr>", { desc = "[F]ind [D]iagnostics" })
  end,
}
