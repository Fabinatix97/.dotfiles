return {
	"nvim-mini/mini.nvim",
	config = function()
		require("mini.ai").setup({
			mappings = {
				around_next = "aa",
				inside_next = "ii",
			},
			n_lines = 500,
		})
		require("mini.surround").setup()
	end,
}
