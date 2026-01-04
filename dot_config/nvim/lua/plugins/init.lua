return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  
 
  "neovim/nvim-lspconfig",
    ft = { "cs", "cshtml", "razor" }, -- File types for C# and Razor
    opts = {
      servers = {
        omnisharp = {
          cmd = { "omnisharp", "--languageserver", "Stdio" }, -- Adjust this command based on your install location
        },
      },
    },

    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "omnisharp" },
        })
        require("lspconfig").omnisharp.setup({})
    end,

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {
        "c_sharp__",
        "html",
        "css",

      }
      table.insert(opts.ensure_installed, "c_sharp")
    end,
  },

  {
    "mattn/emmet-vim",
    ft = { "html", "cshtml" }, -- Enable emmet for cshtml files
  },
}

