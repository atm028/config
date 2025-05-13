return {
  'stevearc/aerial.nvim',
  opts = {
    vim.api.nvim_set_keymap('n', '<leader>sv', ':AerialToggle<CR>', { noremap = true, silent = true })
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons'
  },
  layout = {
    max_width = { 40, 0.2 },
    width = nil,
    min_width = 30,
  },
}
