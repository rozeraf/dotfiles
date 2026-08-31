return {
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

}
