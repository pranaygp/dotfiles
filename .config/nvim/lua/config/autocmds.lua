-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-sync colorscheme with system appearance
local function is_dark_mode()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") ~= nil
  end
  return true -- default to dark mode if detection fails
end

local function sync_colorscheme()
  local current_colorscheme = vim.g.colors_name
  local target_colorscheme = is_dark_mode() and "vercel" or "catppuccin-latte"

  if current_colorscheme ~= target_colorscheme then
    vim.cmd.colorscheme(target_colorscheme)
  end
end

-- Create autocommand group
local group = vim.api.nvim_create_augroup("SystemAppearanceSync", { clear = true })

-- Sync colorscheme when Neovim gains focus
vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
  group = group,
  callback = function()
    sync_colorscheme()
  end,
  desc = "Sync colorscheme with system appearance",
})

-- Create user command to manually sync colorscheme
vim.api.nvim_create_user_command("SyncColorscheme", sync_colorscheme, {
  desc = "Manually sync colorscheme with system appearance",
})
