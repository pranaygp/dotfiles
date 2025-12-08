-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Enable this option to avoid conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

-- Set font for GUI Neovim (Neovide, Neovim-qt, etc.)
vim.opt.guifont = "GeistMono Nerd Font Mono:h14"

-- Ensure Treesitter highlighting takes priority over LSP semantic tokens
vim.g.semantic_tokens_enabled = true

-- Set terminal window title to project name
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"
