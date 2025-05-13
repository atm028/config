return {
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    require('tokyonight').setup({
      style = 'moon',
    })
    vim.cmd('colorscheme tokyonight')
  end
}
