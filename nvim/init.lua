-- init.lua
-- Target: Neovim 0.12+

-- ─── leader ────────────────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ─── lazy.nvim bootstrap ──────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- ─── общие настройки ──────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.termguicolors = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Не включаем unnamedplus глобально: c/s и прочие операции остаются на Vim-регистрах.
-- Только обычные d/y/x/p работают с системным буфером обмена (+ register).
vim.opt.clipboard = ""

local clipboard_map_opts = { silent = true }

-- delete -> system clipboard
vim.keymap.set({ "n", "x" }, "d", '"+d', clipboard_map_opts)
vim.keymap.set("n", "D", '"+D', clipboard_map_opts)

-- yank -> system clipboard
vim.keymap.set({ "n", "x" }, "y", '"+y', clipboard_map_opts)
vim.keymap.set("n", "Y", '"+Y', clipboard_map_opts)

-- delete char -> system clipboard
vim.keymap.set({ "n", "x" }, "x", '"+x', clipboard_map_opts)
vim.keymap.set("n", "X", '"+X', clipboard_map_opts)

-- paste <- system clipboard
vim.keymap.set({ "n", "x" }, "p", '"+p', clipboard_map_opts)
vim.keymap.set({ "n", "x" }, "P", '"+P', clipboard_map_opts)

-- Сохранить всё и выйти.
vim.keymap.set("n", "<leader>xa", "<cmd>wa<cr><cmd>qa<cr>", { desc = "save all and quit" })

-- ─── VS Code ──────────────────────────────────────────────────────────────
if vim.g.vscode then
	require("lazy").setup({
		{ "tpope/vim-surround" },
		{ "wellle/targets.vim" },

		{
			url = "https://codeberg.org/andyg/leap.nvim",
			config = function()
				vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
			end,
		},

		{
			"rrethy/vim-illuminate",
			opts = {
				delay = 100,
				under_cursor = true,
			},
		},

		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {},
		},
	})

-- ─── обычный Neovim ───────────────────────────────────────────────────────
else
	vim.opt.relativenumber = true

	-- ─── highlights ────────────────────────────────────────────────────────
	local function apply_highlights()
		local float_bg = "#252535"
		local float_border = "#45475a"

		if vim.g.neovide then
			vim.api.nvim_set_hl(0, "Normal", { bg = "#101010" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "#101010" })
		else
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
		end

		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })

		-- ToggleTerm
		vim.api.nvim_set_hl(0, "ToggleTerm1Normal", { bg = "#1a1a2e" })
		vim.api.nvim_set_hl(0, "ToggleTermNormal", { bg = "#1a1a2e" })
		vim.api.nvim_set_hl(0, "TerminalBackground", { bg = "#1a1a2e" })

		-- nvim-cmp
		vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e30" })
		vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#45475a", bg = "#1e1e30" })
		vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = float_bg })
		vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#89dceb", bold = true })
		vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#cba6f7" })

		-- Floating windows
		vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#cdd6f4", bg = float_bg })
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "Pmenu", { fg = "#cdd6f4", bg = float_bg })
		vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#313244" })
		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#585b70" })

		-- Telescope
		vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = float_bg })
		vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#2a2a3d" })
		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = float_border, bg = "#2a2a3d" })
		vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = float_border, bg = float_bg })

		-- Noice
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = float_bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = float_border, bg = float_bg })

		-- Bufferline / tabline
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#1e1e2e", fg = "#1e1e2e" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "#1e1e2e", fg = "#585b70" })

		-- Alpha
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#585b70", italic = true })
		vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#cba6f7", bold = true })
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("UserHighlights", { clear = true }),
		callback = apply_highlights,
	})

	-- ─── LSP keymaps ───────────────────────────────────────────────────────
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
		callback = function(event)
			local opts = { buffer = event.buf }

			-- Оставляем короткие привычные переходы.
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

			-- Встроенные Neovim 0.12 mappings вроде grn/gra/gri/grr/K/[d/]d не перетираем.
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, opts)
		end,
	})

	-- ─── диагностика ───────────────────────────────────────────────────────
	local diagnostic_signs = {
		[vim.diagnostic.severity.ERROR] = " ",
		[vim.diagnostic.severity.WARN] = " ",
		[vim.diagnostic.severity.INFO] = " ",
		[vim.diagnostic.severity.HINT] = "󰌵 ",
	}

	vim.diagnostic.config({
		virtual_text = {
			spacing = 2,
			source = "if_many",
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		signs = {
			text = diagnostic_signs,
		},
		float = {
			border = "rounded",
			source = true,
		},
	})

	-- ─── plugins ───────────────────────────────────────────────────────────
	require("lazy").setup({
		-- ─── motions / editing ──────────────────────────────────────────────
		{ "tpope/vim-surround" },
		{ "wellle/targets.vim" },

		{
			url = "https://codeberg.org/andyg/leap.nvim",
			config = function()
				vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
			end,
		},

		{
			"rrethy/vim-illuminate",
			event = { "BufReadPost", "BufNewFile" },
			opts = {
				delay = 100,
				under_cursor = true,
			},
		},

		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {},
		},

		-- В Neovim 0.12 gc/gcc уже встроены, поэтому vim-commentary больше не нужен.

		-- ─── colorscheme / UI ───────────────────────────────────────────────
		{
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					transparent_background = true,
				})
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
		},

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = { "MunifTanjim/nui.nvim" },
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
			},
		},

		{
			"j-hui/fidget.nvim",
			event = "VeryLazy",
			opts = {},
		},

		-- ─── Git ─────────────────────────────────────────────────────────────
		{
			"tpope/vim-fugitive",
			cmd = {
				"Git",
				"G",
				"Gdiffsplit",
				"Gvdiffsplit",
				"Gread",
				"Gwrite",
				"Ggrep",
				"GMove",
				"GDelete",
			},
		},

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
			"NeogitOrg/neogit",
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

		-- ─── file explorers ──────────────────────────────────────────────────
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
				"MunifTanjim/nui.nvim",
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

		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = {
				{ "-", "<cmd>Oil<cr>", desc = "open parent directory (oil)" },
			},
			opts = {
				view_options = { show_hidden = true },
				columns = { "icon", "permissions", "size", "mtime" },
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
			},
		},

		-- ─── diagnostics / symbols ───────────────────────────────────────────
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = "Trouble",
			keys = {
				{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics (project)" },
				{
					"<leader>xb",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "diagnostics (buffer)",
				},
				{ "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "symbols" },
				{ "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", desc = "lsp references" },
			},
			opts = {},
		},

		-- ─── Telescope ───────────────────────────────────────────────────────
		{
			"nvim-telescope/telescope.nvim",
			cmd = "Telescope",
			dependencies = { "nvim-lua/plenary.nvim" },
			keys = {
				{
					"<leader>ff",
					function()
						require("telescope.builtin").find_files()
					end,
					desc = "find files",
				},
				{
					"<leader>fg",
					function()
						require("telescope.builtin").live_grep()
					end,
					desc = "live grep",
				},
				{
					"<leader>fb",
					function()
						require("telescope.builtin").buffers()
					end,
					desc = "buffers",
				},
				{
					"<leader>fh",
					function()
						require("telescope.builtin").help_tags()
					end,
					desc = "help tags",
				},
				{
					"<leader>fr",
					function()
						require("telescope.builtin").oldfiles()
					end,
					desc = "recent files",
				},
				{
					"<leader>fs",
					function()
						require("telescope.builtin").lsp_document_symbols()
					end,
					desc = "document symbols",
				},
				{
					"<leader>fd",
					function()
						require("telescope.builtin").diagnostics()
					end,
					desc = "diagnostics",
				},
			},
			opts = {},
		},

		-- ─── search & replace ────────────────────────────────────────────────
		{
			"MagicDuck/grug-far.nvim",
			cmd = { "GrugFar", "GrugFarWithin" },
			keys = {
				{
					"<leader>sr",
					function()
						require("grug-far").open({
							prefills = { search = vim.fn.expand("<cword>") },
						})
					end,
					desc = "search and replace (word under cursor)",
				},
				{
					"<leader>sr",
					function()
						require("grug-far").with_visual_selection()
					end,
					mode = "x",
					desc = "search and replace (selection)",
				},
			},
			opts = {
				windowCreationCommand = "vsplit",
			},
		},

		-- ─── Treesitter (new main branch / Neovim 0.12+) ────────────────────
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				local ts = require("nvim-treesitter")

				local parsers = {
					"lua",
					"python",
					"javascript",
					"typescript",
					"tsx",
					"rust",
					"c",
					"cpp",
					"html",
					"css",
					"json",
					"markdown",
					"markdown_inline",
				}

				ts.setup({})
				ts.install(parsers)

				local filetypes = {
					"lua",
					"python",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"rust",
					"c",
					"cpp",
					"html",
					"css",
					"json",
					"markdown",
				}

				vim.api.nvim_create_autocmd("FileType", {
					group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
					pattern = filetypes,
					callback = function(args)
						-- На первом запуске parser может ещё устанавливаться, поэтому не падаем.
						pcall(vim.treesitter.start, args.buf)

						-- Экспериментальный Treesitter indent из нового nvim-treesitter.
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end,
				})
			end,
		},

		-- ─── autopairs ───────────────────────────────────────────────────────
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			dependencies = { "hrsh7th/nvim-cmp" },
			config = function()
				require("nvim-autopairs").setup({
					check_ts = true,
					ts_config = {
						lua = { "string" },
						javascript = { "template_string" },
						typescript = { "template_string" },
					},
				})

				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- ─── completion ──────────────────────────────────────────────────────
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
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
						["<C-Space>"] = cmp.mapping.complete(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
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
						["<C-e>"] = cmp.mapping.abort(),
						["<C-u>"] = cmp.mapping.scroll_docs(-4),
						["<C-d>"] = cmp.mapping.scroll_docs(4),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "codeium" },
						{ name = "luasnip" },
						{ name = "path" },
					}, {
						{ name = "buffer" },
					}),
					formatting = {
						format = function(entry, item)
							local kind_icons = {
								Text = "󰉿",
								Method = "󰆧",
								Function = "󰊕",
								Constructor = "",
								Field = "󰇽",
								Variable = "󰂡",
								Class = "󰠱",
								Interface = "",
								Module = "",
								Property = "󰜢",
								Unit = "󰑭",
								Value = "󰎠",
								Enum = "",
								Keyword = "󰌋",
								Snippet = "",
								Color = "󰏘",
								File = "󰈙",
								Reference = "󰈇",
								Folder = "󰉋",
								EnumMember = "",
								Constant = "󰏿",
								Struct = "󰙅",
								Event = "",
								Operator = "󰆕",
								TypeParameter = "󰅲",
								Codeium = "",
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

		-- ─── AI completion (Windsurf / Codeium source) ───────────────────────
		{
			"Exafunction/windsurf.nvim",
			event = "InsertEnter",
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

		-- ─── linting ─────────────────────────────────────────────────────────
		{
			"mfussenegger/nvim-lint",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lint = require("lint")

				lint.linters_by_ft = {
					javascript = { "eslint_d" },
					typescript = { "eslint_d" },
					javascriptreact = { "eslint_d" },
					typescriptreact = { "eslint_d" },
					python = { "ruff" },
				}

				vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
					group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
					callback = function()
						lint.try_lint()
					end,
				})
			end,
		},

		-- ─── formatting ──────────────────────────────────────────────────────
		{
			"stevearc/conform.nvim",
			event = "BufWritePre",
			cmd = "ConformInfo",
			opts = {
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
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = {
					timeout_ms = 500,
				},
			},
		},

		-- ─── Mason + LSP ─────────────────────────────────────────────────────
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = {
				{
					"mason-org/mason.nvim",
					config = function()
						require("mason").setup()

						local registry = require("mason-registry")
						local tools = {
							"prettier",
							"stylua",
							"black",
							"eslint_d",
							"ruff",
							"clang-format",
						}

						for _, tool in ipairs(tools) do
							local ok, package = pcall(registry.get_package, tool)
							if ok and not package:is_installed() then
								package:install()
							end
						end
					end,
				},
				{
					"neovim/nvim-lspconfig",
					dependencies = { "hrsh7th/cmp-nvim-lsp" },
					config = function()
						local capabilities = require("cmp_nvim_lsp").default_capabilities()

						vim.lsp.config("*", {
							capabilities = capabilities,
						})

						vim.lsp.config("clangd", {
							cmd = { "clangd", "--background-index", "--clang-tidy" },
						})

						vim.lsp.config("lua_ls", {
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										checkThirdParty = false,
										library = {
											vim.env.VIMRUNTIME,
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

						vim.lsp.config("marksman", {})
					end,
				},
			},
			opts = {
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"clangd",
					"emmet_language_server",
					"marksman",
				},
			},
		},

		-- ─── statusline ──────────────────────────────────────────────────────
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = "VeryLazy",
			config = function()
				require("lualine").setup({
					options = { theme = "auto" },
					sections = {
						lualine_c = {
							{ "filename" },
							{
								"diagnostics",
								symbols = {
									error = " ",
									warn = " ",
									info = " ",
									hint = "󰌵 ",
								},
							},
						},
					},
				})
			end,
		},

		-- ─── bufferline ──────────────────────────────────────────────────────
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			event = "VeryLazy",
			config = function()
				require("bufferline").setup({
					options = {
						mode = "buffers",
						separator_style = "slant",
						diagnostics = "nvim_lsp",
						diagnostics_indicator = function(_, _, diag)
							local result = ""
							if diag.error then
								result = result .. "  " .. diag.error
							end
							if diag.warning then
								result = result .. "  " .. diag.warning
							end
							return result
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

				vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "next buffer" })
				vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "prev buffer" })
				vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "close buffer" })
				vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "pin buffer" })

				for i = 1, 9 do
					vim.keymap.set("n", "<leader>" .. i, function()
						require("bufferline").go_to(i, true)
					end, { desc = "buffer " .. i })
				end
			end,
		},

		-- ─── terminal ────────────────────────────────────────────────────────
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			cmd = "ToggleTerm",
			keys = {
				{ "<C-`>", "<cmd>ToggleTerm<cr>", desc = "terminal" },
				{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "terminal (float)" },
				{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "terminal (horizontal)" },
				{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "terminal (vertical)" },
			},
			config = function()
				require("toggleterm").setup({
					size = 15,
					open_mapping = [[<C-`>]],
					direction = "horizontal",
					shade_terminals = false,
					persist_size = true,
					persist_mode = true,
					highlights = {
						Normal = { guibg = "#1a1a2e" },
						NormalFloat = { guibg = "#1a1a2e" },
						FloatBorder = { guifg = "#45475a", guibg = "#1a1a2e" },
					},
					float_opts = {
						border = "curved",
						width = function()
							return math.floor(vim.o.columns * 0.85)
						end,
						height = function()
							return math.floor(vim.o.lines * 0.8)
						end,
						winblend = 0,
					},
				})

				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "exit terminal mode" })
				vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]])
				vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]])
				vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]])
				vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]])
			end,
		},

		-- ─── dashboard ───────────────────────────────────────────────────────
		{
			"goolord/alpha-nvim",
			event = "VimEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = {
				{ "<leader>a", "<cmd>Alpha<cr>", desc = "dashboard" },
			},
			config = function()
				local alpha = require("alpha")
				local dashboard = require("alpha.themes.dashboard")

				dashboard.section.header.val = {
					"                                                     ",
					"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
					"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
					"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
					"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
					"                                                     ",
				}

				dashboard.section.buttons.val = {
					dashboard.button("f", "  Find File", "<cmd>Telescope find_files<cr>"),
					dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<cr>"),
					dashboard.button("g", "  Live Grep", "<cmd>Telescope live_grep<cr>"),
					dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<cr>"),
					dashboard.button("c", "  Config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<cr>"),
					dashboard.button("p", "  Plugins", "<cmd>Lazy<cr>"),
					dashboard.button("m", "  Mason", "<cmd>Mason<cr>"),
					dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
				}

				dashboard.section.footer.val = (function()
					local stats = require("lazy").stats()
					local version = vim.version()
					return string.format(
						"  nvim v%d.%d.%d    %d plugins loaded",
						version.major,
						version.minor,
						version.patch,
						stats.loaded
					)
				end)()

				dashboard.section.header.opts.hl = "AlphaHeader"
				dashboard.section.buttons.opts.hl = "AlphaButtons"
				dashboard.section.footer.opts.hl = "AlphaFooter"

				dashboard.opts.layout = {
					{ type = "padding", val = 4 },
					dashboard.section.header,
					{ type = "padding", val = 2 },
					dashboard.section.buttons,
					{ type = "padding", val = 2 },
					dashboard.section.footer,
				}

				dashboard.opts.opts.noautocmd = true
				alpha.setup(dashboard.opts)

				vim.api.nvim_create_autocmd("BufDelete", {
					group = vim.api.nvim_create_augroup("AlphaReopen", { clear = true }),
					callback = function()
						local bufs = vim.fn.getbufinfo({ buflisted = true })
						if #bufs == 0 then
							alpha.start(true)
						end
					end,
				})

				vim.api.nvim_create_autocmd("User", {
					group = vim.api.nvim_create_augroup("AlphaBars", { clear = true }),
					pattern = "AlphaReady",
					callback = function()
						local alpha_buf = vim.api.nvim_get_current_buf()
						local previous_showtabline = vim.o.showtabline
						local previous_laststatus = vim.o.laststatus

						vim.o.showtabline = 0
						vim.o.laststatus = 0

						vim.api.nvim_create_autocmd("BufUnload", {
							buffer = alpha_buf,
							once = true,
							callback = function()
								vim.o.showtabline = previous_showtabline
								vim.o.laststatus = previous_laststatus
							end,
						})
					end,
				})
			end,
		},

		-- ─── sessions ────────────────────────────────────────────────────────
		{
			"folke/persistence.nvim",
			event = "BufReadPre",
			opts = {
				dir = vim.fn.stdpath("state") .. "/sessions/",
				options = { "buffers", "curdir", "tabpages", "winsize" },
			},
			keys = {
				{
					"<leader>qs",
					function()
						require("persistence").load()
					end,
					desc = "restore session (cwd)",
				},
				{
					"<leader>ql",
					function()
						require("persistence").load({ last = true })
					end,
					desc = "restore last session",
				},
				{
					"<leader>qd",
					function()
						require("persistence").stop()
					end,
					desc = "don't save session on exit",
				},
			},
		},

		-- ─── markdown render ─────────────────────────────────────────────────
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
					signs = { "󰫎 " },
				},
				code = {
					enabled = true,
					style = "full",
					width = "block",
				},
				bullet = { enabled = true },
				checkbox = {
					enabled = true,
					unchecked = { icon = "󰄱 " },
					checked = { icon = "󰱒 " },
				},
				pipe_table = { enabled = true },
				latex = { enabled = false },
			},
		},

		-- ─── breadcrumbs ─────────────────────────────────────────────────────
		{
			"SmiteshP/nvim-navic",
			dependencies = { "neovim/nvim-lspconfig" },
			opts = {
				lsp = { auto_attach = false },
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
			},
		},

		{
			"utilyre/barbecue.nvim",
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
			},
			opts = {
				attach_navic = true,
				show_dirname = false,
				show_basename = true,
				theme = "catppuccin-mocha",
				exclude_filetypes = { "neo-tree", "toggleterm", "alpha" },
			},
		},

		-- ─── indent guides ───────────────────────────────────────────────────
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			event = { "BufReadPost", "BufNewFile" },
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
					for _, hl in ipairs(indent_hls) do
						vim.api.nvim_set_hl(0, hl, { fg = "#313244" })
					end
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
						filetypes = { "alpha", "neo-tree", "toggleterm", "help", "lazy", "mason" },
					},
				})
			end,
		},
	})

	-- Применяем пользовательские highlights ещё раз после загрузки стартовых плагинов.
	apply_highlights()
end

-- ─── Neovide ──────────────────────────────────────────────────────────────
if vim.g.neovide then
	vim.g.neovide_opacity = 1.0
	vim.g.neovide_normal_opacity = 0.88
end
