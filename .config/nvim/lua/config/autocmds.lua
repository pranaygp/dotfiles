-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local utils = require("config.utils")

-- Auto-sync colorscheme with system appearance
local function sync_colorscheme()
  local current_colorscheme = vim.g.colors_name
  local target_colorscheme = utils.is_dark_mode() and "vercel" or "catppuccin-latte"

  if current_colorscheme ~= target_colorscheme then
    -- Check if the colorscheme is available before applying it
    local ok = pcall(vim.cmd.colorscheme, target_colorscheme)
    if not ok then
      -- Colorscheme not yet loaded, will be synced on next FocusGained
      return
    end
  end
end

-- Create autocommand group
local group = vim.api.nvim_create_augroup("SystemAppearanceSync", { clear = true })

-- Sync colorscheme when Neovim gains focus (but not on VimEnter to avoid race conditions)
vim.api.nvim_create_autocmd("FocusGained", {
  group = group,
  callback = function()
    sync_colorscheme()
  end,
  desc = "Sync colorscheme with system appearance",
})

-- Sync colorscheme after lazy.nvim has loaded plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  group = group,
  callback = function()
    sync_colorscheme()
  end,
  desc = "Initial sync colorscheme with system appearance after plugins load",
})

-- Create user command to manually sync colorscheme
vim.api.nvim_create_user_command("SyncColorscheme", sync_colorscheme, {
  desc = "Manually sync colorscheme with system appearance",
})

-- Spell checking for prose files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown", "txt" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function()
    vim.bo.bufhidden = "unload"
    vim.cmd.wincmd("L")
    vim.cmd.wincmd("=")
  end,
})
