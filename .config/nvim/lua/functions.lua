-- auto format
local function auto_format()
	local filetype = vim.bo.filetype
	if filetype == "dart" then
		vim.cmd("!dart format %p")
	elseif filetype == "lua" then
		vim.cmd("!stylua %")
	end
end

vim.keymap.set({ "n" }, "<leader><leader>f", auto_format)

-- 行末の空白を削除する。
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[:%s/\s\+$//ge]],
})
