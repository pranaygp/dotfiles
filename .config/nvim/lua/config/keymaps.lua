-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Center buffer after navigation jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Prev search result and center" })
vim.keymap.set("n", "G", "Gzz", { desc = "Go to bottom and center" })
vim.keymap.set("n", "{", "{zz", { desc = "Prev paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Next paragraph and center" })

-- Quick find/replace for word under cursor
vim.keymap.set("n", "S", function()
  local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
  local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end, { desc = "Find/replace word under cursor" })

-- Copy file paths
vim.keymap.set("n", "<leader>yp", '<cmd>let @+ = expand("%:p")<cr>', { desc = "Copy absolute path" })
vim.keymap.set("n", "<leader>yr", '<cmd>let @+ = expand("%:.")<cr>', { desc = "Copy relative path" })
