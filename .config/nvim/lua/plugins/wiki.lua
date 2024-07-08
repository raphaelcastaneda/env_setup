return {
{ "vimwiki/vimwiki",
event = { "BufEnter *.md"},
  keys = {
    "<leader>ww",
    "<leader>w<leader>w",
  },
},
{ "tpope/vim-markdown",                  ft = "markdown" },
{ "tools-life/taskwiki" },
{ "farseer90718/vim-taskwarrior",        ft = "vimwiki" },
{ "sotte/presenting.vim" },
{ "vim-scripts/DrawIt" },
{
  "iamcco/markdown-preview.nvim",
  ft = { "markdown", "vimwiki" },
  build = function()
      vim.fn["mkdp#util#install"]() 
    end,
},

	
}
