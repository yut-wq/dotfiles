return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader><leader>f",
				function()
					require("conform").format({ async = true })
				end,
			},
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				markdown = { "prettier" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			-- format_on_save = { timeout_ms = 500 },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
	},
}
