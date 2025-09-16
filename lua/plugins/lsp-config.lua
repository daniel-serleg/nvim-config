return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
    dependencies = {
      'mason-org/mason-registry',
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "ts_ls", "jdtls" },
      }
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function()
      -- ensure the java debug adapter is installed
      require("mason-nvim-dap").setup({
        ensure_installed = { "java-debug-adapter", "java-test" }
      })
    end
  },
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      "mfussenegger/nvim-dap",
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- lspconfig.lua_ls.setup({})
      -- lspconfig.ts_ls.setup({})

      -- setup the lua language server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- setup the typescript language server
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })


      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

      -- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
      vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
      -- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
      vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
      -- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
      -- Set vim motion for <Space> + c + r to display references to the code under the cursor
      vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references,
        { desc = "[C]ode Goto [R]eferences" })
      -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
      vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations,
        { desc = "[C]ode Goto [I]mplementations" })
      -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
      vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
      -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
      vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
    end
  }
}
