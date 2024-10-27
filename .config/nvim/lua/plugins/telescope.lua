return {
	"nvim-telescope/telescope.nvim",
	dependeincies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", {} },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", {} },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", {} },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", {} },
	},
	opts = function()
		local actions = require("telescope.actions")
		return {
			defaults = {
				mappings = {
					n = {
						["<Esc>"] = actions.close,
						["q"] = actions.close,
					},
					i = {
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
					},
				},
			},
		}
	end,
}
