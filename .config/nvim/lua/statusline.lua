-- Statusline / tabline (replaces vim-airline)
require("lualine").setup({
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    -- per-window statusline, matching airline + laststatus=2
    globalstatus = false,
    disabled_filetypes = { statusline = { "NvimTree", "packer" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      -- airline#extensions#branch#displayed_head_limit = 30
      { "branch", fmt = function(name) return name:sub(1, 30) end },
      "diff",
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      },
    },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {
    -- airline tabline: buffers with ordinal index + tab numbers
    lualine_a = { { "buffers", mode = 2 } },
    lualine_z = { "tabs" },
  },
  -- Tailored statuslines for special-purpose windows
  extensions = {
    "nvim-tree",
    "fugitive",
    "fzf",
    "symbols-outline",
    "trouble",
    "quickfix",
  },
})
