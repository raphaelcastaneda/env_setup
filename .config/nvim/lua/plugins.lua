local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- Prereqs and helpers
  use({ "inkarkat/vim-ingo-library" })
  use({ "nvim-lua/plenary.nvim" })   -- Prereq for telescope, null-ls, and refactoring
  use({ "mfussenegger/nvim-jdtls" }) --Extensions for built-in LSP
  use({
    "lukas-reineke/indent-blankline.nvim",
    tag = "v3.8.1",
  })                                  -- Indentation guides to enhance listchars
  use({ "dstein64/vim-startuptime" }) -- vim startup profiler

  -- Finders and Search
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x",
    requires = { { 'nvim-lua/plenary.nvim' } }
  })
  use { 'nvim-telescope/telescope-fzf-native.nvim', run =
  'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use({ "ervandew/ag" })
  use({ "junegunn/fzf.vim", requires = { "junegunn/fzf", run = ":call fzf#install()" } })

  -- IDE quality of life
  use({ "simrat39/symbols-outline.nvim" })
  use({ "scrooloose/nerdcommenter" })
  use({ "lewis6991/gitsigns.nvim" })
  use({
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup({
        build_position_cb = function(plist, _, _, _)
          require("scrollbar.handlers.search").handler.show(plist.start_pos)
        end,
      })

      vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
    end,
  })
  use({
    "petertriho/nvim-scrollbar",
    requires = { 'kevinhwang91/nvim-hlslens' },
    config = function()
      require('scrollbar').setup()
      require("scrollbar.handlers.search").setup()
      require('gitsigns').setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  })
  use({ "HiPhish/rainbow-delimiters.nvim" }) -- Color-coded parens, brackets etc.
  use({ "tpope/vim-fugitive" })
  use({ "nvim-tree/nvim-tree.lua" })
  use({ "folke/which-key.nvim" }) --Lua autocompletion for nvim api
  use({
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = function()
      require("refactoring").setup({
        show_success_message = true,
      })
    end
  })
  use({ "tpope/vim-obsession" })                    -- Save and restore vim sessions
  use({ "tpope/vim-tbone" })                        -- Integration with tmux
  use({ "tpope/vim-surround" })                     -- Add, replace, change surrounds (quotes, brackets, etc)
  use({ "tpope/vim-sleuth" })                       -- Auto-detect tabstop and shiftwidth
  use({ "windwp/nvim-autopairs" })                  -- Insert closure when inserting an opener
  --use({ "jmcantrell/vim-virtualenv" })
  use({ "inkarkat/vim-SyntaxRange" })               -- Fenced syntax highlighting
  use({ "numtostr/BufOnly.nvim", cmd = "BufOnly" }) --Commands to close all other buffers
  -- use({ "vim-scripts/BufOnly.vim" " Commands for closing all other buffers })
  --use({ "posva/vim-vue" })

  -- LSP additions
  use({ "neovim/nvim-lspconfig" })
  use({ "Maan2003/lsp_lines.nvim" })
  use({ "onsails/lspkind.nvim" })
  use({
    "nvimdev/lspsaga.nvim",
    --commit = "2198c07124bef27ef81335be511c8abfd75db933",
    after = 'nvim-lspconfig',
    config = function()
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
    requires = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
  }) -- Fancy interface for LSP functions
  -- use({ "raphaelcastaneda/lspsaga.nvim", {"branch": "feature/finder-jump-by-number"} })
  -- use({ "tami5/lspsaga.nvim"  "A fork of lspsaga that is actually being maintained })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- Install and update Treesitter
  -- use({ "jose-elias-alvarez/null-ls.nvim" })                    -- Allows lsp support for non-lsp sources
  use({ "nvimtools/none-ls.nvim" })                             -- Community-maintained fork of null-ls

  -- CUSTOM PLUGINS - install things that we don't want in the dotfiles repo
  -- local private_plugins = require('private_plugins')
  -- if private_plugins then
  --   private_plugins(use)
  -- end

  -- use({ "martinda/Jenkinsfile-vim-syntax"})
  -- use({ "hashivim/vim-terraform" })
  use({ "puremourning/vimspector" })   -- Debugger based on json configs (like VSCode)
  --use({ "sagi-z/vimspectorpy", ft = "python", run = function() vim.fn['vimspectorpy#update'](0) end }) -- Debugger based on json configs (like VSCode)
  use({ "MunifTanjim/prettier.nvim" }) -- Formatter for JS etc.
  use({ "tpope/vim-dotenv" })
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "nvim-lua/plenary.nvim",
      -- antoinemadec/FixCursorHold.nvim",  -- supposedly no longer needed because nvim fixed the bug
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        summary = {
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            help = "?",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w"

          }
        },
        adapters = {
          require("neotest-go"),
          require("neotest-python")(
            {
              args = { "--log-level", "DEBUG", "-vv" },
              dap = { justMyCode = false },
              runner = "pytest",
              python = "python3",
              -- pytest_discover_instances = true, -- this is experimental and probably slow

            }
          ),
        },
      })
    end,
  }
  --  Completion and snippets
  use({ "hrsh7th/nvim-cmp", })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lua" })
  --  use({ "ray-x/cmp-treesitter" })
  use({ "folke/neodev.nvim" }) --Lua autocompletion for nvim api
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({ "hrsh7th/cmp-nvim-lsp-document-symbol" })
  use({ "nvim-lua/lsp-status.nvim" })
  use({ "rafamadriz/friendly-snippets" }) -- Snippet definitions
  use({ "saadparwaiz1/cmp_luasnip" })     -- Snipppet completion source
  use({ "L3MON4D3/LuaSnip" })             -- Snippet Engine
  --use({ "SirVer/ultisnips" })
  --use({ "honza/vim-snippets" })
  --use({ "hrsh7th/vim-vsnip" })
  --use({ "hrsh7th/vim-vsnip-integ" })
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "WhoIsSethDaniel/mason-tool-installer.nvim" })

  use({ "mfussenegger/nvim-dap" }) -- Debuggers for LSP
  use({
    "mfussenegger/nvim-dap-python",
    config = function()
      require('dap-python').setup('python3')
    end
  })
  use({ "jay-babu/mason-nvim-dap.nvim" })

  -- Markdown
  use({ "vimwiki/vimwiki" })
  use({ "tpope/vim-markdown", ft = "markdown" })
  use({ "tools-life/taskwiki" })
  use({ "farseer90718/vim-taskwarrior", ft = "vimwiki" })
  use({ "sotte/presenting.vim" })
  use({ "vim-scripts/DrawIt" })
  use({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "vimwiki" },
    run = function() vim.fn["mkdp#util#install"]() end
  })

  -- Appearance
  use { "daschw/leaf.nvim" }                   --alt-theme
  use { "catppuccin/nvim", as = "catppuccin" } --alt-theme
  use({ "micke/vim-hybrid" })                  -- theme
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  })
  use({ "junegunn/goyo.vim" })
  use({ "junegunn/limelight.vim" })
  use({ "nvim-tree/nvim-web-devicons" })
  use({ "folke/lsp-colors.nvim" })
  use({ "folke/trouble.nvim" })
  use({ "vim-airline/vim-airline" })
  use({ "vim-airline/vim-airline-themes" })

  -- I for one welcome our AI overlords
  use {
    'Exafunction/codeium.vim',
    requires = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      --vim.g.codeium_manual = 0
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_workspace_root_hints = { '.bzr', '.git', '.hg', '.svn', '_FOSSIL_', 'package.json', 'pyproject.toml' }
      vim.keymap.set('n', '<A-j>', function() return vim.fn['codeium#Chat']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<A-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<A-j>', function() return vim.fn['codeium#CycleOrComplete']() end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<A-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
        { expr = true, silent = true })
      vim.keymap.set('i', '<A-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
