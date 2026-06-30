-- lspconfig global config
-- local lspconfig = require 'lspconfig'
-- lspconfig.util.default_config = vim.tbl_extend(
--   "force",
--   lspconfig.util.default_config,
--   { log_level = vim.lsp.protocol.MessageType.Error }
-- )
--
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "tsx",
    "typescript",
    "vim",
    "yaml"
  },
  ignore_install = { "phpdoc" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "vn",
      node_incremental = "v,",
      scope_incremental = "v]",
      node_decremental = "v<",
    },
  },
})

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  virtual_lines = false,
  severity_sort = true,
})
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,
    -- virtual_lines = false,
    -- virtual_lines = { only_current_line = true },
    -- virtual_text = {
    -- prefix = " ",
    -- },
    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,
    underline = true,
    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

-- Setup nvim-cmp.
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
      local kind = require("lspkind").cmp_format({
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
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    " .. (strings[2] or "") .. "    " .. (kind.menu or "")

      return kind
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
cmp.setup.cmdline({ '/', '?' }, {
  completion = {
    mapping = cmp.mapping.preset.cmdline(),
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
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    { name = 'path' }
  }
  ),

  matching = { disallow_symbol_nonprefix_matching = false },
})

-- Configure autopairs to work with cmp
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)



-- -- nvim-cmp as omnifunc
-- _G.vimrc = _G.vimrc or {}
-- _G.vimrc.cmp = _G.vimrc.cmp or {}
-- _G.vimrc.cmp.lsp = function()
--   cmp.complete({
--     config = {
--       sources = {
--         { name = 'nvim_lsp' }
--       }
--     }
--   })
-- end
-- _G.vimrc.cmp.snippet = function()
--   cmp.complete({
--     config = {
--       sources = {
--         { name = 'ultisnips' }
--       }
--     }
--   })
-- end

-- vim.cmd([[
--   inoremap <C-x><C-o> <Cmd>lua vimrc.cmp.lsp()<CR>
--   inoremap <C-x><C-s> <Cmd>lua vimrc.cmp.snippet()<CR>
-- ]])
--
-- Declare Diagnostic Symbols
-- local signs = {
--   Error = " ",
--   Warn = " ",
--   Warning = " ",
--   Hint = " ",
--   Info = " ",
--   Information = " ",
--   Other = " "
-- }
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN] = "Warn",
      [vim.diagnostic.severity.INFO] = "Info",
      [vim.diagnostic.severity.HINT] = "Hint",
    },
  },
})

-- Create custom on_attach function
local custom_on_attach = function(client, bufnr)
  -- log to make sure we know we got here
  print("LSP server attached: " .. client.name)
  if vim.bo.filetype == "NerdTree" then
    vim.lsp.buf_detach_client(bufnr, client)
  end
  --  print("LSP server attached: " .. client.name)



  local map = function(type, key, value)
    vim.api.nvim_buf_set_keymap(bufnr, type, key, value, { noremap = true, silent = true });
  end

  -- Mappings.
  map('n', '<leader>D', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
  --   map('n','K','<cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', '<leader>u', '<cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '<leader>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  map('n', '<leader>gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  --   map('n','<leader>gW','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  --   map('n','<leader>af','<cmd>lua vim.lsp.buf.code_action()<CR>')
  --   map('n','<leader>e','<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
  --   map('n','<leader>r','<cmd>lua vim.lsp.buf.rename()<CR>')
  map('n', '<leader>=', '<cmd>lua vim.lsp.buf.format({async=true})<CR>')
  map('x', '<leader>=', '<cmd>lua vim.lsp.buf.format({async=true})<CR>')
  -- map('n', '<leader>ai', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  -- map('n', '<leader>ao', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')

  -- map('n', 'tb', '<cmd>SymbolsOutline<CR>')
  map('n', '<leader>o', '<cmd>Trouble toggle symbols win.type=split win.relative=win position=right focus=true<CR>')

  map('n', 'ej', '<cmd>Lspsaga diagnostic_jump_next<CR>')
  map('n', 'ek', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
  map('n', 'gh', '<cmd>Lspsaga finder tyd+imp+ref+def<CR>')
  -- map('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>')
  map('n', 'gd', '<cmd>Lspsaga peek_definition<CR>')
  map('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
  map('n', '<leader>`', '<cmd>Lspsaga term_toggle<CR>')
  map('n', '<leader>a', '<cmd>Lspsaga code_action<CR>')
  map('n', '<leader>r', '<cmd>Lspsaga rename<CR>')
  map('n', '<leader>x', '<cmd>Lspsaga show_line_diagnostics<CR>')

  --vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil,{focusable=false,scope="cursor"})]])



  -- Set autocommands conditional on server_capabilities

  --hi LspReferenceText cterm=bold ctermbg=235 gui=underline guibg=#585c63
  --  if vim.bo.filetype ~= 'vimwiki' and client.server_capabilities.documentHighlightProvider then
  --    vim.api.nvim_exec([[
  --        hi LspReferenceRead cterm=bold ctermbg=235 gui=underline guibg=#58635b
  --        hi LspReferenceText cterm=bold ctermbg=235 gui=underline guibg=#585c63
  --        hi LspReferenceWrite cterm=bold ctermbg=235 gui=underline guibg=#635858
  --
  --        augroup lsp_document_highlight
  --          autocmd!
  --          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --        augroup END
  --      ]], false)
  --  end
end

require("symbols-outline").setup({
  symbols = {
    File = { icon = " ", hl = "TSURI" },
    Module = { icon = " ", hl = "TSNamespace" },
    Namespace = { icon = " ", hl = "TSNamespace" },
    Package = { icon = " ", hl = "TSNamespace" },
    Class = { icon = " ", hl = "TSType" },
    Method = { icon = "󰡱 ", hl = "TSMethod" },
    Property = { icon = " ", hl = "TSMethod" },
    Field = { icon = " ", hl = "TSField" },
    Constructor = { icon = " ", hl = "TSConstructor" },
    Enum = { icon = " ", hl = "TSType" },
    Interface = { icon = " ", hl = "TSType" },
    Function = { icon = "", hl = "TSFunction" },
    Variable = { icon = " ", hl = "TSConstant" },
    Constant = { icon = " ", hl = "TSConstant" },
    String = { icon = "𝓐 ", hl = "TSString" },
    Number = { icon = " ", hl = "TSNumber" },
    Boolean = { icon = "󱨦 ", hl = "TSBoolean" },
    Array = { icon = " ", hl = "TSConstant" },
    Object = { icon = " ", hl = "TSType" },
    Key = { icon = " ", hl = "TSType" },
    Null = { icon = "󰟢", hl = "TSType" },
    EnumMember = { icon = " ", hl = "TSField" },
    Struct = { icon = " ", hl = "TSType" },
    Event = { icon = "", hl = "TSType" },
    Operator = { icon = " ", hl = "TSOperator" },
    TypeParameter = { icon = "𝙏", hl = "TSParameter" }
  },
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = { "<Esc>", "q", "o" },
    goto_location = "<Cr>",
    focus_location = "<space>",
    hover_symbol = "K",
    toggle_preview = "P",
    rename_symbol = "r",
    code_actions = "a",
    fold = { "h", "x" },
    unfold = { "e", "l" },
    fold_all = "X",
    unfold_all = "E",
    fold_reset = "R",
  },
})
require("lsp_lines").setup()

-- Telescope finder config
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      ".git/",
      "node_modules/",
      ".cache/",
      "venv/",
      ".venv/",
      "__pycache__/",
      ".pytest_cache/",
      ".mypy_cache/",
      ".vscode/",
      ".conda/",
      ".codeium/",
      ".colima",
      ".docker",
      "go/bin/",
      "go/pkg/",
      "miniforge3/"
    },
  },
})

-- Configure language servers

-- treesitter based refactoring
-- local refactoring = require('refactoring')
-- require("telescope").load_extension("refactoring")
-- refactoring.setup({})
-- vim.keymap.set(
--   { "n", "x" },
--   "<leader>R",
--   function() require('telescope').extensions.refactoring.refactors() end
-- )
-- vim.keymap.set({ "n" }, "<leader>p", function() refactoring.debug.print_var({}) end)
-- vim.keymap.set({ "n" }, "<leader>P", function() refactoring.debug.cleanup({}) end)

-- null-ls
local null_ls = require("null-ls")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

local null_ls_sources = {
  --code_actions.eslint_d,
  --code_actions.gitsigns,
  --code_actions.refactoring,
  -- code_actions.shellcheck,
  completion.spell.with({
    filetypes = { "markdown", "vimwiki" },
  }),
  diagnostics.alex.with({
    filetypes = { "markdown", "vimwiki" },
    diagnostic_config = {
      update_in_insert = false,
      virtual_text = false,
    },
  }),
  --diagnostics.flake8.with {
  --  extra_args = {
  --    "--ignore=E126,D100,D101,D102,D103,D205,D400,D401",
  --    "--max-line-length=160",
  --    "--max-complexity=10",
  --  },
  --  diagnostic_config = {
  --    virtual_text = false,
  --  },
  --},
  -- diagnostics.pylint.with {
  --   diagnostic_config = {
  --     virtual_text = false,
  --   },
  -- },
  -- diagnostics.vulture.with {
  --   diagnostic_config = {
  --     virtual_text = false,
  --   },
  -- },
  --null_ls.builtins.diagnostics.buf,
  diagnostics.write_good.with({
    filetypes = { "markdown", "vimwiki" },
    extra_args = { "--no-tooWordy" },
    diagnostic_config = {
      virtual_text = false,
    },
    condition = function(utils)
      return utils.root_has_file({ "readme.md", "README.md", "index.md" })
    end,
  }),
  diagnostics.codespell.with({
    diagnostic_config = {
      virtual_text = false,
    },
  }),
  -- diagnostics.eslint_d.with({
  --      diagnostic_config = {
  --          virtual_text = false,
  --      },
  --  }),
  null_ls.builtins.diagnostics.protolint,
  -- diagnostics.shellcheck.with({
  --     diagnostic_config = {
  --         virtual_text = false,
  --     },
  -- }),
  diagnostics.yamllint.with({
    diagnostic_config = {
      virtual_text = false,
    },
  }),
  formatting.buf,
  formatting.isort,
  formatting.prettierd,
  -- formatting.prettierd.with({
  --   filetypes = { "css", "scss", "less", "html", "json", "jsonc", "yaml", "markdown", "markdown.mdx", "graphql", "handlebars" }
  -- }),
  --formatting.eslint_d,
  formatting.shellharden,
  formatting.yamlfmt,
  hover.dictionary,
  hover.printenv,
}


-- local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- Use an autocommand to call the function when an LSP client attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    custom_on_attach(client, bufnr)
  end,
})

-- local null_ls = require("null-ls")
-- local prettier = require("prettier")
-- null_ls.setup({
--   on_attach = on_attach,
--   sources = {
--     null_ls.builtins.formatting.prettier -- prettier, eslint, eslint_d, or prettierd
--   }
-- })
-- prettier.setup({
--   bin = "prettier",
--   capabilities = capabilities,
--   on_attach = on_attach,
--   filetypes = {
--     "css",
--     "graphql",
--     "html",
--     "javascript",
--     "javascriptreact",
--     "json",
--     "less",
--     "markdown",
--     "scss",
--     "typescript",
--     "typescriptreact",
--     "yaml",
--   }
-- })

require("neodev").setup({})

local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
local util = require 'lspconfig.util'
local servers = {
  bashls = {},
  -- buf_ls = {
  --   cmd = { "buf", "beta", "lsp", "--timeout=0", "--log-format=text" },
  --   env = {
  --     BUF_BETA_SUPPRESS_WARNINGS = 1
  --   },
  --   filetypes = { 'proto' }
  -- },
  buf_ls = {},
  clangd = {
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }
  },
  dockerls = {},
  --flow = {},
  -- golangci_lint_ls = {
  --     cmd = { 'golangci-lint-langserver' },
  --     filetypes = { 'go', 'gomod' },
  --     init_options = {
  --         command = { 'golangci-lint', 'run', '--enable-all', '--disable', 'lll', '--out-format', 'json' },
  --     },
  -- },
  gopls = {
    filetypes = { "go", "gomod" },
    flags = { debounce_text_changes = 150 },
    settings = {
      gopls = {
        gofumpt = true,
        buildFlags = { "-tags=engineering" }
      },
      ui = {
        completion = {
          usePlaceholders = true
        }
      }
    }
  },
  ruff = {},
  golangci_lint_ls = {
    root_dir = util.root_pattern('go.mod', '.git'),
    handlers = {
      -- stops an out-of-range column error when viewing diagnostics with Trouble.nvim
      ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
        for idx, diag in ipairs(result.diagnostics) do
          for position, value in pairs(diag.range) do
            if value.character == -1 then
              result.diagnostics[idx].range[position].character = 0
            end
          end
        end

        return on_publish_diagnostics(_, result, ctx, config)
      end,
    }
  },
  html = {},
  pyright = {
    cmd = { "pyright-langserver", "--stdio", "-v", os.getenv("VIRTUAL_ENV") },
    root_dir = util.root_pattern({
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "pyproject.toml",
      "README.md",
      "pyrightconfig.json",
      "Pipfile",
      ".git",
    }),
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = "warning",
            reportOptionalMemberAccess = "warning",
            reportPrivateImportUsage = "warning",
          },
        }
      }
    }
  },
  vimls = {},
  yamlls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        }
      }
    }
  },
  marksman = {
    filetypes = { "markdown", "vimwiki" }
  },
  ts_ls = {},
  jdtls = {
    root_dir = util.root_pattern({
      "gradlew",
      ".git",
      "mvnw",
      "pom.xml",
    })
  },
  jsonls = {
    settings = {
      json = {
        schemas = {
          {
            fileMatch = { 'package.json' },
            url = 'https://json.schemastore.org/package.json',
          },
          {
            fileMatch = { 'tsconfig.json', 'tsconfig.*.json' },
            url = 'http://json.schemastore.org/tsconfig',
          },
          {
            fileMatch = { ".vimspector.json" },
            url = "https://puremourning.github.io/vimspector/schema/vimspector.schema.json"
          },
          {
            fileMatch = { ".gadgets.json", ".gadgets.d/*.json" },
            url = "https://puremourning.github.io/vimspector/schema/gadgets.schema.json"
          }
        },
      },
    }
  }
}

require("mason").setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})


-- new mason-lspconfig 2.0 doesn't do handlers, so we have to loop over each server and configure it

-- Broadcast cmp capabilities globally
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
})

local default_configs = require('lspconfig.configs')


for servername, sconfig in pairs(servers) do
  local default_config = default_configs[servername]
  if default_config then
    local final_config = vim.tbl_deep_extend('force', default_config.default_config, sconfig)
    vim.lsp.config(servername, final_config)
  end
  vim.lsp.enable(servername)
end

require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = false
})

require("mason-nvim-dap").setup();

-- null_ls.setup({
--   debug = false,
--   on_attach = on_attach,
--   sources = null_ls_sources,
--   capabilities = capabilities,
-- })

