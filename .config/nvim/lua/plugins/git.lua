return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		dependencies = { "petertriho/nvim-scrollbar", opts = {} },
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{
				"<leader>g",
				"<cmd>lua _lazygit_toggle()<CR>",
			},
		},
		version = "*",
		opts = {},
		config = function()
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

			function _lazygit_toggle()
				lazygit:toggle()
			end
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen" },
	},
}
