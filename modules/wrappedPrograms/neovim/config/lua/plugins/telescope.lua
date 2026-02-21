return {
  "telescope.nvim",
  cmd = "Telescope",
  after = function()
    require("telescope").setup()
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Open Filepicker"
    },
    {
      "<leader>g",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Open LiveGrep"
    },
  },
}
