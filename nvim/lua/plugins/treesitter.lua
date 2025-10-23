return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "bash", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
      "json", "yaml", "toml",
      "typescript", "tsx", "javascript",
      "python",
      "rust",
    },
    highlight = { enable = true },
    indent = { enable = true },
  },
}
