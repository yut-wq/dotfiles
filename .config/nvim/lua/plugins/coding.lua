return {
	"andymass/vim-matchup",
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	{ "windwp/nvim-ts-autotag", event = "InsertEnter", opts = {} },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, event = { "BufReadPre", "BufNewFile" } },
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
}
