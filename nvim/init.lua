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

	-- Прозрачный фон
	vim.cmd([[
    hi Normal       guibg=NONE ctermbg=NONE
    hi NormalNC     guibg=NONE ctermbg=NONE
    hi EndOfBuffer  guibg=NONE ctermbg=NONE
    hi LineNr       guibg=NONE ctermbg=NONE
    hi SignColumn   guibg=NONE ctermbg=NONE
  ]])

	-- Автодополнение скобок
	vim.keymap.set("i", "(", "()<Left>")
	vim.keymap.set("i", "[", "[]<Left>")
	vim.keymap.set("i", "{", "{}<Left>")
	vim.keymap.set("i", '"', '""<Left>')
	vim.keymap.set("i", "'", "''<Left>")

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
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
			opts = {
				cmdline = {
					view = "cmdline",
				},
				-- ВКЛЮЧАЕМ ПОДСКАЗКИ (LSP)
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = true,
						auto_open = {
							enabled = true,
							trigger = true, -- Автоматически при вводе ( или ,
						},
					},
					hover = {
						enabled = true, -- Подсказки при наведении (K)
					},
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
			end,
		},

		-- ─── oil.nvim ───────────────────────────────────────────────────────
		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("oil").setup({
					-- показывать скрытые файлы по умолчанию
					view_options = {
						show_hidden = true,
					},
					-- колонки: иконка + размер + дата изменения
					columns = {
						"icon",
						"size",
						"mtime",
					},
					-- буфер oil ведёт себя как обычный буфер
					buf_options = {
						buflisted = false,
						bufhidden = "hide",
					},
					-- открывать в текущем окне, а не в сплите
					default_file_explorer = true,
					float = {
						padding = 2,
						max_width = 80,
						max_height = 30,
					},
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
					},
					-- отключаем дефолтные кеймапы, используем свои
					use_default_keymaps = false,
				})
				-- `-` в normal mode открывает oil для папки текущего файла
				vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)" })
			end,
		},

		-- ─── grug-far.nvim ──────────────────────────────────────────────────
		{
			"MagicDuck/grug-far.nvim",
			config = function()
				require("grug-far").setup({
					-- окно открывается справа
					windowCreationCommand = "vsplit",
					-- ripgrep флаги по умолчанию
					extraRgArgs = "",
					-- ширина окна (в процентах от редактора)
					resultsSeparatorLineChar = "─",
				})
				-- открыть с словом под курсором
				vim.keymap.set("n", "<leader>sr", function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end, { desc = "Search and replace (word under cursor)" })
				-- открыть пустым
				vim.keymap.set("n", "<leader>sR", function()
					require("grug-far").open()
				end, { desc = "Search and replace (empty)" })
				-- в visual mode — искать выделенное
				vim.keymap.set("v", "<leader>sr", function()
					require("grug-far").with_visual_selection()
				end, { desc = "Search and replace (selection)" })
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			lazy = false,
			config = function()
				require("nvim-treesitter.config").setup({
					ensure_installed = { "lua", "python", "javascript", "typescript", "rust" },
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"stevearc/conform.nvim",
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						javascript = { "prettier" },
						typescript = { "prettier" },
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
		-- LSP
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
				local mr = require("mason-registry")
				for _, tool in ipairs({ "prettier", "stylua", "black" }) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end,
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
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "pyright", "ts_ls" },
					automatic_installation = true,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
			config = function()
				vim.lsp.config("lua_ls", {})
				vim.lsp.config("pyright", {})
				vim.lsp.config("ts_ls", {})

				vim.lsp.enable({ "lua_ls", "pyright", "ts_ls" })
			end,
		},
		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = {
						theme = "auto",
					},
				})
			end,
		},
	})
end
