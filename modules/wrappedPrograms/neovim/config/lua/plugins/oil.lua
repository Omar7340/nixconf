return {
  "oil-nvim",
  after = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("oil").setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      }
    })
  end,
  keys = { { "<leader>e", "<CMD>Oil<CR>", desc = "Open directory (Oil)" } }
}
