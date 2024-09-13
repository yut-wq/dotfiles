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
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		--   "BufReadPre path/to/my-vault/*.md",
		--   "BufNewFile path/to/my-vault/*.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",

			-- see below for full list of optional dependencies 👇
		},
	},
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

-- memo
require("obsidian").setup({
	-- A list of workspace names, paths, and configuration overrides.
	-- If you use the Obsidian app, the 'path' of a workspace should generally be
	-- your vault root (where the `.obsidian` folder is located).
	-- When obsidian.nvim is loaded by your plugin manager, it will automatically set
	-- the workspace to the first workspace in the list whose `path` is a parent of the
	-- current markdown file being edited.
	workspaces = {
		{
			name = "personal",
			path = "~/memo",
		},
		-- {
		-- 	name = "work",
		-- 	path = "~/vaults/work",
		-- 	-- Optional, override certain settings.
		-- 	-- overrides = {
		-- 	-- 	notes_subdir = "notes",
		-- 	-- },
		-- },
	},

	-- Alternatively - and for backwards compatibility - you can set 'dir' to a single path instead of
	-- 'workspaces'. For example:
	-- dir = "~/vaults/work",

	-- Optional, if you keep notes in a specific subdirectory of your vault.
	-- notes_subdir = "notes",

	-- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
	-- levels defined by "vim.log.levels.*".
	log_level = vim.log.levels.INFO,

	daily_notes = {
		-- Optional, if you keep daily notes in a separate directory.
		folder = "dailies",
		-- Optional, if you want to change the date format for the ID of daily notes.
		date_format = "%Y-%m-%d",
		-- Optional, if you want to change the date format of the default alias of daily notes.
		alias_format = "%B %-d, %Y",
		-- Optional, default tags to add to each new daily note created.
		default_tags = { "daily-notes" },
		-- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
		-- template = nil,
	},

	-- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
	completion = {
		-- Set to false to disable completion.
		nvim_cmp = true,
		-- Trigger completion at 2 chars.
		min_chars = 2,
	},

	-- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
	-- way then set 'mappings = {}'.
	mappings = {
		-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
		["gf"] = {
			action = function()
				return require("obsidian").util.gf_passthrough()
			end,
			opts = { noremap = false, expr = true, buffer = true },
		},
		-- Toggle check-boxes.
		["<leader>ch"] = {
			action = function()
				return require("obsidian").util.toggle_checkbox()
			end,
			opts = { buffer = true },
		},
		-- Smart action depending on context, either follow link or toggle checkbox.
		["<cr>"] = {
			action = function()
				return require("obsidian").util.smart_action()
			end,
			opts = { buffer = true, expr = true },
		},
	},

	-- Where to put new notes. Valid options are
	--  * "current_dir" - put new notes in same directory as the current buffer.
	--  * "notes_subdir" - put new notes in the default notes subdirectory.
	new_notes_location = "notes_subdir",

	-- Optional, customize how note IDs are generated given an optional title.
	---@param title string|?
	---@return string
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		-- In this case a note with the title 'My new note' will be given an ID that looks
		-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
		local suffix = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return tostring(os.time()) .. "-" .. suffix
	end,

	-- Optional, customize how note file names are generated given the ID, target directory, and title.
	---@param spec { id: string, dir: obsidian.Path, title: string|? }
	---@return string|obsidian.Path The full path to the new note.
	note_path_func = function(spec)
		-- This is equivalent to the default behavior.
		local path = spec.dir / tostring(spec.id)
		return path:with_suffix(".md")
	end,

	-- Optional, customize how wiki links are formatted. You can set this to one of:
	--  * "use_alias_only", e.g. '[[Foo Bar]]'
	--  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
	--  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
	--  * "use_path_only", e.g. '[[foo-bar.md]]'
	-- Or you can set it to a function that takes a table of options and returns a string, like this:
	wiki_link_func = function(opts)
		return require("obsidian.util").wiki_link_id_prefix(opts)
	end,

	-- Optional, customize how markdown links are formatted.
	markdown_link_func = function(opts)
		return require("obsidian.util").markdown_link(opts)
	end,

	-- Either 'wiki' or 'markdown'.
	preferred_link_style = "wiki",

	-- Optional, boolean or a function that takes a filename and returns a boolean.
	-- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
	disable_frontmatter = false,

	-- Optional, alternatively you can customize the frontmatter data.
	---@return table
	note_frontmatter_func = function(note)
		-- Add the title of the note as an alias.
		if note.title then
			note:add_alias(note.title)
		end

		local out = { id = note.id, aliases = note.aliases, tags = note.tags }

		-- `note.metadata` contains any manually added fields in the frontmatter.
		-- So here we just make sure those fields are kept in the frontmatter.
		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				out[k] = v
			end
		end

		return out
	end,

	-- Optional, for templates (see below).
	-- templates = {
	-- 	folder = "templates",
	-- 	date_format = "%Y-%m-%d",
	-- 	time_format = "%H:%M",
	-- 	-- A map for custom variables, the key should be the variable and the value a function
	-- 	substitutions = {},
	-- },

	-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
	-- URL it will be ignored but you can customize this behavior here.
	---@param url string
	follow_url_func = function(url)
		-- Open the URL in the default web browser.
		vim.fn.jobstart({ "open", url }) -- Mac OS
		-- vim.fn.jobstart({"xdg-open", url})  -- linux
		-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
		-- vim.ui.open(url) -- need Neovim 0.10.0+
	end,

	-- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
	-- file it will be ignored but you can customize this behavior here.
	---@param img string
	follow_img_func = function(img)
		vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
		-- vim.fn.jobstart({"xdg-open", url})  -- linux
		-- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
	end,

	-- Optional, set to true if you use the Obsidian Advanced URI plugin.
	-- https://github.com/Vinzent03/obsidian-advanced-uri
	use_advanced_uri = false,

	-- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
	open_app_foreground = false,

	picker = {
		-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
		name = "telescope.nvim",
		-- Optional, configure key mappings for the picker. These are the defaults.
		-- Not all pickers support all mappings.
		note_mappings = {
			-- Create a new note from your query.
			new = "<C-x>",
			-- Insert a link to the selected note.
			insert_link = "<C-l>",
		},
		tag_mappings = {
			-- Add tag(s) to current note.
			tag_note = "<C-x>",
			-- Insert a tag at the current location.
			insert_tag = "<C-l>",
		},
	},

	-- Optional, sort search results by "path", "modified", "accessed", or "created".
	-- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
	-- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
	sort_by = "modified",
	sort_reversed = true,

	-- Set the maximum number of lines to read from notes on disk when performing certain searches.
	search_max_lines = 1000,

	-- Optional, determines how certain commands open notes. The valid options are:
	-- 1. "current" (the default) - to always open in the current window
	-- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
	-- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
	open_notes_in = "current",

	-- Optional, define your own callbacks to further customize behavior.
	callbacks = {
		-- Runs at the end of `require("obsidian").setup()`.
		---@param client obsidian.Client
		post_setup = function(client) end,

		-- Runs anytime you enter the buffer for a note.
		---@param client obsidian.Client
		---@param note obsidian.Note
		enter_note = function(client, note) end,

		-- Runs anytime you leave the buffer for a note.
		---@param client obsidian.Client
		---@param note obsidian.Note
		leave_note = function(client, note) end,

		-- Runs right before writing the buffer for a note.
		---@param client obsidian.Client
		---@param note obsidian.Note
		pre_write_note = function(client, note) end,

		-- Runs anytime the workspace is set/changed.
		---@param client obsidian.Client
		---@param workspace obsidian.Workspace
		post_set_workspace = function(client, workspace) end,
	},

	-- Optional, configure additional syntax highlighting / extmarks.
	-- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
	ui = {
		enable = true, -- set to false to disable all additional syntax features
		update_debounce = 200, -- update delay after a text change (in milliseconds)
		max_file_length = 5000, -- disable UI features for files with more than this many lines
		-- Define how various check-boxes are displayed
		checkboxes = {
			-- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
			[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
			["x"] = { char = "", hl_group = "ObsidianDone" },
			[">"] = { char = "", hl_group = "ObsidianRightArrow" },
			["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
			["!"] = { char = "", hl_group = "ObsidianImportant" },
			-- Replace the above with this if you don't have a patched font:
			-- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
			-- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

			-- You can also add more custom ones...
		},
		-- Use bullet marks for non-checkbox lists.
		bullets = { char = "•", hl_group = "ObsidianBullet" },
		external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		-- Replace the above with this if you don't have a patched font:
		-- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
		reference_text = { hl_group = "ObsidianRefText" },
		highlight_text = { hl_group = "ObsidianHighlightText" },
		tags = { hl_group = "ObsidianTag" },
		block_ids = { hl_group = "ObsidianBlockID" },
		hl_groups = {
			-- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
			ObsidianTodo = { bold = true, fg = "#f78c6c" },
			ObsidianDone = { bold = true, fg = "#89ddff" },
			ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
			ObsidianTilde = { bold = true, fg = "#ff5370" },
			ObsidianImportant = { bold = true, fg = "#d73128" },
			ObsidianBullet = { bold = true, fg = "#89ddff" },
			ObsidianRefText = { underline = true, fg = "#c792ea" },
			ObsidianExtLinkIcon = { fg = "#c792ea" },
			ObsidianTag = { italic = true, fg = "#89ddff" },
			ObsidianBlockID = { italic = true, fg = "#89ddff" },
			ObsidianHighlightText = { bg = "#75662e" },
		},
	},

	-- Specify how to handle attachments.
	attachments = {
		-- The default folder to place images in via `:ObsidianPasteImg`.
		-- If this is a relative path it will be interpreted as relative to the vault root.
		-- You can always override this per image by passing a full path to the command instead of just a filename.
		img_folder = "assets/imgs", -- This is the default

		-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
		---@return string
		img_name_func = function()
			-- Prefix image names with timestamp.
			return string.format("%s-", os.time())
		end,

		-- A function that determines the text to insert in the note when pasting an image.
		-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
		-- This is the default implementation.
		---@param client obsidian.Client
		---@param path obsidian.Path the absolute path to the image file
		---@return string
		img_text_func = function(client, path)
			path = client:vault_relative_path(path) or path
			return string.format("![%s](%s)", path.name, path)
		end,
	},
})
vim.keymap.set("n", "<leader>cm", "<cmd>ObsidianNew<CR>", {})
vim.keymap.set("n", "<leader>fm", "<cmd>ObsidianQuickSwitch<CR>", {})
vim.keymap.set("n", "<leader>cd", "<cmd>ObsidianToday<CR>", {})
vim.opt.conceallevel = 1
