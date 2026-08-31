return {
		-- ─── file explorer ───────────────────────────────────────────────────
		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = {
				{ "-", "<cmd>Oil<cr>", desc = "open parent directory (oil)" },
			},
			opts = {
				view_options = { show_hidden = true },
				columns = { "icon", "permissions", "size", "mtime" },
				buf_options = { buflisted = false, bufhidden = "hide" },
				default_file_explorer = true,
				float = { padding = 2, max_width = 80, max_height = 30 },
				keymaps = {
					["g?"] = "actions.show_help",
					["<cr>"] = "actions.select",
					["<c-v>"] = { "actions.select", opts = { vertical = true } },
					["<c-s>"] = { "actions.select", opts = { horizontal = true } },
					["<c-t>"] = { "actions.select", opts = { tab = true } },
					["<c-p>"] = "actions.preview",
					["<c-c>"] = "actions.close",
					["<c-r>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = { "actions.cd", opts = { scope = "tab" } },
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["l"] = "actions.select",
					["h"] = "actions.parent",
				},
				use_default_keymaps = false,
			},
		},

}
