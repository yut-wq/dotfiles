require("vimrc")
require("functions")

-- plugins
require("pluginManager")
require("lsp")

vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin-macchiato")
vim.lsp.set_log_level("debug")
vim.opt.conceallevel = 1

-- LSP関連のデフォルトを無効にする
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grt")
