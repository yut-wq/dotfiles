-- 行末の空白を削除する。
local function trim_white_space()
	local filetype = vim.bo.filetype
	if filetype ~= "markdown" then
		vim.cmd([[%s/\s\+$//ge]])
	end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = trim_white_space,
})
