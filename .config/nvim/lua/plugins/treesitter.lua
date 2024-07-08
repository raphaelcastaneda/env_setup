return {
  {
    "nvim-treesitter/nvim-treesitter",
    priority = 1000,
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = "all", -- one of "all", "maintained" (parsers with -- maintainers), or a list of languages
        --ensure_installed = { "go", "python", "lua", "vim", "vimdoc", "yaml" },
        ignore_install = { "vimwiki" }, -- List of parsers to ignore installing
        symbol_in_winbar = {
          enable = false
        },
        highlight = {
          enable = true,    -- false will disable the whole extension
          additional_vim_regex_highlighting = false,
          --disable = { "c", "rust" },  -- list of language that will be disabled
          disable = function(lang, buf)
            local max_filesize = 100 * 1024      -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end
        }
      })
    end
  },
}
