return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "lua_ls", "vtsls", "basedpyright", "ruff" },
      automatic_enable = true,
    },
    config = function(_, opts)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
            diagnostics = { globals = { "vim" } },
          },
        },
      })
      require("mason-lspconfig").setup(opts)
    end,
  },
}
