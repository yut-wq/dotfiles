require("vimrc")
require("functions")

-- plugins
require("pluginManager")

vim.opt.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.cmd.colorscheme("gruvbox-material")
vim.lsp.set_log_level("debug")
vim.opt.conceallevel = 1
