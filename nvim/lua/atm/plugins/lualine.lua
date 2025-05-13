return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'stevearc/aerial.nvim',
  },

 config = function()
    local lualine = require('lualine')
    local lazy_status = require('lazy.status') -- to configure lazy pending updates count

    local colors = {
      blue = '#65D1FF',
      green = '#3EFFDC',
      violet = '#FF61EF',
      yellow = '#FFDA7B',
      red = '#FF4A4A',
      fg = '#c3ccdc',
      bg = '#112638',
      inactive_bg = '#2c3043',
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = 'bold' },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = my_lualine_theme,
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {
          { 'mode' },
          { 'branch' },
          { 'filename' },
        },
        lualine_b = {
          {
            file_status = true,      -- Displays file status (readonly status, modified status)
            newfile_status = false,  -- Display new file status (new file means no write after created)
            path = 0,                -- 0: Just the filename
--                                     -- 1: Relative path
--                                     -- 2: Absolute path
--                                     -- 3: Absolute path, with tilde as the home directory
--                                     -- 4: Filename and parent dir, with tilde as the home directory
            shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
            symbols = {
              modified = '[+]',      -- Text to show when the file is modified.
              readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]',     -- Text to show for newly created file before first write
            }
          }
        },

        lualine_c = {
          {
            'aerial',
            -- The separator to be used to separate symbols in status line.
            sep = ' > ',
            -- The number of symbols to render top-down. 
            -- Use -1 to render all symbols or a positive number to render only N symbols
            depth = 2,
            -- Dense mode shows only the icon of the topmost symbol
            dense = false,
            -- Color the symbol icons
            colored = true,
          }
        },

        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = '#ff9e64' },
          },
          { 'encoding' },
          { 'fileformat' },
          { 'filetype' },
          { 'diagnostics' },
        },
      },
    })
  end
}
