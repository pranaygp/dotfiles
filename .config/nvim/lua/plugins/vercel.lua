-- Function to detect macOS system appearance
local function is_dark_mode()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:match("Dark") ~= nil
  end
  return true -- default to dark mode if detection fails
end

-- Set initial colorscheme based on system appearance
local function get_colorscheme()
  if is_dark_mode() then
    return "vercel"
  else
    return "catppuccin-latte"
  end
end

return {
  -- Configure Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "latte", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
        },
      },
    },
  },
  -- Configure LazyVim to use the appropriate colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vercel-black",
    },
  },
}
