local utils = require("config.utils")

-- Set initial colorscheme based on system appearance
local function get_colorscheme()
  return utils.is_dark_mode() and "vercel" or "catppuccin-latte"
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
      colorscheme = get_colorscheme(),
    },
  },
}
