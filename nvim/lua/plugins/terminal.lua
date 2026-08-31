return {
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

}
