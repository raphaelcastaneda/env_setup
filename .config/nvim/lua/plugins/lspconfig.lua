return {
  { "williamboman/mason.nvim" }, -- LSP package manager
  { "williamboman/mason-lspconfig.nvim" },
  { "mfussenegger/nvim-dap" }, -- Debuggers for LSP
  { "jay-babu/mason-nvim-dap.nvim" },
  {
    "nvimtools/none-ls.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvimtools/none-ls.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "mfussenegger/nvim-dap",
       "nvimtools/none-ls.nvim",

    },
    config = function(plugin)
      local lsp_config = require 'lspconfig'
      lsp_config.util.default_config = vim.tbl_extend(
        "force",
        lsp_config.util.default_config,
        { log_level = vim.lsp.protocol.MessageType.Error }
      )
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
      -- Configure neovim Diagnostics
      local sign_text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        --Warning = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }

      -- for type, icon in pairs(signs) do
      --   local hl = "DiagnosticSign" .. type
      --   sign_config.text[hl] = icon
      --   sign_config.texthl[hl] = hl
      --   sign_config.numhl[hl] = ""
      --   -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      -- end
      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        virtual_lines = false,
        severity_sort = true,
        signs = {
          text = sign_text
        }
      })

      -- Create custom on_attach function
      local on_attach = function(client, bufnr)
        if vim.bo.filetype == "NvimTree" then
          vim.lsp.buf_detach_client(bufnr, client)
        end


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

        if client.name == "tsserver" then
          client.server_capabilities.documentFormattingProvider = false
        end
      end

      local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
      local util = require 'lspconfig.util'

      local capabilities = {}
      local null_ls = require("null-ls")
      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting
      local hover = null_ls.builtins.hover
      local completion = null_ls.builtins.completion

      -- Individual server settings
      local servers = {
        bashls = {},
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
          cmd = { "pyright-langserver", "--stdio", "-v", "$VIRTUAL_ENV" },
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
        markdownlint = {
          filetypes = { "markdown", "vimwiki" }
        },
        -- marksman = {
        --   filetypes = { "markdown" }
        -- },
        tsserver = {},
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

      require("mason-lspconfig").setup_handlers({
        function(server_name) -- default handler
          if servers[server_name] ~= nil and server_name ~= "null-ls"
          then
            servers[server_name]['capabilities'] = capabilities
            servers[server_name]['on_attach'] = on_attach
            lsp_config[server_name].setup(servers[server_name])
          else
            lsp_config[server_name].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end
        end,
      
      })
      require("mason-nvim-dap").setup()

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
        formatting.black.with({
            diagnostic_config = {
                extra_args = { "--line-length", "88" },
            }
        }),
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

      null_ls.setup({
        debug = false,
        on_attach = on_attach,
        sources = null_ls_sources,
        capabilities = capabilities,
      })
    end
  },
}
