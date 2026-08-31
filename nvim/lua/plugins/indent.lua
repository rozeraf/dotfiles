return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "│",
				highlight = "IblIndent",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = { "alpha", "oil", "toggleterm", "help", "lazy" },
			},
		},
	},
}
