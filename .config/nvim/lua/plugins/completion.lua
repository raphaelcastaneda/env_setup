return {
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  --{ "folke/neodev.nvim" }, --Lua autocompletion for nvim api DEPRECATED
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  }, -- New completion setup for nvim development
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  { "rafamadriz/friendly-snippets" }, -- Snippet definitions
  { "saadparwaiz1/cmp_luasnip" },   -- Snipppet completion source
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      
    }
  }, -- Snippet Engine
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      'windwp/nvim-autopairs',
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
    config = function()
      -- Main cmp setup

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      --require("luasnip.loaders.from_vscode").load({ paths = { "./bundle/friendly-snippets" } })
      local cmp = require 'cmp'
      --local types = require("cmp.types")
      -- local str = require("cmp.utils.str")
      local lspkind = require('lspkind')

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local tab_key = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete({ reason = cmp.ContextReason.Auto })
        else
          fallback()
        end
      end, {
        "i",
        "c",
        "s"
      })

      local stab_key = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "c", "s" })

      local c_space = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.complete_common_string({ reason = cmp.ContextReason.Auto })
        else
          cmp.complete({ reason = cmp.ContextReason.Auto })
        end
      end, { "i", "c" })
      local my_mapping = {
        ["<Tab>"] = tab_key,
        ["<S-Tab>"] = stab_key,
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<C-n>'] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end
        }),
        ['<C-p>'] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end
        }),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = c_space,
        ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        ['<CR>'] = cmp.mapping({
          i = function(fallback)
            if cmp.get_selected_entry() ~= nil then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          c = function(fallback)
            if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end
        }),
      }

      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        preselect = "item",
        mapping = my_mapping,
        completion = {
          autocomplete = false,
        },
        window = {

          completion = {
            max_height = 30,
            autocomplete = false,
            -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None,Selected:PmenuSel",
            col_offset = -3,
            side_padding = 0,
            scrollbar = false,
          }
        },
        formatting = {
          expandable_indicator = true,
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Highlight any color codes (e.g. hex, or RGB ) within the complletion candidate
            local color_item = require("nvim-highlight-colors").format(entry, { kind = vim_item.kind })

            -- let lspkind insert type icons and formatting
            local item = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
              -- symbol_map = { Codeium = "", },
              view = {
                entries = { name = "custom", selection_order = "near_cursor" }

              },
              --  menu = ({
              --    buffer = "[Buffer]",
              --    nvim_lsp_signature_help = "[Sig]",
              --    nvim_lsp_document_symbol = "[Doc]",
              --    treesitter = "[Tree]",
              --    nvim_lsp = "[LSP]",
              --    luasnip = "[LuaSnip]",
              --    nvim_lua = "[Lua]",
              --    latex_symbols = "[Latex]",
              --  }),
            })(entry, vim_item)
            local strings = vim.split(item.kind, "%s", { trimempty = true })
            item.kind = " " .. (strings[1] or "") .. " "
            item.menu = "    " .. (strings[2] or "") .. "    " .. (item.menu or "")

            -- Overwrite the highlighting with the colorized version
            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = color_item.abbr
            end
            return item
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp_signature_help' },
          --{ name = 'codeium' }, -- AI suggestions
          { name = 'nvim_lsp' },
          -- { name = 'vsnip' }, -- For vsnip users.
          { name = 'luasnip' }, -- For luasnip users.
          --{ name = 'nvim_lsp_document_symbol' },
          -- { name = 'treesitter' },
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          -- { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- Use buffer source for `/`.
      cmp.setup.cmdline('/', {
        completion = {
          autocomplete = {}
        },
        sources = cmp.config.sources({
          -- { name = 'treesitter' },
          { name = 'nvim_lsp_document_symbol' },
          { name = 'buffer' }
        }),
        -- formatting = {
        --   menu = ({
        --     buffer = "[Buffer]",
        --     nvim_lsp_document_symbol= "[Doc]",
        --     treesitter = "[Tree]",
        --     nvim_lsp = "[LSP]",
        --     luasnip = "[LuaSnip]",
        --     nvim_lua = "[Lua]",
        --     latex_symbols = "[Latex]",
        --   }),
        -- }
      })
      -- Use cmdline & path source for ':'.
      cmp.setup.cmdline(':', {
        completion = {
          autocomplete = {}
        },
        mapping = my_mapping,
        sources = cmp.config.sources({
          { name = 'cmdline' },
          { name = 'path' }
        }),
      })
      --
      -- Configure autopairs to work with cmp
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      local capabilities = {}
      require('cmp_nvim_lsp').default_capabilities()



    end,



  },
}
