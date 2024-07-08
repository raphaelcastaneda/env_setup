-- I for one welcome our AI overlords
return {
{
  'Exafunction/codeium.vim',

  config = function(plugin)
    vim.g.codeium_manual = 0
    vim.g.codeium_disable_bindings = 1
    vim.keymap.set('n', '<A-j>', function() return vim.fn['codeium#Chat']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<A-l>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<A-j>', function() return vim.fn['codeium#CycleOrComplete']() end,
      { expr = true, silent = true })
    vim.keymap.set('i', '<A-k>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
      { expr = true, silent = true })
    vim.keymap.set('i', '<A-h>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
},

}