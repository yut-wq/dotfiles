return {
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				enable = true,
				bindingModeHints = {
					enable = true,
				},
				chainingHints = {
					enable = true,
				},
				closingBraceHints = {
					enable = true,
					minLines = 25,
				},
				closureReturnTypeHints = {
					enable = "always",
				},
				lifetimeElisionHints = {
					enable = "always",
					useParameterNames = true,
				},
				parameterHints = {
					enable = true,
				},
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
		},
	},
}
