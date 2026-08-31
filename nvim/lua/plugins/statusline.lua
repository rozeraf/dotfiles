return {
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

}
