-- init.lua

-- ─── lazy.nvim bootstrap ───────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ─── общие настройки (работают везде) ─────────────────────────────────────
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
-- d/x удаляют в никуда (кроме terminal/prompt)
local function safe_del(key)
	return function()
		if vim.bo.buftype == "terminal" or vim.bo.buftype == "prompt" then
			return key
		end
		return '"_' .. key
	end
end

vim.keymap.set({ "n", "v" }, "d", safe_del("d"), { expr = true })
vim.keymap.set("n", "dd", safe_del("dd"), { expr = true })
vim.keymap.set({ "n", "v" }, "x", safe_del("x"), { expr = true })

-- leader+d — явное вырезание в буфер обмена
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')
vim.keymap.set("n", "<leader>dd", '"+dd')

-- leader+xa - сохранить и выйти из всех буферов
vim.keymap.set("n", "<leader>xa", "<cmd>wa<cr><cmd>qa<cr>", { desc = "save all and quit" })

-- ─── vscode ────────────────────────────────────────────────────────────────
if vim.g.vscode then
	require("lazy").setup({
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },

		{ "tpope/vim-surround" },
		{ "tpope/vim-commentary" },
		{ "wellle/targets.vim" },
		{
			"rrethy/vim-illuminate",
			config = function()
				require("illuminate").configure({
					delay = 100,
					under_cursor = true,
				})
			end,
		},
		{
			url = "https://codeberg.org/andyg/leap.nvim",
			config = function()
				vim.keymap.set({ "n", "x", "o" }, "s", "<plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "s", "<plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<plug>(leap-from-window)")
			end,
		},

		{
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({})
			end,
		},

		{ "tpope/vim-fugitive" },

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("telescope").setup({})
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":tsupdate",
			main = "nvim-treesitter.config",
			opts = {
				ensure_installed = { "lua", "python", "javascript", "typescript", "rust" },
				highlight = { enable = false },
				indent = { enable = true },
			},
		},
	})

-- ─── обычный neovim ────────────────────────────────────────────────────────
else
	vim.opt.relativenumber = true

	vim.opt.number = true
	vim.cmd("syntax on")

	vim.cmd([[
    hi normal       guibg=none ctermbg=none
    hi normalnc     guibg=none ctermbg=none
    hi endofbuffer  guibg=none ctermbg=none
    hi linenr       guibg=none ctermbg=none
    hi signcolumn   guibg=none ctermbg=none
  ]])
	-- toggleterm
	vim.api.nvim_set_hl(0, "ToggleTerm1Normal", { bg = "#1a1a2e" })
	vim.api.nvim_set_hl(0, "ToggleTermNormal", { bg = "#1a1a2e" })
	vim.api.nvim_set_hl(0, "TerminalBackground", { bg = "#1a1a2e" })

	-- cmp (автодополнение)
	vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e30" })
	vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#45475a", bg = "#1e1e30" })
	vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#252535" })
	vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#45475a", bg = "#252535" })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#89b4fa", bold = true })
	vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#89dceb", bold = true })
	vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#cba6f7" })
	-- TabLine уголки (рисуются поверх bufferline)
	local function fix_tabline_hl()
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#1e1e2e", fg = "#1e1e2e" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "#1e1e2e", fg = "#585b70" })
	end
	fix_tabline_hl()
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			fix_tabline_hl()
			-- cmp
			vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e30" })
			vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#45475a", bg = "#1e1e30" })
			vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#252535" })
			vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#45475a", bg = "#252535" })
			-- float
			vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#cdd6f4", bg = "#252535" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#45475a", bg = "#252535" })
		end,
	})
	-- floating-окна не должны быть прозрачными
	local float_bg = "#252535"
	local float_border = "#45475a"
	vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#cdd6f4", bg = float_bg })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_border, bg = float_bg })
	vim.api.nvim_set_hl(0, "Pmenu", { fg = "#cdd6f4", bg = float_bg })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
	vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#313244" })
	vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#585b70" })
	-- telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = float_bg })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = float_border, bg = float_bg })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#2a2a3d" })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = float_border, bg = "#2a2a3d" })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = float_border, bg = float_bg })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = float_border, bg = float_bg })
	-- noice
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = float_bg })
	vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = float_border, bg = float_bg })
	-- lsp keymaps (применяются при attach)
	vim.api.nvim_create_autocmd("lspattach", {
		callback = function(event)
			local opts = { buffer = event.buf }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		end,
	})

	-- диагностика: иконки в gutter
	local signs = { Error = "", Warn = "", Info = "", Hint = "" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		signs = true,
	})

	require("lazy").setup({
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },

		{ "tpope/vim-surround" },
		{ "tpope/vim-commentary" },
		{ "wellle/targets.vim" },

		{
			url = "https://codeberg.org/andyg/leap.nvim",
			config = function()
				vim.keymap.set({ "n", "x", "o" }, "s", "<plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "s", "<plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<plug>(leap-from-window)")
			end,
		},

		{
			"j-hui/fidget.nvim",
			config = function()
				require("fidget").setup({})
			end,
		},

		{
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({})
			end,
		},

		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					transparent_background = true,
				})
				vim.cmd("colorscheme catppuccin-mocha")
			end,
		},

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = { "muniftanjim/nui.nvim" },
			opts = {
				cmdline = { view = "cmdline" },
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = true,
						auto_open = { enabled = true, trigger = true },
					},
					hover = { enabled = true },
				},
				presets = {
					bottom_search = true,
					command_palette = false,
					long_message_to_split = true,
					lsp_doc_border = true,
				},
				views = {
					cmdline_popup = {
						position = { row = "100%", col = 0 },
						size = { width = "100%", height = "auto" },
						border = { style = "none", padding = { 0, 1 } },
					},
				},
			},
		},

		{ "tpope/vim-fugitive" },

		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"muniftanjim/nui.nvim",
			},
			keys = {
				{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "toggle file tree" },
			},
			opts = {
				window = {
					position = "right",
					width = 35,
					mappings = {
						["l"] = "open",
						["h"] = "close_node",
					},
				},
				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
					},
					follow_current_file = {
						enabled = true,
					},
				},
			},
		},

		-- ─── диагностика по всему проекту ───────────────────────────────────
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("trouble").setup({})
				vim.keymap.set(
					"n",
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					{ desc = "diagnostics (project)" }
				)
				vim.keymap.set(
					"n",
					"<leader>xb",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					{ desc = "diagnostics (buffer)" }
				)
				vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "symbols" })
				vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "lsp references" })
			end,
		},

		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				require("telescope").setup({})
				vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
				vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
				vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
				vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
				vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles)
				vim.keymap.set("n", "<leader>fs", require("telescope.builtin").lsp_document_symbols)
				vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics)
			end,
		},

		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("oil").setup({
					view_options = { show_hidden = true },
					columns = { "icon", "size", "mtime" },
					buf_options = { buflisted = false, bufhidden = "hide" },
					default_file_explorer = true,
					float = { padding = 2, max_width = 80, max_height = 30 },
					keymaps = {
						["g?"] = "actions.show_help",
						["<cr>"] = "actions.select",
						["<c-v>"] = { "actions.select", opts = { vertical = true } },
						["<c-s>"] = { "actions.select", opts = { horizontal = true } },
						["<c-t>"] = { "actions.select", opts = { tab = true } },
						["<c-p>"] = "actions.preview",
						["<c-c>"] = "actions.close",
						["<c-r>"] = "actions.refresh",
						["-"] = "actions.parent",
						["_"] = "actions.open_cwd",
						["`"] = "actions.cd",
						["~"] = { "actions.cd", opts = { scope = "tab" } },
						["gs"] = "actions.change_sort",
						["gx"] = "actions.open_external",
						["g."] = "actions.toggle_hidden",
						["l"] = "actions.select",
						["h"] = "actions.parent",
					},
					use_default_keymaps = false,
				})
				vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "open parent directory (oil)" })
			end,
		},

		{
			"magicduck/grug-far.nvim",
			config = function()
				require("grug-far").setup({
					windowcreationcommand = "vsplit",
					extrargargs = "",
					resultsseparatorlinechar = "─",
				})
				vim.keymap.set("n", "<leader>sr", function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end, { desc = "search and replace (word under cursor)" })
				vim.keymap.set("v", "<leader>sr", function()
					require("grug-far").with_visual_selection()
				end, { desc = "search and replace (selection)" })
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":tsupdate",
			lazy = false,
			config = function()
				require("nvim-treesitter.config").setup({
					ensure_installed = {
						"lua",
						"python",
						"javascript",
						"typescript",
						"tsx",
						"rust",
						"html",
						"css",
						"markdown",
						"markdown_inline",
					},
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},

		-- ─── autopairs (умнее ручных биндов) ────────────────────────────────
		-- ВНИМАНИЕ: убраны ручные биндинги (, [, {, ", ' из insert mode —
		-- autopairs их полностью заменяет с учётом treesitter-контекста
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup({
					check_ts = true,
					ts_config = {
						lua = { "string" },
						javascript = { "template_string" },
						typescript = { "template_string" },
					},
				})
				-- интеграция с cmp: скобка добавляется после confirm
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- ─── автодополнение ─────────────────────────────────────────────────
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"l3mon4d3/luasnip",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered({
							winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel",
						}),
						documentation = cmp.config.window.bordered({
							winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
						}),
					},
					mapping = cmp.mapping.preset.insert({
						["<c-space>"] = cmp.mapping.complete(),
						["<cr>"] = cmp.mapping.confirm({ select = true }),
						["<tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<s-tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<c-e>"] = cmp.mapping.abort(),
						["<c-u>"] = cmp.mapping.scroll_docs(-4),
						["<c-d>"] = cmp.mapping.scroll_docs(4),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "codeium" },
						{ name = "luasnip" },
						{ name = "path" },
					}, {
						{ name = "buffer" },
					}),
					-- внешний вид: тип источника и иконка
					formatting = {
						format = function(entry, item)
							local kind_icons = {
								Text = "",
								Method = "󰆧",
								Function = "󰊕",
								Constructor = "",
								Field = "󰇽",
								Variable = "󰂡",
								Class = "󰠱",
								Interface = "",
								Module = "",
								Property = "󰜢",
								Unit = "",
								Value = "󰎠",
								Enum = "",
								Keyword = "󰌋",
								Snippet = "",
								Color = "󰏘",
								File = "󰈙",
								Reference = "",
								Folder = "󰉋",
								EnumMember = "",
								Constant = "󰏿",
								Struct = "",
								Event = "",
								Operator = "󰆕",
								TypeParameter = "󰅲",
							}
							item.kind = string.format("%s %s", kind_icons[item.kind] or "", item.kind)
							item.menu = ({
								nvim_lsp = "[LSP]",
								codeium = "[AI]",
								luasnip = "[Snip]",
								buffer = "[Buf]",
								path = "[Path]",
							})[entry.source.name]
							return item
						end,
					},
				})
			end,
		},

		-- ─── AI автодополнение (Codeium) ─────────────────────────────────────
		-- Бесплатный без ограничений, ghost-text инлайн.
		-- При первом запуске выполни :Codeium Auth
		-- Принять: <C-l>, отклонить: <C-]>, принять слово: <C-j>
		{
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
			config = function()
				require("codeium").setup({
					enable_chat = false,
				})
			end,
		},

		-- ─── линтинг ────────────────────────────────────────────────────────
		{
			"mfussenegger/nvim-lint",
			config = function()
				local lint = require("lint")
				lint.linters_by_ft = {
					javascript = { "eslint_d" },
					typescript = { "eslint_d" },
					javascriptreact = { "eslint_d" },
					typescriptreact = { "eslint_d" },
				}
				vim.api.nvim_create_autocmd({ "bufwritepost", "bufreadpost", "insertleave" }, {
					callback = function()
						lint.try_lint()
					end,
				})
			end,
		},

		{
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						c = { "clang_format" },
						cpp = { "clang_format" },
						javascript = { "prettier" },
						typescript = { "prettier" },
						javascriptreact = { "prettier" },
						typescriptreact = { "prettier" },
						json = { "prettier" },
						html = { "prettier" },
						css = { "prettier" },
						lua = { "stylua" },
						python = { "black" },
					},
					format_on_save = {
						timeout_ms = 500,
						lsp_fallback = true,
					},
				})
			end,
		},

		-- ─── mason + lsp ────────────────────────────────────────────────────
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
				local mr = require("mason-registry")
				for _, tool in ipairs({
					"prettier",
					"stylua",
					"black",
					"eslint_d",
					"ruff",
					"clang-format",
					-- добавлены emmet и markdown lsp
					"emmet-language-server",
				}) do
					local ok, p = pcall(mr.get_package, tool)
					if ok and not p:is_installed() then
						p:install()
					end
				end
			end,
		},

		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "pyright", "ts_ls", "clangd", "emmet_language_server", "marksman" },
					automatic_enable = true,
				})
			end,
		},

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				vim.lsp.config("*", { capabilities = capabilities })

				vim.lsp.config("clangd", {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				})

				vim.lsp.config("lua_ls", {
					settings = {
						lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkthirdparty = false,
								library = {
									vim.fn.expand("$vimruntime/lua"),
									vim.fn.stdpath("data") .. "/lazy",
								},
							},
							telemetry = { enable = false },
						},
					},
				})

				vim.lsp.config("pyright", {})

				vim.lsp.config("ts_ls", {
					init_options = {
						preferences = {
							importModuleSpecifierPreference = "relative",
						},
						maxTsServerMemory = 4096,
					},
					settings = {
						typescript = {
							tsserver = {
								experimental = {
									enableProjectDiagnostics = true,
								},
							},
						},
						javascript = {
							tsserver = {
								experimental = {
									enableProjectDiagnostics = true,
								},
							},
						},
					},
				})

				-- emmet: html/css/jsx/tsx
				vim.lsp.config("emmet_language_server", {
					filetypes = {
						"html",
						"css",
						"scss",
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
					},
				})

				-- marksman: markdown LSP (go-to, references, completions)
				vim.lsp.config("marksman", {})
			end,
		},

		-- ─── git ────────────────────────────────────────────────────────────
		{
			"sindrets/diffview.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = { "DiffviewOpen", "DiffviewFileHistory" },
			keys = {
				{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "diffview (working tree)" },
				{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "diffview (file history)" },
				{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "diffview (repo history)" },
				{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "diffview close" },
			},
		},

		{
			"neogitorg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
				"nvim-telescope/telescope.nvim",
			},
			cmd = "Neogit",
			keys = {
				{ "<leader>gg", "<cmd>Neogit<cr>", desc = "neogit" },
			},
			opts = {
				integrations = {
					diffview = true,
					telescope = true,
				},
			},
		},

		{
			"rrethy/vim-illuminate",
			config = function()
				require("illuminate").configure({
					delay = 100,
					under_cursor = true,
				})
			end,
		},

		-- ─── statusline ─────────────────────────────────────────────────────
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = { theme = "auto" },
					sections = {
						lualine_c = {
							{ "filename" },
							{
								"diagnostics",
								sources = { "nvim_diagnostic" },
								symbols = { error = " ", warn = " ", info = " ", hint = " " },
							},
						},
					},
				})
			end,
		},

		-- ─── bufferline (вкладки файлов) ────────────────────────────────────
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("bufferline").setup({
					options = {
						mode = "buffers",
						separator_style = "slant",
						diagnostics = "nvim_lsp",
						diagnostics_indicator = function(_, _, diag)
							local s = ""
							if diag.error then
								s = s .. " " .. diag.error
							end
							if diag.warning then
								s = s .. " " .. diag.warning
							end
							return s
						end,
						offsets = {
							{
								filetype = "neo-tree",
								text = "File Explorer",
								highlight = "Directory",
								separator = true,
							},
						},
						show_buffer_close_icons = true,
						show_close_icon = false,
						color_icons = true,
					},
				})
				-- навигация между буферами
				vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "next buffer" })
				vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "prev buffer" })
				vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "close buffer" })
				vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "pin buffer" })
				-- прыжок по номеру (1-9)
				for i = 1, 9 do
					vim.keymap.set("n", "<leader>" .. i, function()
						require("bufferline").go_to(i, true)
					end, { desc = "buffer " .. i })
				end
			end,
		},

		-- ─── встроенный терминал ─────────────────────────────────────────────
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = function()
				require("toggleterm").setup({
					size = 15,
					open_mapping = [[<C-`>]],
					direction = "horizontal",
					shade_terminals = false, -- ← выключить, иначе перебивает цвет
					persist_size = true,
					persist_mode = true,
					highlights = {
						Normal = {
							guibg = "#1a1a2e",
						},
						NormalFloat = {
							guibg = "#1a1a2e",
						},
						FloatBorder = {
							guifg = "#45475a",
							guibg = "#1a1a2e",
						},
					},
					float_opts = {
						border = "curved",
						width = math.floor(vim.o.columns * 0.85),
						height = math.floor(vim.o.lines * 0.8),
						winblend = 0, -- ← без прозрачности
					},
				})
				-- float терминал
				vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "terminal (float)" })
				vim.keymap.set(
					"n",
					"<leader>th",
					"<cmd>ToggleTerm direction=horizontal<cr>",
					{ desc = "terminal (horizontal)" }
				)
				vim.keymap.set(
					"n",
					"<leader>tv",
					"<cmd>ToggleTerm direction=vertical size=60<cr>",
					{ desc = "terminal (vertical)" }
				)
				-- выход из terminal mode по Esc
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "exit terminal mode" })
				vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
				vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
				vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
				vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
			end,
		},

		-- ─── dashboard (стартовый экран) ─────────────────────────────────────
		{
			"nvimdev/dashboard-nvim",
			event = "VimEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("dashboard").setup({
					theme = "hyper",
					config = {
						week_header = { enable = true },
						shortcut = {
							{ desc = "  Find File", key = "f", action = "Telescope find_files", group = "Label" },
							{ desc = "  Recent", key = "r", action = "Telescope oldfiles", group = "Label" },
							{ desc = "  Grep", key = "g", action = "Telescope live_grep", group = "Label" },
							{
								desc = "  Config",
								key = "c",
								action = "edit " .. vim.fn.stdpath("config") .. "/init.lua",
								group = "Label",
							},
							{ desc = "  Quit", key = "q", action = "qa", group = "Label" },
						},
					},
				})
			end,
		},

		-- ─── markdown рендер (прямо в буфере) ───────────────────────────────
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
			ft = { "markdown" },
			opts = {
				heading = {
					enabled = true,
					-- уровни заголовков визуально отличаются размером/цветом
					signs = { "󰫎 " },
				},
				code = {
					enabled = true,
					style = "full", -- рамка вокруг code block
					width = "block",
				},
				bullet = { enabled = true },
				checkbox = {
					enabled = true,
					unchecked = { icon = "󰄱 " },
					checked = { icon = "󰱒 " },
				},
				table = { enabled = true },
				latex = { enabled = false }, -- включить если нужен latex
			},
		},

		-- ─── winbar / хлебные крошки ─────────────────────────────────────────
		{
			"SmiteshP/nvim-navic",
			dependencies = { "neovim/nvim-lspconfig" },
			config = function()
				require("nvim-navic").setup({
					lsp = { auto_attach = true },
					highlight = true,
					separator = " › ",
					depth_limit = 5,
					icons = {
						File = "󰈙 ",
						Module = " ",
						Namespace = "󰌗 ",
						Package = " ",
						Class = "󰠱 ",
						Method = "󰆧 ",
						Property = "󰜢 ",
						Field = "󰇽 ",
						Constructor = " ",
						Enum = "󰕘 ",
						Interface = "󰕘 ",
						Function = "󰊕 ",
						Variable = "󰂡 ",
						Constant = "󰏿 ",
						String = "󰀬 ",
						Number = "󰎠 ",
						Boolean = "◩ ",
						Array = "󰅪 ",
						Object = "󰅩 ",
						Key = "󰌋 ",
						Null = "󰟢 ",
						EnumMember = " ",
						Struct = "󰙅 ",
						Event = " ",
						Operator = "󰆕 ",
						TypeParameter = "󰊄 ",
					},
				})
			end,
		},

		{
			"utilyre/barbecue.nvim",
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
			},
			opts = {
				attach_navic = true, -- автоматически подключать к LSP
				show_dirname = false,
				show_basename = true,
				theme = "catppuccin-mocha",
				-- исключить некоторые filetypes
				exclude_filetypes = { "neo-tree", "toggleterm", "dashboard" },
			},
		},

		-- ─── отступы (вертикальные линии) ───────────────────────────────────
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			config = function()
				local hooks = require("ibl.hooks")

				local indent_hls = {
					"IblIndent1",
					"IblIndent2",
					"IblIndent3",
					"IblIndent4",
					"IblIndent5",
					"IblIndent6",
				}

				hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
					-- все уровни — приглушённый цвет
					for _, hl in ipairs(indent_hls) do
						vim.api.nvim_set_hl(0, hl, { fg = "#313244" })
					end
					-- активный (ближайший к курсору) блок — яркий
					vim.api.nvim_set_hl(0, "IblScope", { fg = "#89b4fa" })
				end)

				require("ibl").setup({
					indent = {
						char = "│",
						highlight = indent_hls,
					},
					scope = {
						enabled = true,
						char = "│",
						highlight = "IblScope",
						show_start = true,
						show_end = true,
						injected_languages = true,
						include = {
							node_type = {
								["*"] = {
									"function",
									"function_declaration",
									"arrow_function",
									"function_expression",
									"method_definition",
									"class",
									"class_declaration",
									"class_body",
									"if_statement",
									"else_clause",
									"for_statement",
									"for_in_statement",
									"while_statement",
									"do_statement",
									"switch_statement",
									"switch_case",
									"try_statement",
									"catch_clause",
									"finally_clause",
									"object",
									"array",
									"block",
									"statement_block",
									"with_statement",
									"decorated_definition",
									"table_constructor",
									"arguments",
									"parameters",
								},
							},
						},
					},
					exclude = {
						filetypes = { "dashboard", "neo-tree", "toggleterm", "help", "lazy", "mason" },
					},
				})
			end,
		},
	})
end
