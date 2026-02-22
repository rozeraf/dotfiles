-- init.lua

-- ─── Lazy.nvim bootstrap ───────────────────────────────────────────────────
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

-- ─── Общие настройки (работают везде) ─────────────────────────────────────
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
-- d удаляет в никуда
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set("n", "dd", '"_dd')

-- x тоже
vim.keymap.set({ "n", "v" }, "x", '"_x')

-- leader+d — явное вырезание (в буфер обмена)
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')
vim.keymap.set("n", "<leader>dd", '"+dd')

-- leader+xa - сохранить и выйти из всех буферов
vim.keymap.set("n", "<leader>xa", "<cmd>wa<cr><cmd>qa<cr>", { desc = "Save all and quit" })

-- ─── VSCode ────────────────────────────────────────────────────────────────
if vim.g.vscode then
	require("lazy").setup({
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-tree/nvim-web-devicons" },

		{ "tpope/vim-surround" },
		{ "tpope/vim-commentary" },
		{ "wellle/targets.vim" },
		{
			"RRethy/vim-illuminate",
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
				vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
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
			build = ":TSUpdate",
			main = "nvim-treesitter.config",
			opts = {
				ensure_installed = { "lua", "python", "javascript", "typescript", "rust" },
				highlight = { enable = false },
				indent = { enable = true },
			},
		},
	})

-- ─── Обычный Neovim ────────────────────────────────────────────────────────
else
	vim.opt.relativenumber = false
	vim.cmd("syntax on")

	vim.cmd([[
    hi Normal       guibg=NONE ctermbg=NONE
    hi NormalNC     guibg=NONE ctermbg=NONE
    hi EndOfBuffer  guibg=NONE ctermbg=NONE
    hi LineNr       guibg=NONE ctermbg=NONE
    hi SignColumn   guibg=NONE ctermbg=NONE
  ]])

	vim.keymap.set("i", "(", "()<Left>")
	vim.keymap.set("i", "[", "[]<Left>")
	vim.keymap.set("i", "{", "{}<Left>")
	vim.keymap.set("i", '"', '""<Left>')
	vim.keymap.set("i", "'", "''<Left>")

	-- LSP keymaps (применяются при attach)
	vim.api.nvim_create_autocmd("LspAttach", {
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

	-- Диагностика: иконки в gutter
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			},
		},
		virtual_text = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
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
				vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
				vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
				vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
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
				"MunifTanjim/nui.nvim",
			},
			keys = {
				{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
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
		-- Диагностика по всему проекту
		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("trouble").setup({})
				vim.keymap.set(
					"n",
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					{ desc = "Diagnostics (project)" }
				)
				vim.keymap.set(
					"n",
					"<leader>xb",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					{ desc = "Diagnostics (buffer)" }
				)
				vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle<cr>", { desc = "Symbols" })
				vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "LSP References" })
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
						["<CR>"] = "actions.select",
						["<C-v>"] = { "actions.select", opts = { vertical = true } },
						["<C-s>"] = { "actions.select", opts = { horizontal = true } },
						["<C-t>"] = { "actions.select", opts = { tab = true } },
						["<C-p>"] = "actions.preview",
						["<C-c>"] = "actions.close",
						["<C-r>"] = "actions.refresh",
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
				vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)" })
			end,
		},

		{
			"MagicDuck/grug-far.nvim",
			config = function()
				require("grug-far").setup({
					windowCreationCommand = "vsplit",
					extraRgArgs = "",
					resultsSeparatorLineChar = "─",
				})
				vim.keymap.set("n", "<leader>sr", function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end, { desc = "Search and replace (word under cursor)" })
				vim.keymap.set("n", "<leader>sR", function()
					require("grug-far").open()
				end, { desc = "Search and replace (empty)" })
				vim.keymap.set("v", "<leader>sr", function()
					require("grug-far").with_visual_selection()
				end, { desc = "Search and replace (selection)" })
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			lazy = false,
			config = function()
				require("nvim-treesitter.config").setup({
					ensure_installed = { "lua", "python", "javascript", "typescript", "tsx", "rust" },
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},

		-- Автодополнение
		{
			"hrsh7th/nvim-cmp",
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
						{ name = "luasnip" },
						{ name = "path" },
					}, {
						{ name = "buffer" },
					}),
				})
			end,
		},

		-- Линтинг (eslint и др. — не через LSP)
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
				vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
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

		-- ─── Mason + LSP ────────────────────────────────────────────────────
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
				-- форматтеры и линтеры (не LSP-серверы)
				local mr = require("mason-registry")
				for _, tool in ipairs({ "prettier", "stylua", "black", "eslint_d", "ruff", "clang-format" }) do
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
					ensure_installed = { "lua_ls", "pyright", "ts_ls", "clangd" },
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

				-- capabilities для всех серверов
				vim.lsp.config("*", { capabilities = capabilities })
				vim.lsp.config("clangd", {
					cmd = { "clangd", "--background-index", "--clang-tidy" },
				})
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = {
								checkThirdParty = false,
								library = {
									vim.fn.expand("$VIMRUNTIME/lua"),
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
						preferences = { importModuleSpecifierPreference = "relative" },
					},
				})
			end,
		},

		-- ─── Git ────────────────────────────────────────────────────────────
		{
			"sindrets/diffview.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			cmd = { "DiffviewOpen", "DiffviewFileHistory" },
			keys = {
				{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview (working tree)" },
				{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview (file history)" },
				{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview (repo history)" },
				{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
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
				{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
			},
			opts = {
				integrations = {
					diffview = true,
					telescope = true,
				},
			},
		},

		{
			"RRethy/vim-illuminate",
			config = function()
				require("illuminate").configure({
					delay = 100,
					under_cursor = true,
				})
			end,
		},

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
	})
end
