return {
		-- ─── sessions ────────────────────────────────────────────────────────
		{
			"folke/persistence.nvim",
			event = "BufReadPre",
			opts = {
				dir = vim.fn.stdpath("state") .. "/sessions/",
				options = { "buffers", "curdir", "tabpages", "winsize" },
			},
			keys = {
				{
					"<leader>qs",
					function()
						require("persistence").load()
					end,
					desc = "restore session (cwd)",
				},
				{
					"<leader>ql",
					function()
						require("persistence").load({ last = true })
					end,
					desc = "restore last session",
				},
				{
					"<leader>qd",
					function()
						require("persistence").stop()
					end,
					desc = "don't save session on exit",
				},
			},
		},

}
