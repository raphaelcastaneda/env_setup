-- This module contains a number of default definitions
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
  strategy = {
    [''] = rainbow_delimiters.strategy['global'],
    vim = rainbow_delimiters.strategy['local'],
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = {
    'RainbowRed',
    'RainbowYellow',
    'RainbowBlue',
    'RainbowOrange',
    'RainbowGreen',
    'RainbowViolet',
    'RainbowCyan',
  },
}


-- Integration with indent-blankline
local highlight = {
  "RainbowViolet",
  "RainbowBlue",
  "RainbowCyan",
  "RainbowGreen",
  "RainbowYellow",
  "RainbowOrange",
  "RainbowRed",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#E09A66" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56C6C2" })
  vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61A0EF" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup {
  -- whitespace = {
  --   highlight = highlight,
  --   remove_blankline_trail = false,
  -- },
  scope = {
    highlight = highlight,
    show_start = false,
    show_end = false,
    include = {
      node_type = {
        lua = { "*" },
        json = { "*" },
        bash = { "block" },
      }
    }
  },
}

hooks.register(
  hooks.type.SCOPE_HIGHLIGHT,
  hooks.builtin.scope_highlight_from_extmark
  )
