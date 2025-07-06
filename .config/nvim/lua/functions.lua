-- 行末の空白を削除する。
local function trim_white_space()
	local filetype = vim.bo.filetype
	if filetype ~= "markdown" then
		vim.cmd([[%s/\s\+$//ge]])
	end
end

-- <CR>の削除ショートカット
vim.keymap.set("n", "<leader>rm", [[:silent! %s/\r$//<CR>]], { noremap = true, silent = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = trim_white_space,
})
