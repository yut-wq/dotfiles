-- common settings
-- require('keymaps')
require('vimrc')
-- map prefix
-- vim.g.mapleader = ' '
-- set options
-- vim.opt.termguicolors = true
-- vim.opt.number = true
-- vim.opt.updatetime = 500
-- vim.opt.expandtab = true
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2



-- plugins
-- ---------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- requires
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  'mfussenegger/nvim-dap',
  "sindrets/diffview.nvim",
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
    },
  },

  -- cmp source
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  -- 'yutkat/cmp-mocword',
  'hrsh7th/cmp-nvim-lua',
  'f3fora/cmp-spell',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',

  -- cmp snip
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',

  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  'sainnhe/gruvbox-material',
  'akinsho/bufferline.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-neo-tree/neo-tree.nvim',
  'MunifTanjim/nui.nvim',
  'mtdl9/vim-log-highlighting',
  {
    "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration
        -- Only one of these is needed, not both.
        "nvim-telescope/telescope.nvim", -- optional
      },
      config = true
  },
  'j-hui/fidget.nvim',
  { 'echasnovski/mini.nvim', version = false },
  'onsails/lspkind.nvim',
  -- 'tpope/vim-surround',
  -- 'machakann/vim-sandwich',
  'vim-denops/denops.vim',
  -- 'higashi000/dps-kakkonan',
  'andymass/vim-matchup',
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',

  -- rust
  'simrat39/rust-tools.nvim',

  -- html
  'mattn/emmet-vim',

  -- cs
  -- 'OmniSharp/omnisharp-vim',

  {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'}
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
})

-- telescope.nvim
require('telescope').setup({
  defaults = {
    mappings = {
      n = {
        ['<Esc>'] = require('telescope.actions').close,
        ['<C-g>'] = require('telescope.actions').close,
      },
      i = {
        ['<C-g>'] = require('telescope.actions').close,
      },
    },
  },
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- nvim-lsp
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lsp_config = require('lspconfig')

mason.setup()
mason_lspconfig.setup()
--
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_config.lua_ls.setup{capabilities = capabilities}
lsp_config.tsserver.setup{capabilities = capabilities}
lsp_config.pyright.setup{capabilities = capabilities}
-- lsp_config.rust_analyzer.setup{capabilities = capabilities}
lsp_config.html.setup{capabilities = capabilities}
lsp_config.cssls.setup{capabilities = capabilities}
lsp_config.omnisharp_mono.setup{capabilities = capabilities}
-- lsp_config.csharp_ls.setup{capabilities = capabilities}
-- lsp_config..setup{}
-- lsp_config..setup{}
-- lsp_config..setup{}
-- lsp_config..setup{}




vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = { '*' },
  callback = function()
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  callback = function()
    vim.keymap.set({ 'n' }, '<Plug>(lsp)f', function()
      vim.cmd([[EslintFixAll]])
      vim.lsp.buf.format({ name = 'null-ls' })
    end)
  end,
})

local function show_documentation()
  local ft = vim.opt.filetype._value
  if ft == 'vim' or ft == 'help' then
    vim.cmd([[execute 'h ' . expand('<cword>') ]])
  else
    require('lspsaga.hover').render_hover_doc()
  end
end

vim.keymap.set({ 'n' }, 'K', show_documentation)
vim.keymap.set({ 'n' }, '<Plug>(lsp)q', '<Cmd>Telescope diagnostics<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)f', vim.lsp.buf.format)
vim.keymap.set({ 'n' }, '<leader>di', '<Cmd>Telescope lsp_implementations<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)t', '<Cmd>Telescope lsp_type_definitions<CR>')
vim.keymap.set({ 'n' }, '<Plug>(lsp)rf', '<Cmd>Telescope lsp_references<CR>')

-- nvim-cmp
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  enabled = true,
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'mocword' },
    { name = 'nvim_lua' },
    { name = 'vsnip' },
    { name = 'nvim_lsp_signature_help' },
    {
      name = 'spell',
      option = {
          keep_all_entries = false,
          enable_in_context = function()
              return true
          end,
      },
    },
  }),
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    mode = 'text',
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  },
})

vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }

--
-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})



-- treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'typescript',
    'tsx',
  },
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
  },
})

-- akinsho/bufferline.nvim
vim.opt.termguicolors = true
require("bufferline").setup{}

-- nvim-lualine/lualine.nvim
require('lualine').setup()


-- j-hui/fidget.nvim
require"fidget".setup{}


-- nvim-neo-tree/neo-tree.nvim
require('neo-tree').setup({
  filesystem = {
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false, -- only works on Windows for hidden files/directories
    },
  }
})
vim.keymap.set({ 'n' }, '<leader>fe', ':Neotree position=float toggle<CR>')

-- gruvbox
vim.cmd.colorscheme('gruvbox-material')


-- neogit
local neogit = require('neogit')
neogit.setup {}
vim.keymap.set('n', '<leader>gi', ':Neogit<CR>')

-- mini.comment
require('mini.comment').setup()
-- vim.keymap.set({ 'n','v' }, '<leader>/', 'gcc<CR>')


-- rust-tools
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})


-- emmet
vim.cmd([[
  " ノーマルモードでのみ起動
  let g:user_emmet_mode='n'
  " css,htmlの時のみ起動するように
  let g:user_emmet_install_global = 0
  autocmd FileType html,css EmmetInstall
  " スニペットの追加
  let g:user_emmet_settings = {
  \  'variables': {'lang': 'ja'},
  \  'html': {
  \    'default_attributes': {
  \      'option': {'value': v:null},
  \      'textarea': {'id': v:null, 'name': v:null, 'cols': 10, 'rows': 10},
  \    },
  \    'snippets': {
  \      'html:5': "<!DOCTYPE html>\n"
  \              ."<html lang=\"${lang}\">\n"
  \              ."<head>\n"
  \              ."\t<meta charset=\"${charset}\">\n"
  \              ."\t<title></title>\n"
  \              ."\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
  \              ."</head>\n"
  \              ."<body>\n\t${child}|\n</body>\n"
  \              ."</html>",
  \    },
  \  },
  \}
]])
-- 起動時のキーマップ
vim.keymap.set('n', '<leader>ym', '<C-y>,')




-- nvim-autopairs
require("nvim-autopairs").setup {}
require('nvim-ts-autotag').setup()

-- lspconfig loglevel
vim.lsp.set_log_level("debug")


-- renerocksai/telekasten.nvim
require('telekasten').setup({
  home = vim.fn.expand("~/memo"), -- Put the name of your notes directory here
})
-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>fm", "<cmd>Telekasten find_notes<CR>")
-- vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
-- vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>cm", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>cal", "<cmd>Telekasten show_calendar<CR>")
-- vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
-- vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
-- vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")


-- 行末の空白を削除する。
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  command = [[:%s/\s\+$//ge]],
})

-- omnisharp
vim.cmd([[
  " let g:OmniSharp_server_path = '/mnt/c/Users/GinCoke/AppData/Local/omnisharp-win-x64/OmniSharp.exe'
  " let g:OmniSharp_translate_cygwin_wsl = 1
  " let g:OmniSharp_server_use_mono = 1
]])

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup()




