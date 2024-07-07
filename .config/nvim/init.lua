require("vimrc")
require("functions")

-- plugins
-- ---------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- requires
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	"mfussenegger/nvim-dap",
	"sindrets/diffview.nvim",
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
		},
	},

	-- cmp source
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	-- 'yutkat/cmp-mocword',
	"hrsh7th/cmp-nvim-lua",
	"f3fora/cmp-spell",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/nvim-cmp",

	-- cmp snip
	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",

	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	"sainnhe/gruvbox-material",
	"akinsho/bufferline.nvim",
	"nvim-lualine/lualine.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-tree/nvim-tree.lua",
	"MunifTanjim/nui.nvim",
	"mtdl9/vim-log-highlighting",
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
	"j-hui/fidget.nvim",
	{ "echasnovski/mini.nvim", version = false },
	"onsails/lspkind.nvim",
	-- 'tpope/vim-surround',
	-- 'machakann/vim-sandwich',
	-- 'vim-denops/denops.vim',
	"andymass/vim-matchup",
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",

	-- html
	"mattn/emmet-vim",

	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
})

-- telescope.nvim
require("telescope").setup({
	defaults = {
		mappings = {
			n = {
				["<Esc>"] = require("telescope.actions").close,
				["<C-g>"] = require("telescope.actions").close,
			},
			i = {
				["<C-g>"] = require("telescope.actions").close,
			},
		},
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- nvim-lsp
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_config = require("lspconfig")

mason.setup()
mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "tsserver", "pyright", "html", "cssls" },
})

-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_config.lua_ls.setup({ capabilities = capabilities })
lsp_config.tsserver.setup({ capabilities = capabilities })
lsp_config.pyright.setup({ capabilities = capabilities })
lsp_config.html.setup({ capabilities = capabilities })
lsp_config.cssls.setup({ capabilities = capabilities })
lsp_config.omnisharp_mono.setup({ capabilities = capabilities })
lsp_config.dartls.setup({})
-- lsp_config.rust_analyzer.setup{capabilities = capabilities}
-- lsp_config.csharp_ls.setup{capabilities = capabilities}
-- lsp_config..setup{}
-- lsp_config..setup{}
-- lsp_config..setup{}

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = { "*" },
	callback = function() end,
})

local function show_documentation()
	local ft = vim.opt.filetype._value
	if ft == "vim" or ft == "help" then
		vim.cmd([[execute 'h ' . expand('<cword>') ]])
	else
		require("lspsaga.hover").render_hover_doc()
	end
end

-- vim.keymap.set({ 'n' }, 'K', show_documentation)
vim.keymap.set({ "n" }, "K", vim.lsp.buf.hover)
vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set({ "n" }, "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set({ "n" }, "<leader>gi", vim.lsp.buf.implementation)
vim.keymap.set({ "n" }, "<leader>di", "<Cmd>Telescope diagnostics<CR>")
vim.keymap.set({ "n" }, "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<cr>")
vim.keymap.set({ "n" }, "<leader>gr", "<Cmd>Telescope lsp_references<CR>")

-- nvim-cmp
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
		end,
	},
	enabled = true,
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<tab>"] = cmp.mapping.confirm({ select = true }),
	}),
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		-- { name = 'mocword' },
		{ name = "nvim_lua" },
		{ name = "vsnip" },
		{ name = "nvim_lsp_signature_help" },
		{
			name = "spell",
			option = {
				keep_all_entries = false,
				enable_in_context = function()
					return true
				end,
			},
		},
	}),
	formatting = {
		fields = { "abbr", "kind", "menu" },
		mode = "text",
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			before = function(entry, vim_item)
				return vim_item
			end,
		}),
	},
})

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

--
-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"typescript",
		"tsx",
	},
	highlight = {
		enable = true,
	},
	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
	},
})

-- akinsho/bufferline.nvim
vim.opt.termguicolors = true
require("bufferline").setup({})

-- nvim-lualine/lualine.nvim
require("lualine").setup()

-- j-hui/fidget.nvim
require("fidget").setup({})

-- nvim-neo-tree/neo-tree.nvim
-- require('neo-tree').setup({
--   filesystem = {
--     filtered_items = {
--       visible = false, -- when true, they will just be displayed differently than normal items
--       hide_dotfiles = false,
--       hide_gitignored = false,
--       hide_hidden = false, -- only works on Windows for hidden files/directories
--     },
--   }
-- })

-- nvim tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
})

local api = require("nvim-tree.api")

local function edit_or_open()
	local node = api.tree.get_node_under_cursor()

	if node == nil then
		vim.api.nvim_command("normal! l")
	else
		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file
			api.node.open.edit()
			-- Close the tree if file was opened
			api.tree.close()
		end
	end
end

-- open as vsplit on current node
local function vsplit_preview()
	local node = api.tree.get_node_under_cursor()

	if node.nodes ~= nil then
		-- expand or collapse folder
		api.node.open.edit()
	else
		-- open file as vsplit
		api.node.open.vertical()
	end

	-- Finally refocus on tree if it was lost
	api.tree.focus()
end

vim.keymap.set({ "n" }, "<leader>fe", ":NvimTreeToggle<CR>")
-- vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
vim.keymap.set("n", "l", edit_or_open)
vim.keymap.set("n", "L", vsplit_preview)
-- vim.keymap.set("n", "h", api.tree.close)
vim.keymap.set("n", "H", api.tree.collapse_all)

-- gruvbox
vim.cmd.colorscheme("gruvbox-material")

-- mini.comment
require("mini.comment").setup()
-- vim.keymap.set({ 'n','v' }, '<leader>/', 'gcc<CR>')

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
vim.keymap.set("n", "<leader>ym", "<C-y>,")

-- nvim-autopairs
require("nvim-autopairs").setup({})
require("nvim-ts-autotag").setup()

-- lspconfig loglevel
vim.lsp.set_log_level("debug")

-- lukas-reineke/indent-blankline.nvim
require("ibl").setup()
