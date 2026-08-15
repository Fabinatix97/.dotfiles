return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "format buffer",
		},
		{
			"<leader>tf",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				vim.notify(
					vim.g.disable_autoformat and "Autoformat on save: off" or "Autoformat on save: on",
					vim.log.levels.INFO
				)
			end,
			desc = "toggle format on save",
		},
	},
	opts = {
		notify_on_error = false,
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500 }
		end,
		formatters_by_ft = {
			php = { "php_cs_fixer" },
		},
	},
}
