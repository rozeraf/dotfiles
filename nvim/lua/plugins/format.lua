return {
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
				format_on_save = {
					timeout_ms = 500,
				},
			},
		},

}
