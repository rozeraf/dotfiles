return {
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
}
