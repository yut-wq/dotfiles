return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "mason.nvim", cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUpdate" } },
			"williamboman/mason-lspconfig.nvim",
		},
		opts = function() end,
		config = function()
			require("mason").setup()

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󰌶",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
				virtual_text = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = {
					focusable = true,
					style = "minimal",
					border = "rounded",
					header = "",
					prefix = "",
				},
			})

			local function lsp_keymaps(bufnr)
				local opts = { noremap = true, silent = true }
				local keymap = vim.api.nvim_buf_set_keymap
				keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
				keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end)
				keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
				keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
				keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
				keymap(bufnr, "n", "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
			end

			local on_attach = function(client, bufnr)
				lsp_keymaps(bufnr)

				if client.supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true)
				end
			end

			require("mason-lspconfig").setup_handlers({
				function(server)
					local opt = {
						on_attach = on_attach,
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					}
					require("lspconfig")[server].setup(opt)
				end,
			})
		end,
	},
	"onsails/lspkind.nvim",
	{
		"j-hui/fidget.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
