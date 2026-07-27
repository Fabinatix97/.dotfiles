return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		dashboard = { enabled = true },
		lazygit = { enabled = true },
		scratch = { enabled = true },
	},
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "toggle scratch buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "select scratch buffer",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "lazygit",
		},
	},
}
