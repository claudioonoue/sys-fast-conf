return {
	-- Completion source para LSP
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	-- Snippet engine principal
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		build = (function()
			if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
				return
			end
			return "make install_jsregexp"
		end)(),
		config = function()
			local luasnip = require("luasnip")
			
			-- Configurações do LuaSnip
			luasnip.config.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
			})
			
			-- Carrega snippets do VSCode
			require("luasnip.loaders.from_vscode").lazy_load()
			
			-- Keymaps para navegação de snippets
			vim.keymap.set({"i", "s"}, "<C-k>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { desc = "Expand/Jump snippet forward" })

			vim.keymap.set({"i", "s"}, "<C-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "Jump snippet backward" })
		end,
	},
	-- Sistema de completion principal
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Função helper para verificar se há espaço antes do cursor
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpDoc",
					}),
				},
				formatting = {
					format = function(entry, vim_item)
						-- Ícones para diferentes sources
						local kind_icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						}

						vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
							nvim_lsp_signature_help = "[Signature]",
						})[entry.source.name]
						
						return vim_item
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ 
						behavior = cmp.ConfirmBehavior.Replace,
						select = true 
					}),
					-- Super Tab like navigation
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ 
						name = "nvim_lsp",
						priority = 1000,
						max_item_count = 20,
					},
					{ 
						name = "luasnip",
						priority = 750,
						max_item_count = 5,
					},
					{
						name = "nvim_lsp_signature_help",
						priority = 500,
					},
				}, {
					{ 
						name = "buffer",
						priority = 250,
						keyword_length = 3,
						max_item_count = 10,
					},
					{
						name = "path",
						priority = 100,
					},
				}),
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
			})

			-- Configuração para busca (/)
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Configuração para comando (:)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!", "w", "q", "wq" },
						},
					},
				}),
			})
		end,
	},
	-- Gerenciador de pacotes para LSPs
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	-- Integração Mason com LSPConfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"html",
					"cssls",
					"jsonls",
					"bashls",
					"dockerls",
					"marksman", -- Melhor que markdown_oxide
					"clangd",
					"gopls",
					"ts_ls",
					"rust_analyzer",
					"sqlls",
					"pyright", -- Python LSP
					"yamlls",
				},
				automatic_enable = false,
			})
		end,
	},
	-- Formatters e linters
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls-extras.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			-- Configuração do mason-null-ls ANTES do null-ls
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"goimports-reviser",
					"goimports",
					"golangci_lint",
					"prettier",
					"eslint_d",
					"black",
					"isort",
				},
				methods = {
					diagnostics = false,
					formatting = false,
					code_actions = false,
					completion = false,
					hover = false,
				},
				automatic_installation = false,
				handlers = {},
			})

			null_ls.setup({
				border = "rounded",
				sources = {
					-- Formatters
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.formatting.goimports_reviser,
					null_ls.builtins.formatting.prettier.with({
						disabled_filetypes = { "html" },
						extra_filetypes = { "svelte" },
					}),
					null_ls.builtins.formatting.black, -- Python
					null_ls.builtins.formatting.isort, -- Python imports
					
					-- Diagnostics
					null_ls.builtins.diagnostics.golangci_lint,
					require("none-ls.diagnostics.eslint_d"),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ 
									async = false,
									filter = function(format_client)
										-- Use null-ls para formatação quando disponível
										return format_client.name == "null-ls"
									end
								})
							end,
						})
					end
				end,
			})
		end,
	},
	-- SchemaStore para validação JSON/YAML
	{
		"b0o/schemastore.nvim",
		lazy = true,
	},
	-- Configuração principal dos LSPs
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"b0o/schemastore.nvim",
		},
		config = function()
			-- Capabilities melhoradas
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)
			
			-- Configurações específicas por LSP
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = { vim.env.VIMRUNTIME },
							},
							completion = { callSnippet = "Replace" },
							diagnostics = { 
								globals = { "vim" },
								disable = { "missing-fields" }
							},
						},
					},
				},
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
						"--function-arg-placeholders",
						"--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
					},
				},
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = false,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							imports = {
								granularity = {
									group = "module",
								},
								prefix = "self",
							},
							cargo = {
								buildScripts = {
									enable = true,
								},
							},
							procMacro = {
								enable = true,
							},
						},
					},
				},
				ts_ls = {
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				jsonls = {
					settings = {
						json = {
							schemas = require('schemastore').json.schemas(),
							validate = { enable = true },
							format = { enable = true },
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								-- Deve ser desabilitado para usar o schemastore.nvim
								enable = false,
								-- Evita o TypeError: Cannot read properties of undefined (reading 'length')
								url = "",
							},
							schemas = require('schemastore').yaml.schemas(),
							validate = true,
							completion = true,
							hover = true,
						},
					},
				},
			}

			local lspconfig = require("lspconfig")
			
			-- Aplica configurações para cada servidor
			for server_name, server_config in pairs(servers) do
				server_config.capabilities = capabilities
				lspconfig[server_name].setup(server_config)
			end

			-- Servidores simples (só precisam de capabilities)
			local simple_servers = { "html", "cssls", "bashls", "dockerls", "marksman", "sqlls", "pyright" }
			for _, server in ipairs(simple_servers) do
				lspconfig[server].setup({ capabilities = capabilities })
			end

			-- Keymaps globais para diagnósticos
			local diagnostic_goto_opts = { float = { border = "rounded" } }
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev(diagnostic_goto_opts) end, { desc = "Go to previous diagnostic" })
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next(diagnostic_goto_opts) end, { desc = "Go to next diagnostic" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

			-- Configuração quando LSP se anexa ao buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					
					-- Omnifunc para completion manual
					vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Helper function para criar keymaps
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { 
							buffer = event.buf, 
							desc = "LSP: " .. desc,
							silent = true 
						})
					end

					-- Navegação
					if client.server_capabilities.definitionProvider then
						map("gd", function()
							require("telescope.builtin").lsp_definitions({ reuse_win = true })
						end, "[G]oto [D]efinition")
					end

					if client.server_capabilities.referencesProvider then
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					end

					if client.server_capabilities.implementationProvider then
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					end

					if client.server_capabilities.typeDefinitionProvider then
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					end

					-- Símbolos
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					-- Ações
					if client.server_capabilities.renameProvider then
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					end

					if client.server_capabilities.codeActionProvider then
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					end

					if client.server_capabilities.declarationProvider then
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					end

					if client.server_capabilities.hoverProvider then
						map("K", vim.lsp.buf.hover, "Hover Documentation")
					end

					-- Formatação
					if client.server_capabilities.documentFormattingProvider then
						map("<leader>ff", function()
							vim.lsp.buf.format({ async = false })
						end, "[F]ormat document")
					end

					-- Document highlighting
					if client.server_capabilities.documentHighlightProvider then
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

					-- Inlay hints (se disponível)
					if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Configuração de diagnósticos aprimorada
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					format = function(diagnostic)
						if diagnostic.severity == vim.diagnostic.severity.ERROR then
							return string.format("E: %s", diagnostic.message)
						elseif diagnostic.severity == vim.diagnostic.severity.WARN then
							return string.format("W: %s", diagnostic.message)
						elseif diagnostic.severity == vim.diagnostic.severity.INFO then
							return string.format("I: %s", diagnostic.message)
						else
							return string.format("H: %s", diagnostic.message)
						end
					end,
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚",
						[vim.diagnostic.severity.WARN] = "󰀪",
						[vim.diagnostic.severity.HINT] = "󰌶",
						[vim.diagnostic.severity.INFO] = "󰋽",
					},
				},
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
					format = function(diagnostic)
						return string.format("%s (%s)", diagnostic.message, diagnostic.source)
					end,
				},
			})

			-- Configurações de UI do LSP
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			})
		end,
	},
}
