vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_list_hide = [[^\.\.\=/\=$]]
-- vim.g.netrw_keepdir = 0   -- Still not sure if I wanna keep this or not

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Don't have `o` add a comment
vim.opt.formatoptions:remove "o"

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"

vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

