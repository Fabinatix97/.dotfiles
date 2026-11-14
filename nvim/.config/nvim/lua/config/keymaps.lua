-- General
vim.keymap.set({ "n", "v" }, "<C-c>", "<Esc>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Close floating windows before opening netrw
vim.keymap.set("n", "-", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end
	vim.cmd.Ex()
end, { desc = "open netrw" })

-- Keep view centered while scrolling
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- This allows filtering the command history
vim.keymap.set("c", "<C-p>", "<Up>")
vim.keymap.set("c", "<C-n>", "<Down>")

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle undotree" })

-- More familiar buffer navigation
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { silent = true, desc = "next buffer"})
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { silent = true, desc = "previous buffer"})
vim.keymap.set("n", "[B", "<cmd>bfirst<CR>", { silent = true, desc = "first buffer"})
vim.keymap.set("n", "]B", "<cmd>blast<CR>", { silent = true, desc = "last buffer"})

-- Floating diagnostics
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "previous diagnostic" })

-- Lazy and Mason
vim.keymap.set("n", "<leader>ll", vim.cmd.Lazy, { desc = "lazy plugin manager" })
vim.keymap.set("n", "<leader>cm", vim.cmd.Mason, { desc = "mason" })

-- Useful for executing Lua code
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "source file"})
vim.keymap.set("n", "<leader>x", "<cmd>lua<CR>", { desc = "execute line"})
vim.keymap.set("v", "<leader>x", "<cmd>lua<CR>", { desc = "execute selection"})
