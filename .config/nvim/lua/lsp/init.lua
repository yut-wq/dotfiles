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

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup("lsp/init.lua", {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		local opts = { noremap = true, silent = true }
		local keymap = vim.api.nvim_buf_set_keymap
		keymap(args.buf, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		keymap(args.buf, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		keymap(args.buf, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
		keymap(args.buf, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		keymap(args.buf, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
		keymap(args.buf, "n", "rn", "<cmd>Lspsaga rename<CR>", opts)
		keymap(args.buf, "n", "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		keymap(args.buf, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
		keymap(args.buf, "v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	end,
})

-- load lsp/lua_ls.lua
local lua_ls_opts = require("lsp.lua_ls")
vim.lsp.config("lua_ls", lua_ls_opts)
vim.lsp.enable("lua_ls")

vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
})
vim.lsp.enable("rust_analyzer")
