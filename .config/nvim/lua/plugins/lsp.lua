return {

-- Eye Candy
{ "Maan2003/lsp_lines.nvim",
  config = function(plugin)
    require("lsp_lines").setup()
  end
},
{ "onsails/lspkind.nvim" },
{
  "nvimdev/lspsaga.nvim",
  --commit = "2198c07124bef27ef81335be511c8abfd75db933",
  config = function(plugin)
    require("lspsaga").setup({
      --use_saga_diagnostic_sign = false,
      finder_request_timeout = 15000,
      max_preview_lines = 40,
      ui = {
        code_action = " ",
      },
      lightbulb = {
        enable_in_insert = false,
        sign = false,
        virtual_text = true,
      },
      finder = {
        keys = {
          toggle_or_open = { '<CR>', '<space>' },
          vsplit = 's',
          split = 'i',
          quit = { 'q', '<Esc>' }, -- quit can be a table
          scroll_down = '<C-f>',
          scroll_up = '<C-b>'
        },
      }
    })
  end,
  dependencies = {
      "nvim-tree/nvim-web-devicons",
      "neovim/nvim-lspconfig"
    }
  }, -- Fancy interface for LSP functions


-- Language servers and tools
  { "nvimtools/none-ls.nvim" },                               -- Community-maintained fork of null-ls which is a wrapper for non lsp compatible linters etc
  { "MunifTanjim/prettier.nvim" },                                                                                    -- Formatter for JS etc.
{ "williamboman/mason.nvim" }, -- LSP package manager
{ "williamboman/mason-lspconfig.nvim" },
{ "mfussenegger/nvim-dap" }, -- Debuggers for LSP
{ "jay-babu/mason-nvim-dap.nvim" },


-- Appearance
{ "folke/lsp-colors.nvim", lazy = false,
  config = function(plugin)
    require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
  })
  end
 },
{ "folke/trouble.nvim",
  config = function(plugin)
  require("trouble").setup {
      multiline = true, -- render multi-line messages
      indent_lines = true, -- add an indent guide below the fold icons
      win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
      auto_open = false, -- automatically open the list when you have diagnostics
      auto_close = false, -- automatically close the list when you have no diagnostics
      auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
      auto_fold = false, -- automatically fold a file trouble list at creation 
      signs = {
          error = " ",
          warning = " ",
          hint = " ",
          information = " " ,
          other = "󱐋 "
          },
      }
  end,
  cmd = "Trouble",

},


}
