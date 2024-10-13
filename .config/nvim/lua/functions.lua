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
local function trim_white_space()
	local filetype = vim.bo.filetype
	if filetype ~= "markdown" then
		vim.cmd([[%s/\s\+$//ge]])
	end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = trim_white_space
})
