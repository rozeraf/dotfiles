return {
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
					presets = {
						bottom_search = true,
						command_palette = false,
						long_message_to_split = true,
					},
				},
			},

}
