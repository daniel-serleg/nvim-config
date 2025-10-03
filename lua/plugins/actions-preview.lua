return {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local actions_preview = require("actions-preview")
    actions_preview.setup({
      -- Configuration for the actions preview
      highlight_command = {
        -- Use delta for better diffs (if available), otherwise use built-in diff
        require("actions-preview.highlight").delta(),
        require("actions-preview.highlight").diff_so_fancy(),
        require("actions-preview.highlight").diff_highlight(),
      },
      -- Telescope configuration
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    })
  end,
}
