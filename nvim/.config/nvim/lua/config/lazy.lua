local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true },
	rocks = { enabled = false },
	ui = {
		border = "rounded",
	},
})

-- Backdrop floats omit `border`, so Neovim applies 'winborder' to them.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lazy_backdrop",
	callback = function(event)
		local win = vim.fn.win_findbuf(event.buf)[1]
		if win then
			vim.api.nvim_win_set_config(win, { border = "none" })
		end
	end,
})
