-- Enable snacks.nvim image rendering for documents and PDFs
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        doc = {
          enabled = true,
          inline = true,
          float = true,
          max_width = 120,
          max_height = 60,
        },
      },
    },
    keys = {
      {
        "<leader>io",
        function()
          local file = vim.fn.expand("%:p")
          vim.fn.system({ "open", file })
          vim.notify("Opened: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
        end,
        desc = "Open file externally",
      },
    },
    init = function()
      -- When opening a PDF, auto-open in Preview.app for better viewing
      vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*.pdf",
        callback = function()
          vim.schedule(function()
            local file = vim.fn.expand("%:p")
            local filename = vim.fn.expand("%:t")

            -- Open PDF in system viewer
            vim.fn.system({ "open", file })

            -- Close the buffer (don't need raw PDF in neovim)
            vim.cmd("bdelete")

            vim.notify("Opened " .. filename .. " in Preview", vim.log.levels.INFO)
          end)
        end,
      })
    end,
  },
}
