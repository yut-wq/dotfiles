return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			sections = {
				lualine_c = {
					{
						"filename",
						path = 1, -- 0: ファイル名のみ, 1: 相対パス, 2: 絶対パス, 3: 絶対パス(~付き)
					},
				},
			},
		},
	},
}
