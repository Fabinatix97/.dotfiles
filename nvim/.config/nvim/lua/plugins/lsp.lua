return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Mason must be loaded before its dependents so we need to set it up here.
		-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
		{ "mason-org/mason.nvim", opts = {} },

		-- Maps LSP server names between nvim-lspconfig and Mason package names.
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "lsp: " .. desc })
				end

				map("grn", vim.lsp.buf.rename, "rename")
				map("gra", vim.lsp.buf.code_action, "goto code action", { "n", "x" })
				map("grD", vim.lsp.buf.declaration, "goto declaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client:supports_method("textDocument/inlayHint", event.buf) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "toggle inlay hints")
				end
			end,
		})

		local servers = {
			ts_ls = {},
			intelephense = {
				settings = {
					intelephense = {
						diagnostics = {
							undefinedProperties = false,
						},
					},
				},
				cmd = { "intelephense", "--stdio" },
				filetypes = { "php" },
				root_markers = { "composer.json" },
			},
            twiggy_language_server = {
                enabled = true,
            },
			lua_ls = {
				on_init = function(client)
					client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
							path = { "lua/?.lua", "lua/?/init.lua" },
						},
						workspace = {
							checkThirdParty = false,
							-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
							--  See https://github.com/neovim/nvim-lspconfig/issues/3189
							library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
								"${3rd}/luv/library",
								"${3rd}/busted/library",
							}),
						},
					})
				end,
				settings = {
					Lua = {
						format = { enable = false }, -- Disable formatting (formatting is done by stylua)
					},
				},
			},
		}

		-- Install the above servers
		local ensure_installed = vim.tbl_keys(servers or {})
		-- Install additional tools (linters, formatters, DAPs)
		vim.list_extend(ensure_installed, {
			"jdtls",
			"java-debug-adapter",
			"java-test",
            "markdownlint-cli2",
			"phpcs",
			"php-cs-fixer",
			"stylua",
            "twigcs",
		})

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		for name, server in pairs(servers) do
			vim.lsp.config(name, server)
			vim.lsp.enable(name)
		end
	end,
}
