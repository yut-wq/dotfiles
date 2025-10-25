return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	on_init = function(client)
	end,
	settings = {
		Lua = {
			diagnostics = {
				unusedLocalExclude = { "_*" },
			},
		},
	},
}
