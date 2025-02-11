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

		local telescopeConfig = require("telescope.config")
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
		-- I want to search in hidden/dot files.
		table.insert(vimgrep_arguments, "--hidden")
		-- I don't want to search in the `.git` directory.
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		return {
			defaults = {
				vimgrep_arguments = vimgrep_arguments,
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
			pickers = {
				find_files = {
					-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		}
	end,
}
