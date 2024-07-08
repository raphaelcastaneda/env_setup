return {

	{
  "hedyhli/outline.nvim",
  config = function(plugin)
    vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
      { desc = "Toggle Outline" })
    require("outline").setup {
      {
        keymaps = {
          close = { "<Esc>", "q", "o" },
          code_actions = "a",
          fold = { "h", "x" },
          fold_all = "X",
          fold_reset = "R",
          goto_location = "<Cr>",
          hover_symbol = "K",
          peek_location = "<space>",
          rename_symbol = "r",
          toggle_preview = "P",
          unfold = { "e", "l" },
          unfold_all = "E"
        },
        outline_window = {
          show_cursorline = true,
          hide_cursor = true,
        },
        symbols = {
          icon_source = 'lspkind',
          icons = {
            Array = {
              hl = "TSConstant",
              icon = " "
            },
            Boolean = {
              hl = "TSBoolean",
              icon = "󱨦 "
            },
            Class = {
              hl = "TSType",
              icon = " "
            },
            Constant = {
              hl = "TSConstant",
              icon = " "
            },
            Constructor = {
              hl = "TSConstructor",
              icon = " "
            },
            Enum = {
              hl = "TSType",
              icon = " "
            },
            EnumMember = {
              hl = "TSField",
              icon = " "
            },
            Event = {
              hl = "TSType",
              icon = ""
            },
            Field = {
              hl = "TSField",
              icon = " "
            },
            File = {
              hl = "TSURI",
              icon = " "
            },
            Function = {
              hl = "TSFunction",
              icon = ""
            },
            Interface = {
              hl = "TSType",
              icon = " "
            },
            Key = {
              hl = "TSType",
              icon = " "
            },
            Method = {
              hl = "TSMethod",
              icon = "󰡱 "
            },
            Module = {
              hl = "TSNamespace",
              icon = " "
            },
            Namespace = {
              hl = "TSNamespace",
              icon = " "
            },
            Null = {
              hl = "TSType",
              icon = "󰟢"
            },
            Number = {
              hl = "TSNumber",
              icon = " "
            },
            Object = {
              hl = "TSType",
              icon = " "
            },
            Operator = {
              hl = "TSOperator",
              icon = " "
            },
            Package = {
              hl = "TSNamespace",
              icon = " "
            },
            Property = {
              hl = "TSMethod",
              icon = " "
            },
            String = {
              hl = "TSString",
              icon = "𝓐 "
            },
            Struct = {
              hl = "TSType",
              icon = " "
            },
            TypeParameter = {
              hl = "TSParameter",
              icon = "𝙏"
            },
            Variable = {
              hl = "TSConstant",
              icon = " "
            }
          }
        }
      }
    }
  end,
  dependencies = {
    'onsails/lspkind.nvim',
  }

},
}
