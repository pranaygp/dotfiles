-- Vercel color scheme matching Ghostty Vercel theme
-- Based on the exact color palette from Ghostty's Vercel theme

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "vercel-black"
vim.o.termguicolors = true

-- Palette colors from Ghostty Vercel theme
local colors = {
  bg = "#000000",
  fg = "#fafafa",

  -- ANSI colors
  black = "#000000",
  red = "#fc0036",
  green = "#29a948",
  yellow = "#ffae00",
  blue = "#006aff",
  magenta = "#f32882",
  cyan = "#00ac96",
  white = "#feffff",

  -- Bright ANSI colors
  bright_black = "#1a1a1a",
  bright_red = "#ff8080",
  bright_green = "#4be15d",
  bright_yellow = "#ffae00",
  bright_blue = "#49aeff",
  bright_magenta = "#f97ea8",
  bright_cyan = "#00e4c4",
  bright_white = "#fefefe",

  -- Special colors
  cursor = "#f32882",
  selection_bg = "#005be7",
  selection_fg = "#fafafa",

  -- Additional UI colors
  comment = "#a8a8a8",
  line_highlight = "#161616",
  visual = "#005be7",
  gutter_fg = "#a8a8a8",
  gutter_bg = "#000000",
  document_highlight = "#282840",

  -- Custom colors for syntax
  purple = "#bf7af0", -- for functions
}

-- Helper function to set highlights
local function hi(group, opts)
  local cmd = "highlight " .. group
  if opts.fg then
    cmd = cmd .. " guifg=" .. opts.fg
  end
  if opts.bg then
    cmd = cmd .. " guibg=" .. opts.bg
  end
  if opts.gui then
    cmd = cmd .. " gui=" .. opts.gui
  end
  if opts.sp then
    cmd = cmd .. " guisp=" .. opts.sp
  end
  vim.cmd(cmd)
end

-- Editor highlights
hi("Normal", { fg = colors.fg, bg = colors.bg })
hi("NormalFloat", { fg = colors.fg, bg = colors.bg })
hi("NormalNC", { fg = colors.fg, bg = colors.bg })
hi("Comment", { fg = colors.comment, gui = "italic" })
hi("Constant", { fg = colors.bright_blue })
hi("String", { fg = colors.green })
hi("Character", { fg = colors.green })
hi("Number", { fg = colors.yellow })
hi("Boolean", { fg = colors.bright_blue })
hi("Float", { fg = colors.yellow })
hi("Identifier", { fg = colors.fg })
hi("Function", { fg = colors.purple }) -- purple/violet for functions
hi("Statement", { fg = colors.magenta }) -- use magenta for keywords
hi("Conditional", { fg = colors.magenta })
hi("Repeat", { fg = colors.magenta })
hi("Label", { fg = colors.magenta })
hi("Operator", { fg = colors.fg }) -- operators should be foreground color
hi("Keyword", { fg = colors.magenta })
hi("Exception", { fg = colors.red })
hi("PreProc", { fg = colors.magenta })
hi("Include", { fg = colors.magenta })
hi("Define", { fg = colors.magenta })
hi("Macro", { fg = colors.cyan })
hi("PreCondit", { fg = colors.cyan })
hi("Type", { fg = colors.bright_blue }) -- use blue instead of cyan
hi("StorageClass", { fg = colors.blue })
hi("Structure", { fg = colors.bright_blue })
hi("Typedef", { fg = colors.bright_blue })
hi("Special", { fg = colors.purple }) -- purple
hi("SpecialChar", { fg = colors.purple })
hi("Tag", { fg = colors.magenta })
hi("Delimiter", { fg = colors.fg })
hi("SpecialComment", { fg = colors.comment, gui = "italic" })
hi("Debug", { fg = colors.red })
hi("Underlined", { fg = colors.bright_blue, gui = "underline" })
hi("Error", { fg = colors.red, bg = colors.bg })
hi("ErrorMsg", { fg = colors.red })
hi("Warning", { fg = colors.yellow })
hi("WarningMsg", { fg = colors.yellow })
hi("Info", { fg = colors.bright_blue })
hi("Hint", { fg = colors.bright_cyan })
hi("Todo", { fg = colors.yellow, bg = colors.bg, gui = "bold" })

-- UI elements
hi("Cursor", { fg = colors.fg, bg = colors.cursor })
hi("CursorLine", { bg = colors.line_highlight })
hi("CursorLineNr", { fg = colors.bright_magenta, bg = colors.line_highlight })
hi("LineNr", { fg = colors.gutter_fg, bg = colors.gutter_bg })
hi("Visual", { bg = colors.visual })
hi("VisualNOS", { bg = colors.visual })
hi("Search", { fg = colors.bg, bg = colors.yellow })
hi("IncSearch", { fg = colors.bg, bg = colors.bright_yellow })
hi("CurSearch", { fg = colors.bg, bg = colors.bright_yellow })
hi("MatchParen", { fg = colors.bright_magenta, gui = "bold" })
hi("Pmenu", { fg = colors.fg, bg = "#1a1a1a" })
hi("PmenuSel", { fg = colors.bg, bg = colors.bright_blue })
hi("PmenuSbar", { bg = "#2a2a2a" })
hi("PmenuThumb", { bg = colors.bright_black })
hi("StatusLine", { fg = colors.fg, bg = "#1a1a1a" })
hi("StatusLineNC", { fg = colors.comment, bg = "#1a1a1a" })
hi("TabLine", { fg = colors.comment, bg = "#1a1a1a" })
hi("TabLineFill", { bg = "#1a1a1a" })
hi("TabLineSel", { fg = colors.fg, bg = colors.bg })
hi("VertSplit", { fg = "#2a2a2a" })
hi("WinSeparator", { fg = "#2a2a2a" })
hi("Folded", { fg = colors.comment, bg = "#1a1a1a" })
hi("FoldColumn", { fg = colors.comment, bg = colors.gutter_bg })
hi("SignColumn", { fg = colors.fg, bg = colors.gutter_bg })
hi("Directory", { fg = colors.bright_blue })
hi("Title", { fg = colors.bright_magenta, gui = "bold" })
hi("ColorColumn", { bg = "#1a1a1a" })
hi("NonText", { fg = colors.comment })
hi("SpecialKey", { fg = colors.comment })
hi("EndOfBuffer", { fg = colors.bg })

-- Diff
hi("DiffAdd", { fg = colors.bright_green, bg = "#0a2a14" })
hi("DiffChange", { fg = colors.bright_yellow, bg = "#2a2a0a" })
hi("DiffDelete", { fg = colors.red, bg = "#2a0a0a" })
hi("DiffText", { fg = colors.bright_blue, bg = "#0a1a2a" })

-- Git signs
hi("GitSignsAdd", { fg = colors.green })
hi("GitSignsChange", { fg = colors.yellow })
hi("GitSignsDelete", { fg = colors.red })

-- LSP
hi("DiagnosticError", { fg = colors.red })
hi("DiagnosticWarn", { fg = colors.yellow })
hi("DiagnosticInfo", { fg = colors.bright_blue })
hi("DiagnosticHint", { fg = colors.bright_cyan })
hi("DiagnosticUnderlineError", { sp = colors.red, gui = "undercurl" })
hi("DiagnosticUnderlineWarn", { sp = colors.yellow, gui = "undercurl" })
hi("DiagnosticUnderlineInfo", { sp = colors.bright_blue, gui = "undercurl" })
hi("DiagnosticUnderlineHint", { sp = colors.bright_cyan, gui = "undercurl" })

-- LSP Document Highlighting (subtle background for references)
hi("LspReferenceText", { bg = colors.document_highlight })
hi("LspReferenceRead", { bg = colors.document_highlight })
hi("LspReferenceWrite", { bg = colors.document_highlight })

-- Treesitter
hi("@variable", { fg = colors.fg })
hi("@variable.builtin", { fg = colors.blue })
hi("@variable.parameter", { fg = colors.fg })
hi("@variable.member", { fg = colors.fg })
hi("@constant", { fg = colors.bright_blue })
hi("@constant.builtin", { fg = colors.blue })
hi("@module", { fg = colors.fg })
hi("@string", { fg = colors.green })
hi("@string.escape", { fg = colors.purple }) -- purple
hi("@string.regexp", { fg = colors.cyan })
hi("@character", { fg = colors.green })
hi("@number", { fg = colors.yellow })
hi("@boolean", { fg = colors.blue })
hi("@function", { fg = colors.purple }) -- purple/violet for functions
hi("@function.builtin", { fg = colors.purple })
hi("@function.method", { fg = colors.fg }) -- methods should be foreground
hi("@constructor", { fg = colors.bright_blue })
hi("@keyword", { fg = colors.magenta }) -- use magenta
hi("@keyword.function", { fg = colors.magenta })
hi("@keyword.operator", { fg = colors.magenta })
hi("@keyword.return", { fg = colors.magenta })
hi("@operator", { fg = colors.fg }) -- operators should be foreground
hi("@punctuation.delimiter", { fg = colors.fg })
hi("@punctuation.bracket", { fg = colors.fg })
hi("@type", { fg = colors.bright_blue }) -- use blue
hi("@type.builtin", { fg = colors.bright_blue })
hi("@attribute", { fg = colors.cyan })
hi("@property", { fg = colors.fg })
hi("@tag", { fg = colors.magenta }) -- tags use magenta
hi("@tag.attribute", { fg = colors.fg })
hi("@tag.delimiter", { fg = colors.comment })

-- LSP Semantic Tokens (prevent LSP from overriding Treesitter)
hi("@lsp.type.namespace", { fg = colors.fg })
hi("@lsp.type.type", { fg = colors.bright_blue })
hi("@lsp.type.class", { fg = colors.bright_blue })
hi("@lsp.type.enum", { fg = colors.bright_blue })
hi("@lsp.type.interface", { fg = colors.bright_blue })
hi("@lsp.type.struct", { fg = colors.bright_blue })
hi("@lsp.type.parameter", { fg = colors.fg })
hi("@lsp.type.variable", { fg = colors.fg })
hi("@lsp.type.property", { fg = colors.fg })
hi("@lsp.type.enumMember", { fg = colors.bright_blue })
hi("@lsp.type.function", { fg = colors.purple })
hi("@lsp.type.method", { fg = colors.fg })
hi("@lsp.type.macro", { fg = colors.cyan })
hi("@lsp.type.decorator", { fg = colors.cyan })
hi("@lsp.type.keyword", { fg = colors.magenta })
hi("@lsp.type.comment", { fg = colors.comment })
hi("@lsp.type.string", { fg = colors.green })
hi("@lsp.type.number", { fg = colors.yellow })
hi("@lsp.type.operator", { fg = colors.fg })

-- Telescope
hi("TelescopeBorder", { fg = colors.bright_black })
hi("TelescopePromptBorder", { fg = colors.bright_black })
hi("TelescopeResultsBorder", { fg = colors.bright_black })
hi("TelescopePreviewBorder", { fg = colors.bright_black })
hi("TelescopeSelection", { bg = colors.visual })
hi("TelescopeSelectionCaret", { fg = colors.bright_magenta })
hi("TelescopeMatching", { fg = colors.bright_yellow, gui = "bold" })

-- Neo-tree / NvimTree
hi("NeoTreeNormal", { fg = colors.fg, bg = colors.bg })
hi("NeoTreeNormalNC", { fg = colors.fg, bg = colors.bg })
hi("NvimTreeNormal", { fg = colors.fg, bg = colors.bg })
hi("NvimTreeFolderName", { fg = colors.bright_blue })
hi("NvimTreeOpenedFolderName", { fg = colors.bright_blue, gui = "bold" })

-- Which-key
hi("WhichKey", { fg = colors.bright_magenta })
hi("WhichKeyGroup", { fg = colors.bright_blue })
hi("WhichKeyDesc", { fg = colors.fg })
hi("WhichKeySeparator", { fg = colors.comment })

-- Notify
hi("NotifyERRORBorder", { fg = colors.red })
hi("NotifyWARNBorder", { fg = colors.yellow })
hi("NotifyINFOBorder", { fg = colors.bright_blue })
hi("NotifyDEBUGBorder", { fg = colors.comment })
hi("NotifyTRACEBorder", { fg = colors.bright_magenta })
hi("NotifyERRORIcon", { fg = colors.red })
hi("NotifyWARNIcon", { fg = colors.yellow })
hi("NotifyINFOIcon", { fg = colors.bright_blue })
hi("NotifyDEBUGIcon", { fg = colors.comment })
hi("NotifyTRACEIcon", { fg = colors.bright_magenta })
hi("NotifyERRORTitle", { fg = colors.red })
hi("NotifyWARNTitle", { fg = colors.yellow })
hi("NotifyINFOTitle", { fg = colors.bright_blue })
hi("NotifyDEBUGTitle", { fg = colors.comment })
hi("NotifyTRACETitle", { fg = colors.bright_magenta })
