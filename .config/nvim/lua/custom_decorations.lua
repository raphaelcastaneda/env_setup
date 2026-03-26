local highlight = {
  "RainbowViolet",
  "RainbowBlue",
  "RainbowCyan",
  "RainbowGreen",
  "RainbowYellow",
  "RainbowOrange",
  "RainbowRed",
}


-- Integration with indent-blankline
local hooks = require("ibl.hooks")
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


vim.g.rainbow_delimiters = {
  strategy = {
    [''] = 'rainbow-delimiters.strategy.global',
    lua = 'rainbow-delimiters.strategy.global',
    python = 'rainbow-delimiters.strategy.global',
  },
  query = {
    [''] = 'rainbow-delimiters',
    lua = 'rainbow-blocks',
  },
  highlight = highlight,
}
require("rainbow-delimiters.setup").setup(vim.g.rainbow_delimiters)

require("ibl").setup {
  whitespace = {
    highlight = {"CursorLine", "WhiteSpace" },
    remove_blankline_trail = false,
  },
  -- indent = {
  --   highlight = highlight,
  -- },
  scope = {
    enabled = true,
    highlight = highlight,
    show_start = false,
    show_end = false,
    include = {
      node_type = {
        lua = { "*" },
        json = { "*" },
        bash = { "block" },
        python = { "*" },
        -- python = {
        --   "function_definition","class_definition","if_statement","elif_clause","else_clause",
        --   "for_statement","while_statement","with_statement","try_statement",
        --   "except_clause","finally_clause","match_statement","case_clause","block",
        -- },
      },
    }
  },
}

vim.schedule(function()
  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end)
