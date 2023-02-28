return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      init = function()
        require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set(
            "n",
            "<leader>di",
            "<Cmd>lua require'jdtls'.organize_imports()<CR>",
            { buffer = buffer, desc = "Organize Imports" }
          )
          vim.keymap.set(
            "n",
            "<leader>dt",
            "<Cmd>lua require'jdtls'.test_class()<CR>",
            { buffer = buffer, desc = "Test Class" }
          )
          vim.keymap.set(
            "n",
            "<leader>dn",
            "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
            { buffer = buffer, desc = "Test Nearest Method" }
          )
          vim.keymap.set(
            "v",
            "<leader>de",
            "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
            { buffer = buffer, desc = "Extract Variable" }
          )
          vim.keymap.set(
            "n",
            "<leader>de",
            "<Cmd>lua require('jdtls').extract_variable()<CR>",
            { buffer = buffer, desc = "Extract Variable" }
          )
          vim.keymap.set(
            "v",
            "<leader>dm",
            "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
            { buffer = buffer, desc = "Extract Method" }
          )
          vim.keymap.set(
            "n",
            "<leader>cf",
            "<cmd>lua vim.lsp.buf.formatting()<CR>",
            { buffer = buffer, desc = "Format" }
          )
        end)
      end,
    },
    ---@class PluginLspOpts
    handlers = {
      ["language/status"] = function(_, result)
        -- Print or whatever.
      end,
      ["$/progress"] = function(_, result, ctx)
        -- disable progress updates.
      end,
    },
    opts = {
      ---@type lspconfig.options
      servers = {},
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        jdtls = function(_, opts)
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
          -- vim.lsp.set_log_level('DEBUG')
          local workspace_dir = "/home/jake/.workspace/" .. project_name -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
          local config = {
            -- The command that starts the language server
            -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
            cmd = {

              "java", -- or '/path/to/java17_or_newer/bin/java'

              "-javaagent:/home/jake/.local/share/java/lombok.jar",
              -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              -- '-noverify',
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-jar",
              vim.fn.glob("/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),

              "-configuration",
              "/usr/share/java/jdtls/config_linux",
              "-data",
              workspace_dir,
            },
            root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
            settings = {
              java = {},
            },
          }
          require("jdtls").start_or_attach(config)
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
