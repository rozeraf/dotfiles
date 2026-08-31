-- Target: Neovim 0.12+

require("config.options")
require("config.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
	require("lazy").setup(require("config.vscode"))
	return
end

vim.opt.relativenumber = true

local apply_highlights = require("config.highlights")

require("lazy").setup({
	{ import = "plugins" },
})

apply_highlights()

if vim.g.neovide then
	vim.g.neovide_opacity = 1.0
	vim.g.neovide_normal_opacity = 0.88
end
