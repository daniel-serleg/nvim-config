return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
       'nvim-lua/plenary.nvim'
    },
    config = function()
        -- get access to telescopes built in functions
        local builtin = require('telescope.builtin')

        -- set a vim motion to <Space> + f + f to search for files by their names
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "[F]ind [F]iles"})
        -- set a vim motion to <Space> + f + g to search for files based on the text inside of them
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "[F]ind by [G]rep"})
        -- set a vim motion to <Space> + f + d to search for Code Diagnostics in the current project
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
        -- set a vim motion to <Space> + f + r to resume the previous search
        vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]inder [R]esume' })
        -- set a vim motion to <Space> + f + . to search for Recent Files
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
        -- set a vim motion to <Space> + f + b to search Open Buffers
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind Existing [B]uffers' })
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
        -- get access to telescopes navigation functions
        local actions = require("telescope.actions")

        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }
                }
            },
            -- set keymappings to navigate through items in the telescope io
            mappings = {
                i = {
                     -- use <cltr> + n to go to the next option
                    ["<C-n>"] = actions.cycle_history_next,
                    -- use <cltr> + p to go to the previous option
                    ["<C-p>"] = actions.cycle_history_prev,
                    -- use <cltr> + j to go to the next preview
                    ["<C-j>"] = actions.move_selection_next,
                    -- use <cltr> + k to go to the previous preview
                    ["<C-k>"] = actions.move_selection_previous,
                }
            },
            require("telescope").load_extension("ui-select")
        }
    end
  }
}

