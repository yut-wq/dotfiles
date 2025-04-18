return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	version = false,
	event = { "VeryLazy" },
	cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
	opts_extend = { "ensure_installed" },
	main = "nvim-treesitter.configs",
	opts = {
		highlight = { enable = true },
		indent = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"jsonc",
			"lua",
			"luadoc",
			"luap",
			"markdown",
			"markdown_inline",
			"printf",
			"python",
			"query",
			"regex",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"xml",
			"yaml",
		},
		incremental_selection = {
			enable = true,
			-- keymaps = {
			--   init_selection = "<C-space>",
			--   node_incremental = "<C-space>",
			--   scope_incremental = false,
			--   node_decremental = "<bs>",
			-- },
		},
		-- textobjects = {
		--   move = {
		--     enable = true,
		--     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
		--     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
		--     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
		--     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
		--   },
		-- },
		matchup = {
			enable = true, -- mandatory, false will disable the whole extension
		},
	},
}
