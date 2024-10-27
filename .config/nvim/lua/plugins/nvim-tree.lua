return {
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		keys = {
			{
				"<leader>fe",
				"<cmd>NvimTreeToggle<cr>",
			},
		},
		opts = function()
			local HEIGHT_RATIO = 0.8 -- You can change this
			local WIDTH_RATIO = 0.5 -- You can change this too
			return {
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					float = {
						enable = true,
						open_win_config = function()
							local screen_w = vim.opt.columns:get()
							local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
							local window_w = screen_w * WIDTH_RATIO
							local window_h = screen_h * HEIGHT_RATIO
							local window_w_int = math.floor(window_w)
							local window_h_int = math.floor(window_h)
							local center_x = (screen_w - window_w) / 2
							local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
							return {
								border = "rounded",
								relative = "editor",
								row = center_y,
								col = center_x,
								width = window_w_int,
								height = window_h_int,
							}
						end,
					},
					width = function()
						return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					end,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					enable = false,
				},
			}
		end,
		config = function(_, opts)
			require("nvim-tree").setup(opts)
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
			vim.keymap.set("n", "l", edit_or_open)
			vim.keymap.set("n", "L", vsplit_preview)
			vim.keymap.set("n", "H", api.tree.collapse_all)
		end,
	},
}
