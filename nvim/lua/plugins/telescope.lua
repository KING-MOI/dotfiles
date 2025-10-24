return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "%.git/", "node_modules/", "target/", "%.venv/" },
      },
      pickers = {
        find_files = { hidden = true },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
