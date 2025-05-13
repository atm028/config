-- in explore the file structure shows as a tree
vim.cmd('let g:netrw_liststyle = 3')
vim.cmd('verbose set conceallevel=2')

local opt = vim.opt

opt.relativenumber = true
opt.number = true
-- enable mouse
opt.mouse = 'a'
-- sync vim and system clipboards
opt.clipboard = 'unnamedplus'
-- Enable break indent
opt.breakindent = true
-- Save undo history
opt.undofile = true
-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
opt.completeopt = 'menuone,noselect'

-- colors and colorscheme 
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'

-- tabs & indentation
opt.tabstop = 4 -- 2 spaces for tabs (check with style guide of Idea)
opt.shiftwidth = 4 -- 2 spaces for indent width
opt.expandtab = true -- expand tabs to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.cursorline = true

-- backspace
opt.backspace = 'indent,eol,start'

-- splitting
opt.splitright = true
opt.splitbelow = true

-- required for obsidian
vim.opt_local.conceallevel = 1
