return {
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
}
