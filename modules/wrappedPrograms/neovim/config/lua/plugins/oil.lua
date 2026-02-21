return {
  "oil-nvim",
  event = "UIEnter",
  after = function()
    require("oil").setup({
      view_options = {
        show_hidden = true,
      }
    })
  end,
  keys = { { "<leader>e", "<CMD>Oil<CR>", desc = "Open directory (Oil)" } }
}
