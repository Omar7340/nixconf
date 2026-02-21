local keymap = vim.keymap.set

-- cancel search highlighting
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- move to windows
keymap("n", "<M-h>", "<C-w>h")
keymap("n", "<M-j>", "<C-w>j")
keymap("n", "<M-k>", "<C-w>k")
keymap("n", "<M-l>", "<C-w>l")

-- goto next windows
keymap("n", "<A-w>", "<C-w><C-w>")
