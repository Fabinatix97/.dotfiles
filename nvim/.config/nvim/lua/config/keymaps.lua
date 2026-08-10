-- General
vim.keymap.set({ "n", "v" }, "<C-c>", "<Esc>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "project view" })

-- Keep view centered while scrolling
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle undotree" })

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
