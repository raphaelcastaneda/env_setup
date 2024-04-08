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
  use({ "nvim-lua/plenary.nvim" })               -- Prereq for telescope, null-ls, and refactoring
  use({ "mfussenegger/nvim-jdtls" })             --Extensions for built-in LSP
  use({ "lukas-reineke/indent-blankline.nvim" }) -- Indentation guides to enhance listchars
  use({ "dstein64/vim-startuptime"}) -- vim startup profiler

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
  use({"HiPhish/rainbow-delimiters.nvim"})  -- Color-coded parens, brackets etc.
  use({ "tpope/vim-fugitive" })
  use({ "kyazdani42/nvim-tree.lua" })
  use({ "folke/which-key.nvim" }) --Lua autocompletion for nvim api
  use({
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  })
  use({ "tpope/vim-obsession" })                    -- Save and restore vim sessions
  use({ "tpope/vim-tbone" })                        -- Integration with tmux
  use({ "tpope/vim-surround" })                     -- Add, replace, change surrounds (quotes, brackets, etc)
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
    commit = "2198c07124bef27ef81335be511c8abfd75db933",
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
            toggle_or_open = {'<CR>', '<space>'},
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
  use({ "jose-elias-alvarez/null-ls.nvim" })                    -- Allows lsp support for prettier

  -- CUSTOM PLUGINS - install things that we don't want in the dotfiles repo
  -- local private_plugins = require('private_plugins')
  -- if private_plugins then
  --   private_plugins(use)
  -- end

  -- use({ "martinda/Jenkinsfile-vim-syntax"})
  -- use({ "hashivim/vim-terraform" })
  use({ "puremourning/vimspector" })   -- Debugger based on json configs (like VSCode)
  use({ "sagi-z/vimspectorpy", ft="python", run = function() vim.fn['vimspectorpy#update'](0) end })   -- Debugger based on json configs (like VSCode)
  use({ "MunifTanjim/prettier.nvim" }) -- Formatter for JS etc.
  use({ "tpope/vim-dotenv" })

  --  Completion and snippets
  use({ "hrsh7th/nvim-cmp" })
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

  -- Mason - LSP server installer/manager
  use({ "williamboman/mason.nvim" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "mfussenegger/nvim-dap" }) -- Debuggers for LSP
  use({ "jay-babu/mason-nvim-dap.nvim" })

  -- Markdown
  use({ "vimwiki/vimwiki" })
  use({ "tpope/vim-markdown", ft="markdown" })
  use({ "tools-life/taskwiki" })
  use({ "farseer90718/vim-taskwarrior", ft="vimwiki" })
  use({ "sotte/presenting.vim" })
  use({ "vim-scripts/DrawIt" })
  use({
    "iamcco/markdown-preview.nvim",
    ft={ "markdown", "vimwiki" },
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- Appearance
  use({ "micke/vim-hybrid" }) -- theme
  use({ "junegunn/goyo.vim" })
  use({ "junegunn/limelight.vim" })
  use({ "nvim-tree/nvim-web-devicons" })
  use({ "folke/lsp-colors.nvim" })
  use({ "folke/trouble.nvim" })
  use({ "vim-airline/vim-airline" })
  use({ "vim-airline/vim-airline-themes" })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
