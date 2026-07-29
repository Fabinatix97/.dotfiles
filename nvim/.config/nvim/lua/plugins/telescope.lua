return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = require("telescope.themes").get_ivy(),
			pickers = {
				find_files = {
					hidden = true,
					no_ignore = true,
				},
				live_grep = {
					additional_args = { "--hidden", "--no-ignore" },
				},
				grep_string = {
					additional_args = { "--hidden", "--no-ignore" },
				},
			},
            extensions = {
                fzf = {},
            },
		})

		pcall(require("telescope").load_extension, "fzf")

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "search help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "search keymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "search files" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "search select telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "search current word" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "search by grep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "search diagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "search resume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'search recent files ("." for repeat)' })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "search commands" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "find existing buffers" })
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "search neovim files" })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf
				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "goto references" })
				vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "goto implementation" })
				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "goto definition" })
				vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "open document symbols" })
				vim.keymap.set("n", "gW", builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "open workspace symbols" })
				vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "goto type definition" })
			end,
		})
	end,
}
