return {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
        -- gain access to the which key plugin
        local which_key = require('which-key')

        -- call the setup function with default properties
        which_key.setup()

        -- Register prefixes using the new spec format
        which_key.add({
            { "<leader>/", group = "Comments", icon = "" },
            { "<leader>/_", hidden = true },
            { "<leader>c", group = "[C]ode", icon = "" },
            { "<leader>c_", hidden = true },
            { "<leader>d", group = "[D]ebug", icon = "" },
            { "<leader>d_", hidden = true },
            { "<leader>e", group = "[E]xplorer", icon = "" },
            { "<leader>e_", hidden = true },
            { "<leader>f", group = "[F]ind", icon = "" },
            { "<leader>f_", hidden = true },
            { "<leader>g", group = "[G]it", icon = "" },
            { "<leader>g_", hidden = true },
            { "<leader>J", group = "[J]ava", icon = "" },
            { "<leader>J_", hidden = true },
            { "<leader>w", group = "[W]indow", icon = "" },
            { "<leader>w_", hidden = true },
            { "<leader>t", group = "[T]ab", icon = "" },
            { "<leader>t_", hidden = true },
        })
    end
}
