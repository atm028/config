return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.4',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
    'ThePrimeagen/harpoon',
    'joshmedeski/telescope-smart-goto.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')
    local builtin = require('telescope.builtin')
    local telescopeConfig = require('telescope.config')
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

        local select_one_or_multi = function(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            vim.cmd(string.format("%s %s", "edit", j.path))
          end
        end
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end


    telescope.setup({
      defaults = {
        vimgrep_arguments = vimgrep_arguments,
        path_display = { 'smart' },
        mappings = {
          n = {
            ['<C-w>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
          i = {
            ['<C-j>'] = actions.preview_scrolling_down,
            ['<C-k>'] = actions.preview_scrolling_up,
            ['<C-s>'] = select_one_or_multi,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            ['<C-d>'] = actions.delete_buffer,
          },
        },
      },
    })

    telescope.load_extension('fzf')

    -- keymaps
    local keymap = vim.keymap

    local function telescope_live_grep_open_files()
      require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end
    keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
    keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
    keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search Git Commits" })
    keymap.set("n", "<leader>gb", builtin.git_bcommits, { desc = "Search Git Commits for Buffer" })

    keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", {desc = "Show LSP references"})
    keymap.set("n", "gD", vim.lsp.buf.declaration, {desc = "Go to declaration"})
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {desc = "Show LSP definitions"})
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {desc = "Show LSP implementations"})
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", {desc = "Show LSP type definitions"})

  end
}
