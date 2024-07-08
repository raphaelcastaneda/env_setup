return {

  -- Finders and Search
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    config = function(plugin)
      require('telescope').setup {

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
      }

      local refactoring = require('refactoring')
      require("telescope").load_extension("refactoring")
      refactoring.setup({})

      vim.keymap.set(
        { "n", "x" },
        "<leader>R",
        function() require('telescope').extensions.refactoring.refactors() end
      )
      vim.keymap.set({ "n" }, "<leader>p", function() refactoring.debug.print_var({}) end)
      vim.keymap.set({ "n" }, "<leader>P", function() refactoring.debug.cleanup({}) end)
    end,
    dependencies = { 'nvim-lua/plenary.nvim', 'ThePrimeagen/refactoring.nvim' }
  },
  { "junegunn/fzf",                             lazy = false,                                                                                  build = ":call fzf#install()" },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },


  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },


  -- Quality of Life
  {
    "petertriho/nvim-scrollbar",
    dependencies = { 'kevinhwang91/nvim-hlslens' },
    config = function(plugin)
      require('scrollbar').setup()
      require("scrollbar.handlers.search").setup()
      require('gitsigns').setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  { "scrooloose/nerdcommenter" },
  { "tpope/vim-dotenv" },

  {
    "kevinhwang91/nvim-hlslens",
    config = function(plugin)
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
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    cmd = { "NvimTreeFindFileToggle", "NvimTreeFindFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-tree").setup {
        update_cwd          = false,
        update_focused_file = {
          enable      = true,
          update_cwd  = false,
          ignore_list = {},
        },
      }
    end
  },
  { "folke/which-key.nvim" }, --Lua autocompletion for nvim api
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
  },
  { "tpope/vim-obsession" }, -- Save and restore vim sessions
  { "tpope/vim-tbone" },     -- Integration with tmux
  { "tpope/vim-surround" },  -- Add, replace, change surrounds (quotes, brackets, etc)
  {
    "windwp/nvim-autopairs",
    config = function(plugin)
      require("nvim-autopairs").setup {}
    end
  },                              -- Insert closure when inserting an opener
  { "inkarkat/vim-SyntaxRange" }, -- Fenced syntax highlighting
  {
    "numtostr/BufOnly.nvim",
    cmd = "BufOnly",
    config = function(plugin)
      vim.g.bufonly_delete_non_modifiable = false -- Don't close nerdtree and other non-editable buffers
      vim.api.nvim_set_keymap('n', '<leader>cb', ':BufOnly<CR>', { noremap = true, silent = true })
    end
  }, --Commands to close all other buffers


  -- Debugging

  { "puremourning/vimspector" }, -- Debugger based on json configs (like VSCode)
  -- {
  -- "sagi-z/vimspectorpy",
  -- ft = "python",
  --   build = function()
  --     vim.fn['vimspectorpy#update']()
  --   end
  -- }, -- easy python defaults for vimspector

  -- Appearance
  {
    "nvim-tree/nvim-web-devicons",
    config = function(plugin)
      require("nvim-web-devicons").setup {
        color_icons = true,
        override_by_extension = {
          ["go"] = {
            icon = "",
            color = "#34c0eb",
            name = "Go"
          }
        },
      }
    end
  },

  {"lukas-reineke/indent-blankline.nvim"}, -- Indentation guides to enhance listchars


  { "daschw/leaf.nvim" }, --alt-theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    config = function(plugin)
      require('theme')
    end,
  }, --current-theme
  -- { "micke/vim-hybrid" },                  -- old-theme
  {
    "brenoprata10/nvim-highlight-colors",
    config = function(plugin)
      require("nvim-highlight-colors").setup({})
    end
  },
  { "junegunn/goyo.vim" },
  { "junegunn/limelight.vim" },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
  },

}
