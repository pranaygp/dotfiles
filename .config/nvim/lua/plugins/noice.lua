-- Fix noice.nvim cmdline rendering issues
return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- Centered popup (the one you liked)
      },
      presets = {
        command_palette = true, -- Centered cmdline with popup menu
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      -- Filter out treesitter query errors that spam notifications
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "treesitter/query",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            find = "treesitter",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
