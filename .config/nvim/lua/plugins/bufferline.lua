return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<c-j>", "<cmd>BufferLineCyclePrev<cr>" },
			{ "<c-k>", "<cmd>BufferLineCycleNext<cr>" },
		},
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		},
	},
}
