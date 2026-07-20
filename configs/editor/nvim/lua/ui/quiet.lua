local palette = {
  ["primary"] = "#DFE0DC",
  ["primary_dark"] = "#888888",
  ["accent"] = "#F6C177",
  ["red"] = "#EB6F92",
  ["blue"] = "#9CCFD8",
  ["dark_tab"] = "#2E2929",
  ["black"] = "#111111",
  ["gray1"] = "#6F6262",
}

function HL(name, set)
  vim.api.nvim_set_hl(0, name, set)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "quiet" }, -- or a specific scheme name like "gruvbox"
  callback = function()
    HL("Normal", { fg = palette.primary })

    HL("Comment", { fg = palette.primary_dark })
    HL("@comment", { link = "Comment" })
    HL("rustCommentLineDoc", { link = "Comment" })
    HL("LineNr", { link = "Comment" })
    HL("LineNrAbove", { link = "Comment" })
    HL("LineNrBelow", { link = "Comment" })

    HL("Directory", { fg = palette.accent })
    HL("String", { fg = palette.accent })
    HL("@string", { link = "String" })
    HL("TODO", { fg = palette.red })
    HL("MatchParen", { fg = palette.red })

    HL("MiniTablineCurrent", { bg = palette.dark1, fg = palette.accent })
    HL("MiniTablineHidden", { bg = palette.black, fg = palette.primary })
    HL("MiniTablineVisible", { bg = palette.black, fg = palette.primary_dark })
    HL(
      "MiniTablineModifiedCurrent",
      { bg = palette.primary, fg = palette.black }
    )
    HL(
      "MiniTablineModifiedVisible",
      { bg = palette.gray1, fg = palette.primary_dark }
    )
    HL("MiniTablineModifiedHidden", { bg = palette.blue, fg = palette.black })

    vim.api.nvim_set_hl(
      0,
      "YankSystemClipboard",
      { bg = palette.red, fg = "#000000" }
    )

    HL("Visual", { bg = "#333333" })
    HL("QuickFixLine", { link = "Visual" })
    HL("NormalFloat", { bg = "#0A0A0A" })
    HL("StatusLine", { bg = "#111111" })
    HL("ColorColumn", { bg = "#222222" })

    vim.api.nvim_set_hl(
      0,
      "IncSearch",
      { bg = palette.primary, fg = "#000000" }
    )
    vim.api.nvim_set_hl(
      0,
      "Substitute",
      { bg = palette.primary, fg = "#000000" }
    )
  end,
})
