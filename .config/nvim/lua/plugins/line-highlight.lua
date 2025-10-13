-- Plugin for highlighting arbitrary lines (useful for code demos)
return {
  -- Configure which-key group
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>h", group = "Highlight" },
      },
    },
  },

  -- Add keybindings
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>hl",
        function()
          local ns = vim.api.nvim_create_namespace("line_highlight")
          local bufnr = vim.api.nvim_get_current_buf()
          local line_num = vim.fn.line(".") - 1 -- 0-indexed for extmarks

          -- Add extmark with full-line highlight
          vim.api.nvim_buf_set_extmark(bufnr, ns, line_num, 0, {
            line_hl_group = "LineHighlight",
            priority = 100,
          })

          vim.notify("Line " .. (line_num + 1) .. " highlighted", vim.log.levels.INFO)
        end,
        desc = "Highlight current line",
      },
      {
        "<leader>hl",
        function()
          local ns = vim.api.nvim_create_namespace("line_highlight")
          local bufnr = vim.api.nvim_get_current_buf()
          local start_line = vim.fn.line("v") - 1 -- 0-indexed
          local end_line = vim.fn.line(".") - 1 -- 0-indexed

          -- Ensure start_line is before end_line
          if start_line > end_line then
            start_line, end_line = end_line, start_line
          end

          -- Highlight all lines in selection
          for line_num = start_line, end_line do
            vim.api.nvim_buf_set_extmark(bufnr, ns, line_num, 0, {
              line_hl_group = "LineHighlight",
              priority = 100,
            })
          end

          local count = end_line - start_line + 1
          vim.notify(count .. " line(s) highlighted", vim.log.levels.INFO)
        end,
        mode = "v",
        desc = "Highlight selected lines",
      },
      {
        "<leader>hc",
        function()
          local ns = vim.api.nvim_create_namespace("line_highlight")
          local bufnr = vim.api.nvim_get_current_buf()
          vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
          vim.notify("All line highlights cleared", vim.log.levels.INFO)
        end,
        desc = "Clear all line highlights",
      },
      {
        "<leader>hh",
        function()
          local ns = vim.api.nvim_create_namespace("line_highlight")
          local bufnr = vim.api.nvim_get_current_buf()
          local line_num = vim.fn.line(".") - 1 -- 0-indexed for extmarks

          -- Check if current line is already highlighted
          local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, ns, { line_num, 0 }, { line_num, -1 }, {})
          local found = false

          for _, extmark in ipairs(extmarks) do
            local id = extmark[1]
            vim.api.nvim_buf_del_extmark(bufnr, ns, id)
            found = true
          end

          if not found then
            vim.api.nvim_buf_set_extmark(bufnr, ns, line_num, 0, {
              line_hl_group = "LineHighlight",
              priority = 100,
            })
            vim.notify("Line " .. (line_num + 1) .. " highlighted", vim.log.levels.INFO)
          else
            vim.notify("Line " .. (line_num + 1) .. " unhighlighted", vim.log.levels.INFO)
          end
        end,
        desc = "Toggle highlight on current line",
      },
      {
        "<leader>hh",
        function()
          local ns = vim.api.nvim_create_namespace("line_highlight")
          local bufnr = vim.api.nvim_get_current_buf()
          local start_line = vim.fn.line("v") - 1 -- 0-indexed
          local end_line = vim.fn.line(".") - 1 -- 0-indexed

          -- Ensure start_line is before end_line
          if start_line > end_line then
            start_line, end_line = end_line, start_line
          end

          -- Check if any line in the selection is highlighted
          local any_highlighted = false
          for line_num = start_line, end_line do
            local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, ns, { line_num, 0 }, { line_num, -1 }, {})
            if #extmarks > 0 then
              any_highlighted = true
              break
            end
          end

          -- If any line is highlighted, unhighlight all; otherwise highlight all
          if any_highlighted then
            for line_num = start_line, end_line do
              local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, ns, { line_num, 0 }, { line_num, -1 }, {})
              for _, extmark in ipairs(extmarks) do
                vim.api.nvim_buf_del_extmark(bufnr, ns, extmark[1])
              end
            end
            local count = end_line - start_line + 1
            vim.notify(count .. " line(s) unhighlighted", vim.log.levels.INFO)
          else
            for line_num = start_line, end_line do
              vim.api.nvim_buf_set_extmark(bufnr, ns, line_num, 0, {
                line_hl_group = "LineHighlight",
                priority = 100,
              })
            end
            local count = end_line - start_line + 1
            vim.notify(count .. " line(s) highlighted", vim.log.levels.INFO)
          end
        end,
        mode = "v",
        desc = "Toggle highlight on selected lines",
      },
    },
    init = function()
      -- Function to set the highlight group
      local function set_line_highlight()
        -- Using a color that complements vercel-black's magenta/warm color palette
        vim.api.nvim_set_hl(0, "LineHighlight", {
          bg = "#3d1f28", -- Purple-rose tint (matches vercel magenta/red tones)
          -- Alternative warm colors:
          -- bg = "#4a2820", -- More orange-brown
          -- bg = "#462330", -- Purple tint
          -- bg = "#3a1520", -- Darker purple-red
        })
      end

      -- Set highlight initially
      set_line_highlight()

      -- Re-apply highlight after colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = set_line_highlight,
        desc = "Restore LineHighlight after colorscheme change",
      })
    end,
  },
}
