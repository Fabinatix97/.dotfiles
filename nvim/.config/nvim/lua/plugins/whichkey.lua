return {
	"folke/which-key.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
	event = "VimEnter",
	opts = {
		delay = 1000,

        icons = {
            mappings = vim.g.have_nerd_font,

            rules = {
                {
                    pattern = "harpoon",
                    icon = "󰛢",
                    color = "yellow",
                },
                {
                    pattern = "git",
                    icon = "󰊢",
                    color = "orange",
                },
                {
                    pattern = "discard",
                    icon = "",
                },
            },
        },

		-- Document existing key chains
		spec = {
			{ "<leader>s", group = "search", mode = { "n", "v" }, icon = "" },
			{ "<leader>t", group = "toggle", mode = { "n" }, icon = "" },
			{ "<leader>c", group = "code action", mode = { "n", "v" } },
			{ "<leader>ce", group = "extract", mode = { "n", "v" } },
			{ "gr", group = "lsp actions", mode = { "n" } },
            { "<leader>l", group = "lazy" },
            { "]b", desc = "next buffer" },
            { "]B", desc = "last buffer" },
            { "[b", desc = "previous buffer" },
            { "[B", desc = "first buffer" },
		},
	},
}
