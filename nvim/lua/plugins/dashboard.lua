return {
		-- ─── dashboard ───────────────────────────────────────────────────────
		{
			"goolord/alpha-nvim",
			event = "VimEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			keys = {
				{ "<leader>a", "<cmd>Alpha<cr>", desc = "dashboard" },
			},
			config = function()
				local alpha = require("alpha")
				local dashboard = require("alpha.themes.dashboard")

				dashboard.section.header.val = {
					"                                                     ",
					"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
					"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
					"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
					"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
					"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
					"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
					"                                                     ",
				}

				dashboard.section.buttons.val = {
					dashboard.button("n", "  New File", "<cmd>ene<cr>"),
					dashboard.button("f", "  Files", "<cmd>Oil .<cr>"),
					dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<cr>"),
					dashboard.button("c", "  Config", "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<cr>"),
					dashboard.button("p", "  Plugins", "<cmd>Lazy<cr>"),
					dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
				}

				dashboard.section.footer.val = (function()
					local stats = require("lazy").stats()
					local version = vim.version()
					return string.format(
						"  nvim v%d.%d.%d    %d plugins loaded",
						version.major,
						version.minor,
						version.patch,
						stats.loaded
					)
				end)()

				dashboard.section.header.opts.hl = "AlphaHeader"
				dashboard.section.buttons.opts.hl = "AlphaButtons"
				dashboard.section.footer.opts.hl = "AlphaFooter"

				dashboard.opts.layout = {
					{ type = "padding", val = 4 },
					dashboard.section.header,
					{ type = "padding", val = 2 },
					dashboard.section.buttons,
					{ type = "padding", val = 2 },
					dashboard.section.footer,
				}

				dashboard.opts.opts.noautocmd = true
				alpha.setup(dashboard.opts)

				vim.api.nvim_create_autocmd("BufDelete", {
					group = vim.api.nvim_create_augroup("AlphaReopen", { clear = true }),
					callback = function()
						local bufs = vim.fn.getbufinfo({ buflisted = true })
						if #bufs == 0 then
							alpha.start(true)
						end
					end,
				})

				vim.api.nvim_create_autocmd("User", {
					group = vim.api.nvim_create_augroup("AlphaBars", { clear = true }),
					pattern = "AlphaReady",
					callback = function()
						local alpha_buf = vim.api.nvim_get_current_buf()
						local previous_showtabline = vim.o.showtabline
						local previous_laststatus = vim.o.laststatus

						vim.o.showtabline = 0
						vim.o.laststatus = 0

						vim.api.nvim_create_autocmd("BufUnload", {
							buffer = alpha_buf,
							once = true,
							callback = function()
								vim.o.showtabline = previous_showtabline
								vim.o.laststatus = previous_laststatus
							end,
						})
					end,
				})
			end,
		},

}
