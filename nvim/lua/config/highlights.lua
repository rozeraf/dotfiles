	-- ─── highlights ────────────────────────────────────────────────────────
	local function apply_highlights()
		local float_bg = "#252535"
		local float_border = "#45475a"

		if vim.g.neovide then
			vim.api.nvim_set_hl(0, "Normal", { bg = "#101010" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "#101010" })
		else
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
		end

		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "FoldColumn", { bg = "NONE" })

		-- ToggleTerm
		vim.api.nvim_set_hl(0, "ToggleTerm1Normal", { bg = "#1a1a2e" })
		vim.api.nvim_set_hl(0, "ToggleTermNormal", { bg = "#1a1a2e" })
		vim.api.nvim_set_hl(0, "TerminalBackground", { bg = "#1a1a2e" })

		-- nvim-cmp
		vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1e1e30" })
		vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#45475a", bg = "#1e1e30" })
		vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = float_bg })
		vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#89dceb", bold = true })
		vim.api.nvim_set_hl(0, "CmpItemKindDefault", { fg = "#cba6f7" })

		-- Floating windows
		vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#cdd6f4", bg = float_bg })
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = float_border, bg = float_bg })
		vim.api.nvim_set_hl(0, "Pmenu", { fg = "#cdd6f4", bg = float_bg })
		vim.api.nvim_set_hl(0, "PmenuSel", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#313244" })
		vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#585b70" })

		-- Noice
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = float_bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = float_border, bg = float_bg })

		-- Bufferline / tabline
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "#1e1e2e", fg = "#1e1e2e" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "#1e1e2e", fg = "#585b70" })

		-- Alpha
		vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#89b4fa", bold = true })
		vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4" })
		vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#585b70", italic = true })
		vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#cba6f7", bold = true })
	end

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("UserHighlights", { clear = true }),
		callback = apply_highlights,
	})
return apply_highlights
