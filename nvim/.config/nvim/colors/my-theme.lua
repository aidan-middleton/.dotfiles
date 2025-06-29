local o = vim.o
local g = vim.g
local cmd = vim.cmd
local nvim_set_hl = vim.api.nvim_set_hl
local tbl_deep_extend = vim.tbl_deep_extend

---@class MyThemeConfig
---@field italic_comment? boolean
---@field transparent_bg? boolean
---@field show_end_of_buffer? boolean
---@field lualine_bg_color? string?
---@field colors? Palette
---@field theme? string?
---@field overrides? HighlightGroups | fun(colors: Palette): HighlightGroups
local DEFAULT_CONFIG = {
   italic_comment = false,
   transparent_bg = false,
   show_end_of_buffer = false,
   lualine_bg_color = nil,
   colors = PALETTE,
   overrides = {},
   theme = 'my-theme'
}

local PALETTE = {
   bg = "#000000",
   fg = "#F8F8F2",
   selection = "#44475A",
   comment = "#6272A4",
   red = "#FF5555",
   orange = "#FFB86C",
   yellow = "#F1FA8C",
   green = "#50fa7b",
   purple = "#BD93F9",
   cyan = "#8BE9FD",
   pink = "#FF79C6",
   bright_red = "#FF6E6E",
   bright_green = "#69FF94",
   bright_yellow = "#FFFFA5",
   bright_blue = "#D6ACFF",
   bright_magenta = "#FF92DF",
   bright_cyan = "#A4FFFF",
   bright_white = "#FFFFFF",
   menu = "#21222C",
   visual = "#3E4452",
   gutter_fg = "#4B5263",
   nontext = "#3B4048",
   white = "#ABB2BF",
   black = "#191A21",
}

local TRANSPARENTS = {
   "Normal",
   "SignColumn",
   "NvimTreeNormal",
   "NvimTreeVertSplit",
   "NeoTreeNormal",
   "NeoTreeNormalNC"
}

---setup highlight groups
---@return HighlightGroups
---@nodiscard
local function get_groups()
   local endOfBuffer = {
      fg = DEFAULT_CONFIG.show_end_of_buffer and PALETTE.visual or PALETTE.bg,
   }

   return {
      Normal = { fg = PALETTE.fg, bg = PALETTE.bg, },
      NormalFloat = { fg = PALETTE.fg, bg = PALETTE.bg, },
      Comment = { fg = PALETTE.comment, italic = DEFAULT_CONFIG.italic_comment, },
      Constant = { fg = PALETTE.yellow, },
      String = { fg = PALETTE.yellow, },
      Character = { fg = PALETTE.green, },
      Number = { fg = PALETTE.orange, },
      Boolean = { fg = PALETTE.cyan, },
      Float = { fg = PALETTE.orange, },
      FloatBorder = { fg = PALETTE.white, },
      Operator = { fg = PALETTE.purple, },
      Keyword = { fg = PALETTE.cyan, },
      Keywords = { fg = PALETTE.cyan, },
      Identifier = { fg = PALETTE.cyan, },
      Function = { fg = PALETTE.yellow, },
      Statement = { fg = PALETTE.purple, },
      Conditional = { fg = PALETTE.pink, },
      Repeat = { fg = PALETTE.pink, },
      Label = { fg = PALETTE.cyan, },
      Exception = { fg = PALETTE.purple, },
      PreProc = { fg = PALETTE.yellow, },
      Include = { fg = PALETTE.purple, },
      Define = { fg = PALETTE.purple, },
      Title = { fg = PALETTE.cyan, },
      Macro = { fg = PALETTE.purple, },
      PreCondit = { fg = PALETTE.cyan, },
      Type = { fg = PALETTE.cyan, },
      StorageClass = { fg = PALETTE.pink, },
      Structure = { fg = PALETTE.yellow, },
      TypeDef = { fg = PALETTE.yellow, },
      Special = { fg = PALETTE.green, italic = true },
      SpecialComment = { fg = PALETTE.comment, italic = true, },
      Error = { fg = PALETTE.bright_red, },
      Todo = { fg = PALETTE.purple, bold = true, italic = true, },
      Underlined = { fg = PALETTE.cyan, underline = true, },

      Cursor = { reverse = true, },
      CursorLineNr = { fg = PALETTE.fg, bold = true, },

      SignColumn = { bg = PALETTE.bg, },

      Conceal = { fg = PALETTE.comment, },
      CursorColumn = { bg = PALETTE.black, },
      CursorLine = { bg = PALETTE.selection, },
      ColorColumn = { bg = PALETTE.selection, },

      StatusLine = { fg = PALETTE.white, bg = PALETTE.black, },
      StatusLineNC = { fg = PALETTE.comment, },
      StatusLineTerm = { fg = PALETTE.white, bg = PALETTE.black, },
      StatusLineTermNC = { fg = PALETTE.comment, },

      Directory = { fg = PALETTE.cyan, },
      DiffAdd = { fg = PALETTE.bg, bg = PALETTE.green, },
      DiffChange = { fg = PALETTE.orange, },
      DiffDelete = { fg = PALETTE.red, },
      DiffText = { fg = PALETTE.comment, },

      ErrorMsg = { fg = PALETTE.bright_red, },
      VertSplit = { fg = PALETTE.black, },
      WinSeparator = { fg = PALETTE.black, },
      Folded = { fg = PALETTE.comment, },
      FoldColumn = {},
      Search = { fg = PALETTE.black, bg = PALETTE.orange, },
      IncSearch = { fg = PALETTE.orange, bg = PALETTE.comment, },
      LineNr = { fg = PALETTE.comment, },
      MatchParen = { fg = PALETTE.fg, underline = true, },
      NonText = { fg = PALETTE.nontext, },
      Pmenu = { fg = PALETTE.white, bg = PALETTE.menu, },
      PmenuSel = { fg = PALETTE.white, bg = PALETTE.selection, },
      PmenuSbar = { bg = PALETTE.bg, },
      PmenuThumb = { bg = PALETTE.selection, },

      Question = { fg = PALETTE.purple, },
      QuickFixLine = { fg = PALETTE.black, bg = PALETTE.yellow, },
      SpecialKey = { fg = PALETTE.nontext, },

      SpellBad = { fg = PALETTE.bright_red, underline = true, },
      SpellCap = { fg = PALETTE.yellow, },
      SpellLocal = { fg = PALETTE.yellow, },
      SpellRare = { fg = PALETTE.yellow, },

      TabLine = { fg = PALETTE.comment, },
      TabLineSel = { fg = PALETTE.white, },
      TabLineFill = { bg = PALETTE.bg, },
      Terminal = { fg = PALETTE.white, bg = PALETTE.black, },
      Visual = { bg = PALETTE.visual, },
      VisualNOS = { fg = PALETTE.visual, },
      WarningMsg = { fg = PALETTE.yellow, },
      WildMenu = { fg = PALETTE.black, bg = PALETTE.white, },

      EndOfBuffer = endOfBuffer,

      -- TreeSitter
      ['@error'] = { fg = PALETTE.bright_red, },
      ['@punctuation.delimiter'] = { fg = PALETTE.fg, },
      ['@punctuation.bracket'] = { fg = PALETTE.fg, },
      ['@markup.list'] = { fg = PALETTE.cyan, },

      ['@constant'] = { fg = PALETTE.purple, },
      ['@constant.builtin'] = { fg = PALETTE.purple, },
      ['@markup.link.label.symbol'] = { fg = PALETTE.purple, },

      ['@constant.macro'] = { fg = PALETTE.cyan, },
      ['@string.regexp'] = { fg = PALETTE.red, },
      ['@string'] = { fg = PALETTE.yellow, },
      ['@string.escape'] = { fg = PALETTE.cyan, },
      ['@string.special.symbol'] = { fg = PALETTE.purple, },
      ['@character'] = { fg = PALETTE.green, },
      ['@number'] = { fg = PALETTE.purple, },
      ['@boolean'] = { fg = PALETTE.purple, },
      ['@number.float'] = { fg = PALETTE.green, },
      ['@annotation'] = { fg = PALETTE.yellow, },
      ['@attribute'] = { fg = PALETTE.cyan, },
      ['@module'] = { fg = PALETTE.orange, },

      ['@function.builtin'] = { fg = PALETTE.cyan, },
      ['@function'] = { fg = PALETTE.green, },
      ['@function.macro'] = { fg = PALETTE.green, },
      ['@variable.parameter'] = { fg = PALETTE.orange, },
      ['@variable.parameter.reference'] = { fg = PALETTE.orange, },
      ['@function.method'] = { fg = PALETTE.green, },
      ['@variable.member'] = { fg = PALETTE.orange, },
      ['@property'] = { fg = PALETTE.purple, },
      ['@constructor'] = { fg = PALETTE.cyan, },

      ['@keyword.conditional'] = { fg = PALETTE.pink, },
      ['@keyword.repeat'] = { fg = PALETTE.pink, },
      ['@label'] = { fg = PALETTE.cyan, },

      ['@keyword'] = { fg = PALETTE.pink, },
      ['@keyword.function'] = { fg = PALETTE.cyan, },
      ['@keyword.function.ruby'] = { fg = PALETTE.pink, },
      ['@keyword.operator'] = { fg = PALETTE.pink, },
      ['@operator'] = { fg = PALETTE.pink, },
      ['@keyword.exception'] = { fg = PALETTE.purple, },
      ['@type'] = { fg = PALETTE.bright_cyan, },
      ['@type.builtin'] = { fg = PALETTE.cyan, italic = true, },
      ['@type.qualifier'] = { fg = PALETTE.pink, },
      ['@structure'] = { fg = PALETTE.purple, },
      ['@keyword.include'] = { fg = PALETTE.pink, },

      ['@variable'] = { fg = PALETTE.fg, },
      ['@variable.builtin'] = { fg = PALETTE.purple, },

      ['@markup'] = { fg = PALETTE.orange, },
      ['@markup.strong'] = { fg = PALETTE.orange, bold = true, },     -- bold
      ['@markup.emphasis'] = { fg = PALETTE.yellow, italic = true, }, -- italic
      ['@markup.underline'] = { fg = PALETTE.orange, },
      ['@markup.heading'] = { fg = PALETTE.pink, bold = true, },        -- title
      ['@markup.raw'] = { fg = PALETTE.yellow, },                 -- inline code
      ['@markup.link.url'] = { fg = PALETTE.yellow, italic = true, },      -- urls
      ['@markup.link'] = { fg = PALETTE.orange, bold = true, },

      ['@tag'] = { fg = PALETTE.cyan, },
      ['@tag.attribute'] = { fg = PALETTE.green, },
      ['@tag.delimiter'] = { fg = PALETTE.cyan, },

      -- Semantic
      ['@class'] = { fg = PALETTE.cyan },
      ['@struct'] = { fg = PALETTE.cyan },
      ['@enum'] = { fg = PALETTE.cyan },
      ['@enumMember'] = { fg = PALETTE.purple },
      ['@event'] = { fg = PALETTE.cyan },
      ['@interface'] = { fg = PALETTE.cyan },
      ['@modifier'] = { fg = PALETTE.cyan },
      ['@regexp'] = { fg = PALETTE.yellow },
      ['@typeParameter'] = { fg = PALETTE.cyan },
      ['@decorator'] = { fg = PALETTE.cyan },

      -- LSP Semantic (0.9+)
      ['@lsp.type.class'] = { fg = PALETTE.cyan },
      ['@lsp.type.enum'] = { fg = PALETTE.cyan },
      ['@lsp.type.decorator'] = { fg = PALETTE.green },
      ['@lsp.type.enumMember'] = { fg = PALETTE.purple },
      ['@lsp.type.function'] = { fg = PALETTE.green, },
      ['@lsp.type.interface'] = { fg = PALETTE.cyan },
      ['@lsp.type.macro'] = { fg = PALETTE.cyan },
      ['@lsp.type.method'] = { fg = PALETTE.green, },
      ['@lsp.type.namespace'] = { fg = PALETTE.orange, },
      ['@lsp.type.parameter'] = { fg = PALETTE.orange, },
      ['@lsp.type.property'] = { fg = PALETTE.purple, },
      ['@lsp.type.struct'] = { fg = PALETTE.cyan },
      ['@lsp.type.type'] = { fg = PALETTE.bright_cyan, },
      ['@lsp.type.variable'] = { fg = PALETTE.fg, },

      -- HTML
      htmlArg = { fg = PALETTE.green, },
      htmlBold = { fg = PALETTE.yellow, bold = true, },
      htmlEndTag = { fg = PALETTE.cyan, },
      htmlH1 = { fg = PALETTE.pink, },
      htmlH2 = { fg = PALETTE.pink, },
      htmlH3 = { fg = PALETTE.pink, },
      htmlH4 = { fg = PALETTE.pink, },
      htmlH5 = { fg = PALETTE.pink, },
      htmlH6 = { fg = PALETTE.pink, },
      htmlItalic = { fg = PALETTE.purple, italic = true, },
      htmlLink = { fg = PALETTE.purple, underline = true, },
      htmlSpecialChar = { fg = PALETTE.yellow, },
      htmlSpecialTagName = { fg = PALETTE.cyan, },
      htmlTag = { fg = PALETTE.cyan, },
      htmlTagN = { fg = PALETTE.cyan, },
      htmlTagName = { fg = PALETTE.cyan, },
      htmlTitle = { fg = PALETTE.white, },

      -- Markdown
      markdownBlockquote = { fg = PALETTE.yellow, italic = true, },
      markdownBold = { fg = PALETTE.orange, bold = true, },
      markdownCode = { fg = PALETTE.green, },
      markdownCodeBlock = { fg = PALETTE.orange, },
      markdownCodeDelimiter = { fg = PALETTE.red, },
      markdownH2 = { link = "rainbow2" },
      markdownH1 = { link = "rainbow1" },
      markdownH3 = { link = "rainbow3" },
      markdownH4 = { link = "rainbow4" },
      markdownH5 = { link = "rainbow5" },
      markdownH6 = { link = "rainbow6" },
      markdownHeadingDelimiter = { fg = PALETTE.red, },
      markdownHeadingRule = { fg = PALETTE.comment, },
      markdownId = { fg = PALETTE.purple, },
      markdownIdDeclaration = { fg = PALETTE.cyan, },
      markdownIdDelimiter = { fg = PALETTE.purple, },
      markdownItalic = { fg = PALETTE.yellow, italic = true, },
      markdownLinkDelimiter = { fg = PALETTE.purple, },
      markdownLinkText = { fg = PALETTE.pink, },
      markdownListMarker = { fg = PALETTE.cyan, },
      markdownOrderedListMarker = { fg = PALETTE.red, },
      markdownRule = { fg = PALETTE.comment, },
      ['@markup.heading.1.markdown'] = { link = 'rainbowcol1' },
		['@markup.heading.2.markdown'] = { link = 'rainbowcol2' },
		['@markup.heading.3.markdown'] = { link = 'rainbowcol3' },
		['@markup.heading.4.markdown'] = { link = 'rainbowcol4' },
		['@markup.heading.5.markdown'] = { link = 'rainbowcol5' },
		['@markup.heading.6.markdown'] = { link = 'rainbowcol6' },

      --  Diff
      diffAdded = { fg = PALETTE.green, },
      diffRemoved = { fg = PALETTE.red, },
      diffFileId = { fg = PALETTE.yellow, bold = true, reverse = true, },
      diffFile = { fg = PALETTE.nontext, },
      diffNewFile = { fg = PALETTE.green, },
      diffOldFile = { fg = PALETTE.red, },

      debugPc = { bg = PALETTE.menu, },
      debugBreakpoint = { fg = PALETTE.red, reverse = true, },

      -- Git Signs
      GitSignsAdd = { fg = PALETTE.bright_green, },
      GitSignsChange = { fg = PALETTE.cyan, },
      GitSignsDelete = { fg = PALETTE.bright_red, },
      GitSignsAddLn = { fg = PALETTE.black, bg = PALETTE.bright_green, },
      GitSignsChangeLn = { fg = PALETTE.black, bg = PALETTE.cyan, },
      GitSignsDeleteLn = { fg = PALETTE.black, bg = PALETTE.bright_red, },
      GitSignsCurrentLineBlame = { fg = PALETTE.white, },

      -- Telescope
      TelescopePromptBorder = { fg = PALETTE.comment, },
      TelescopeResultsBorder = { fg = PALETTE.comment, },
      TelescopePreviewBorder = { fg = PALETTE.comment, },
      TelescopeSelection = { fg = PALETTE.white, bg = PALETTE.selection, },
      TelescopeMultiSelection = { fg = PALETTE.purple, bg = PALETTE.selection, },
      TelescopeNormal = { fg = PALETTE.fg, bg = PALETTE.bg, },
      TelescopeMatching = { fg = PALETTE.green, },
      TelescopePromptPrefix = { fg = PALETTE.purple, },
      TelescopeResultsDiffDelete = { fg = PALETTE.red },
      TelescopeResultsDiffChange = { fg = PALETTE.cyan },
      TelescopeResultsDiffAdd = { fg = PALETTE.green },

      -- Flash
      FlashLabel =  { bg = PALETTE.red, fg = PALETTE.bright_white },

      -- NvimTree
      NvimTreeNormal = { fg = PALETTE.fg, bg = PALETTE.menu, },
      NvimTreeVertSplit = { fg = PALETTE.bg, bg = PALETTE.bg, },
      NvimTreeRootFolder = { fg = PALETTE.fg, bold = true, },
      NvimTreeGitDirty = { fg = PALETTE.yellow, },
      NvimTreeGitNew = { fg = PALETTE.bright_green, },
      NvimTreeImageFile = { fg = PALETTE.pink, },
      NvimTreeFolderIcon = { fg = PALETTE.purple, },
      NvimTreeIndentMarker = { fg = PALETTE.nontext, },
      NvimTreeEmptyFolderName = { fg = PALETTE.comment, },
      NvimTreeFolderName = { fg = PALETTE.fg, },
      NvimTreeSpecialFile = { fg = PALETTE.pink, underline = true, },
      NvimTreeOpenedFolderName = { fg = PALETTE.fg, },
      NvimTreeCursorLine = { bg = PALETTE.selection, },
      NvimTreeIn = { bg = PALETTE.selection, },

      NvimTreeEndOfBuffer = endOfBuffer,

      -- NeoTree
      NeoTreeNormal = { fg = PALETTE.fg, bg = PALETTE.menu, },
      NeoTreeNormalNC = { fg = PALETTE.fg, bg = PALETTE.menu, },
      NeoTreeDirectoryName = { fg = PALETTE.fg },
      NeoTreeGitUnstaged = { fg = PALETTE.bright_magenta },
      NeoTreeGitModified = { fg = PALETTE.bright_magenta },
      NeoTreeGitUntracked = { fg = PALETTE.bright_green },
      NeoTreeDirectoryIcon = { fg = PALETTE.purple },
      NeoTreeIndentMarker = { fg = PALETTE.nontext },

      -- Bufferline
      BufferLineIndicatorSelected = { fg = PALETTE.purple, },
      BufferLineFill = { bg = PALETTE.black, },
      BufferLineBufferSelected = { bg = PALETTE.bg, },
      BufferLineSeparator = { fg = PALETTE.black },

      -- LSP
      DiagnosticError = { fg = PALETTE.red, },
      DiagnosticWarn = { fg = PALETTE.yellow, },
      DiagnosticInfo = { fg = PALETTE.cyan, },
      DiagnosticHint = { fg = PALETTE.cyan, },
      DiagnosticUnderlineError = { undercurl = true, sp = PALETTE.red, },
      DiagnosticUnderlineWarn = { undercurl = true, sp = PALETTE.yellow, },
      DiagnosticUnderlineInfo = { undercurl = true, sp = PALETTE.cyan, },
      DiagnosticUnderlineHint = { undercurl = true, sp = PALETTE.cyan, },
      DiagnosticSignError = { fg = PALETTE.red, },
      DiagnosticSignWarn = { fg = PALETTE.yellow, },
      DiagnosticSignInfo = { fg = PALETTE.cyan, },
      DiagnosticSignHint = { fg = PALETTE.cyan, },
      DiagnosticFloatingError = { fg = PALETTE.red, },
      DiagnosticFloatingWarn = { fg = PALETTE.yellow, },
      DiagnosticFloatingInfo = { fg = PALETTE.cyan, },
      DiagnosticFloatingHint = { fg = PALETTE.cyan, },
      DiagnosticVirtualTextError = { fg = PALETTE.red, },
      DiagnosticVirtualTextWarn = { fg = PALETTE.yellow, },
      DiagnosticVirtualTextInfo = { fg = PALETTE.cyan, },
      DiagnosticVirtualTextHint = { fg = PALETTE.cyan, },

      LspDiagnosticsDefaultError = { fg = PALETTE.red, },
      LspDiagnosticsDefaultWarning = { fg = PALETTE.yellow, },
      LspDiagnosticsDefaultInformation = { fg = PALETTE.cyan, },
      LspDiagnosticsDefaultHint = { fg = PALETTE.cyan, },
      LspDiagnosticsUnderlineError = { fg = PALETTE.red, undercurl = true, },
      LspDiagnosticsUnderlineWarning = { fg = PALETTE.yellow, undercurl = true, },
      LspDiagnosticsUnderlineInformation = { fg = PALETTE.cyan, undercurl = true, },
      LspDiagnosticsUnderlineHint = { fg = PALETTE.cyan, undercurl = true, },
      LspReferenceText = { fg = PALETTE.orange, },
      LspReferenceRead = { fg = PALETTE.orange, },
      LspReferenceWrite = { fg = PALETTE.orange, },
      LspCodeLens = { fg = PALETTE.cyan, },
      LspInlayHint = { fg = "#969696", bg = "#2f3146" },

      --LSP Saga
      LspFloatWinNormal = { fg = PALETTE.fg, },
      LspFloatWinBorder = { fg = PALETTE.comment, },
      LspSagaHoverBorder = { fg = PALETTE.comment, },
      LspSagaSignatureHelpBorder = { fg = PALETTE.comment, },
      LspSagaCodeActionBorder = { fg = PALETTE.comment, },
      LspSagaDefPreviewBorder = { fg = PALETTE.comment, },
      LspLinesDiagBorder = { fg = PALETTE.comment, },
      LspSagaRenameBorder = { fg = PALETTE.comment, },
      LspSagaBorderTitle = { fg = PALETTE.menu, },
      LSPSagaDiagnosticTruncateLine = { fg = PALETTE.comment, },
      LspSagaDiagnosticBorder = { fg = PALETTE.comment, },
      LspSagaShTruncateLine = { fg = PALETTE.comment, },
      LspSagaDocTruncateLine = { fg = PALETTE.comment, },
      LspSagaLspFinderBorder = { fg = PALETTE.comment, },
      CodeActionNumber = { bg = 'NONE', fg = PALETTE.cyan },

      -- IndentBlankLine
      IndentBlanklineContextChar = { fg = PALETTE.bright_red, nocombine = true, },

      -- Nvim compe
      CmpItemAbbrDeprecated = { fg = PALETTE.white, bg = PALETTE.bg, },
      CmpItemAbbrMatch = { fg = PALETTE.cyan, bg = PALETTE.bg, },

      -- barbar
      BufferVisibleTarget = { fg = PALETTE.red },
      BufferTabpages = { fg = PALETTE.nontext, bg = PALETTE.black, bold = true },
      BufferTabpageFill = { fg = PALETTE.nontext, bg = PALETTE.black },
      BufferCurrentSign = { fg = PALETTE.purple },
      BufferCurrentTarget = { fg = PALETTE.red },
      BufferInactive = { fg = PALETTE.comment, bg = PALETTE.black, italic = true },
      BufferInactiveIndex = { fg = PALETTE.nontext, bg = PALETTE.black, italic = true },
      BufferInactiveMod = { fg = PALETTE.yellow, bg = PALETTE.black, italic = true },
      BufferInactiveSign = { fg = PALETTE.nontext, bg = PALETTE.black, italic = true },
      BufferInactiveTarget = { fg = PALETTE.red, bg = PALETTE.black, bold = true },

      -- Compe
      CompeDocumentation = { link = "Pmenu" },
      CompeDocumentationBorder = { link = "Pmenu" },

      -- Cmp
      CmpItemAbbr = { fg = PALETTE.white, bg = PALETTE.bg },
      CmpItemKind = { fg = PALETTE.white, bg = PALETTE.bg },
      CmpItemKindMethod = { link = "@function.method" },
      CmpItemKindText = { link = "@markup" },
      CmpItemKindFunction = { link = "@function" },
      CmpItemKindConstructor = { link = "@type" },
      CmpItemKindVariable = { link = "@variable" },
      CmpItemKindClass = { link = "@type" },
      CmpItemKindInterface = { link = "@type" },
      CmpItemKindModule = { link = "@module" },
      CmpItemKindProperty = { link = "@property" },
      CmpItemKindOperator = { link = "@operator" },
      CmpItemKindReference = { link = "@variable.parameter.reference" },
      CmpItemKindUnit = { link = "@variable.member" },
      CmpItemKindValue = { link = "@variable.member" },
      CmpItemKindField = { link = "@variable.member" },
      CmpItemKindEnum = { link = "@variable.member" },
      CmpItemKindKeyword = { link = "@keyword" },
      CmpItemKindSnippet = { link = "@markup" },
      CmpItemKindColor = { link = "DevIconCss" },
      CmpItemKindFile = { link = "TSURI" },
      CmpItemKindFolder = { link = "TSURI" },
      CmpItemKindEvent = { link = "@constant" },
      CmpItemKindEnumMember = { link = "@variable.member" },
      CmpItemKindConstant = { link = "@constant" },
      CmpItemKindStruct = { link = "@structure" },
      CmpItemKindTypeParameter = { link = "@variable.parameter" },

      -- Blink
      BlinkCmpLabel = { fg = PALETTE.white, bg = PALETTE.bg },
      BlinkCmpLabelDeprecated = { fg = PALETTE.white, bg = PALETTE.bg },
      BlinkCmpLabelMatch = { fg = PALETTE.cyan, bg = PALETTE.bg },
      BlinkCmpKind = { fg = PALETTE.white, bg = PALETTE.bg },
      BlinkCmpKindFunction = { link = "@function" },
      BlinkCmpKindConstructor = { link = "@type" },
      BlinkCmpKindVariable = { link = "@variable" },
      BlinkCmpKindClass = { link = "@type" },
      BlinkCmpKindInterface = { link = "@type" },
      BlinkCmpKindModule = { link = "@module" },
      BlinkCmpKindProperty = { link = "@property" },
      BlinkCmpKindOperator = { link = "@operator" },
      BlinkCmpKindReference = { link = "@variable.parameter.reference" },
      BlinkCmpKindUnit = { link = "@variable.member" },
      BlinkCmpKindValue = { link = "@variable.member" },
      BlinkCmpKindField = { link = "@variable.member" },
      BlinkCmpKindEnum = { link = "@variable.member" },
      BlinkCmpKindKeyword = { link = "@keyword" },
      BlinkCmpKindSnippet = { link = "@markup" },
      BlinkCmpKindColor = { link = "DevIconCss" },
      BlinkCmpKindFile = { link = "TSURI" },
      BlinkCmpKindFolder = { link = "TSURI" },
      BlinkCmpKindEvent = { link = "@constant" },
      BlinkCmpKindEnumMember = { link = "@variable.member" },
      BlinkCmpKindConstant = { link = "@constant" },
      BlinkCmpKindStruct = { link = "@structure" },
      BlinkCmpKindTypeParameter = { link = "@variable.parameter" },

      -- navic
      NavicIconsFile = { link = "CmpItemKindFile" },
      NavicIconsModule = { link = "CmpItemKindModule" },
      NavicIconsNamespace = { link = "CmpItemKindModule" },
      NavicIconsPackage = { link = "CmpItemKindModule" },
      NavicIconsClass = { link = "CmpItemKindClass" },
      NavicIconsMethod = { link = "CmpItemKindMethod" },
      NavicIconsProperty = { link = "CmpItemKindProperty" },
      NavicIconsField = { link = "CmpItemKindField" },
      NavicIconsConstructor = { link = "CmpItemKindConstructor" },
      NavicIconsEnum = { link = "CmpItemKindEnum" },
      NavicIconsInterface = { link = "CmpItemKindInterface" },
      NavicIconsFunction = { link = "CmpItemKindFunction" },
      NavicIconsVariable = { link = "CmpItemKindVariable" },
      NavicIconsConstant = { link = "CmpItemKindConstant" },
      NavicIconsString = { link = "String" },
      NavicIconsNumber = { link = "Number" },
      NavicIconsBoolean = { link = "Boolean" },
      NavicIconsArray = { link = "CmpItemKindClass" },
      NavicIconsObject = { link = "CmpItemKindClass" },
      NavicIconsKey = { link = "CmpItemKindKeyword" },
      NavicIconsKeyword = { link = "CmpItemKindKeyword" },
      NavicIconsNull = { fg = "blue" },
      NavicIconsEnumMember = { link = "CmpItemKindEnumMember" },
      NavicIconsStruct = { link = "CmpItemKindStruct" },
      NavicIconsEvent = { link = "CmpItemKindEvent" },
      NavicIconsOperator = { link = "CmpItemKindOperator" },
      NavicIconsTypeParameter = { link = "CmpItemKindTypeParameter" },
      NavicText = { fg = 'gray' },
      NavicSeparator = { fg = 'gray' },

      -- TS rainbow colors
      rainbowcol1 = { fg = PALETTE.fg },
      rainbowcol2 = { fg = PALETTE.pink },
      rainbowcol3 = { fg = PALETTE.cyan },
      rainbowcol4 = { fg = PALETTE.green },
      rainbowcol5 = { fg = PALETTE.purple },
      rainbowcol6 = { fg = PALETTE.orange },
      rainbowcol7 = { fg = PALETTE.fg },

      -- Rainbow delimiter
      RainbowDelimiterRed = { fg = PALETTE.fg },
      RainbowDelimiterYellow = {fg = PALETTE.pink },
      RainbowDelimiterBlue = {fg = PALETTE.cyan },
      RainbowDelimiterOrange = { fg = PALETTE.green },
      RainbowDelimiterGreen = { fg = PALETTE.purple },
      RainbowDelimiterViolet = { fg = PALETTE.orange },
      RainbowDelimiterCyan = { fg = PALETTE.fg },

      -- mini.indentscope
      MiniIndentscopeSymbol = { fg = "#B5629B" },
      MiniIndentscopeSymbolOff = { fg = "#B5629B" },

      -- mini.icons
      MiniIconsAzure = { fg = PALETTE.bright_cyan },
      MiniIconsBlue = { fg = PALETTE.bright_blue },
      MiniIconsCyan = { fg = PALETTE.cyan },
      MiniIconsGrey = { fg = PALETTE.white },
      MiniIconsOrange = { fg = PALETTE.orange },
      MiniIconsPurple = { fg = PALETTE.purple },
      MiniIconsRed = { fg = PALETTE.red },
      MiniIconsYellow = { fg = PALETTE.yellow },

      -- mini.statusline
      MiniStatuslineModeNormal = { fg = PALETTE.black, bg = PALETTE.purple, bold = true },
      MiniStatuslineModeInsert = { fg = PALETTE.black, bg = PALETTE.green, bold = true },
      MiniStatuslineModeVisual = { fg = PALETTE.black, bg = PALETTE.pink, bold = true },
      MiniStatuslineModeReplace = { fg = PALETTE.black, bg = PALETTE.yellow, bold = true },
      MiniStatuslineModeCommand = { fg = PALETTE.black, bg = PALETTE.cyan, bold = true },
      MiniStatuslineInactive = { fg = PALETTE.fg, bg = PALETTE.visual, bold = true },
      MiniStatuslineDevinfo = { fg = PALETTE.purple, bg = PALETTE.black },
      MiniStatuslineFilename = { fg = PALETTE.white, bg = PALETTE.black },
      MiniStatuslineFileinfo = { fg = PALETTE.purple, bg = PALETTE.black },

      -- mini.files
      MiniFilesNormal = { fg = PALETTE.fg, bg = PALETTE.menu },
      MiniFilesBorder = { fg = PALETTE.purple, bg = PALETTE.menu },
      MiniFilesBorderModified = { },
      MiniFilesCursorLine = { bg = PALETTE.selection, },
      MiniFilesDirectory = { fg = PALETTE.fg },
      MiniFilesFile = { fg = PALETTE.fg },
      MiniFilesTitle = { fg = PALETTE.fg },
      MiniFilesTitleFocused = { fg = PALETTE.yellow },

      -- goolord/alpha-nvim
      AlphaHeader = { fg = PALETTE.purple },
      AlphaButtons = { fg = PALETTE.cyan },
      AlphaShortcut = { fg = PALETTE.orange },
      AlphaFooter = { fg = PALETTE.purple, italic = true },

      -- nvimdev/dashboard-nvim
      DashboardShortCut = { fg = PALETTE.cyan },
      DashboardHeader = { fg = PALETTE.purple },
      DashboardCenter = { fg = PALETTE.fg },
      DashboardFooter = { fg = PALETTE.purple, italic = true },
      DashboardKey = { fg = PALETTE.orange },
      DashboardDesc = { fg = PALETTE.cyan },
      DashboardIcon = { fg = PALETTE.cyan, bold = true },

      -- dap UI
      DapUIPlayPause = { fg = PALETTE.bright_green },
      DapUIRestart = { fg = PALETTE.green },
      DapUIStop = { fg = PALETTE.red },
      DapUIStepOver = { fg = PALETTE.cyan },
      DapUIStepInto = { fg = PALETTE.cyan },
      DapUIStepOut = { fg = PALETTE.cyan },
      DapUIStepBack = { fg = PALETTE.cyan },
      DapUIType = { fg = PALETTE.bright_blue },
      DapUIScope = { fg = PALETTE.bright_cyan },
      DapUIModifiedValue = { fg = PALETTE.bright_cyan, bold = true },
      DapUIDecoration = { fg = PALETTE.bright_cyan },
      DapUIThread = { fg = PALETTE.bright_green },
      DapUIStoppedThread = { fg = PALETTE.bright_cyan },
      DapUISource = { fg = PALETTE.bright_blue },
      DapUILineNumber = { fg = PALETTE.bright_cyan },
      DapUIFloatBorder = { fg = PALETTE.bright_cyan },
      DapUIWatchesEmpty = { fg = PALETTE.pink },
      DapUIWatchesValue = { fg = PALETTE.bright_green },
      DapUIWatchesError = { fg = PALETTE.pink },
      DapUIBreakpointsPath = { fg = PALETTE.bright_cyan },
      DapUIBreakpointsInfo = { fg = PALETTE.bright_green },
      DapUIBreakpointsCurrentLine = { fg = PALETTE.bright_green, bold = true },
      DapStoppedLine = { default = true, link = 'Visual' },
      DapUIWinSelect = { fg = PALETTE.bright_cyan, bold = true },

      -- Notify
      NotifyInfoIcon = { fg = PALETTE.green },
      NotifyInfoTitle = { fg = PALETTE.green },
      NotifyInfoBorder = { fg = "#2C453F" },
      NotifyErrorIcon = { fg = PALETTE.red },
      NotifyErrorTitle = { fg = PALETTE.red },
      NotifyErrorBorder = { fg = "#DD6E6B" },
      NotifyWarnIcon = { fg = PALETTE.orange },
      NotifyWarnTitle = { fg = PALETTE.orange },
      NotifyWarnBorder = { fg = "#785637" },
    }
end

local function apply_term_colors(colors)
   g.terminal_color_0 = PALETTE.black
   g.terminal_color_1 = PALETTE.red
   g.terminal_color_2 = PALETTE.green
   g.terminal_color_3 = PALETTE.yellow
   g.terminal_color_4 = PALETTE.purple
   g.terminal_color_5 = PALETTE.pink
   g.terminal_color_6 = PALETTE.cyan
   g.terminal_color_7 = PALETTE.white
   g.terminal_color_8 = PALETTE.selection
   g.terminal_color_9 = PALETTE.bright_red
   g.terminal_color_10 = PALETTE.bright_green
   g.terminal_color_11 = PALETTE.bright_yellow
   g.terminal_color_12 = PALETTE.bright_blue
   g.terminal_color_13 = PALETTE.bright_magenta
   g.terminal_color_14 = PALETTE.bright_cyan
   g.terminal_color_15 = PALETTE.bright_white
   g.terminal_color_background = PALETTE.bg
   g.terminal_color_foreground = PALETTE.fg
end

--- override colors with colors
---@param groups HighlightGroups
---@param overrides HighlightGroups
---@return HighlightGroups
local function override_groups(groups, overrides)
   for group, setting in pairs(overrides) do
      groups[group] = setting
   end
   return groups
end

---apply my-theme colorscheme
---@param DEFAULT_CONFIG MyThemeConfig
local function apply()
   apply_term_colors(colors)
   local groups = get_groups(DEFAULT_CONFIG)

   -- apply transparents
   if DEFAULT_CONFIG.transparent_bg then
      for _, group in ipairs(TRANSPARENTS) do
         groups[group].bg = nil
      end
   end

   if type(DEFAULT_CONFIG.overrides) == "table" then
      groups = override_groups(groups, DEFAULT_CONFIG.overrides --[[@as HighlightGroups]])
   elseif type(DEFAULT_CONFIG.overrides) == "function" then
      groups = override_groups(groups, DEFAULT_CONFIG.overrides(colors))
   end

   -- set defined highlights
   for group, setting in pairs(groups) do
      nvim_set_hl(0, group, setting)
   end
end

---load my-theme colorscheme
local function load()
   -- reset colors
   if g.colors_name then
      cmd("hi clear")
   end

   if vim.fn.exists("syntax_on") then
      cmd("syntax reset")
   end

   o.background = "dark"
   o.termguicolors = true
   g.colors_name = 'my-theme'

   apply()
end

load()
