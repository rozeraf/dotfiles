-- Не включаем unnamedplus глобально: c/s и прочие операции остаются на Vim-регистрах.
-- Только обычные d/y/x/p работают с системным буфером обмена (+ register).
vim.opt.clipboard = ""

local clipboard_map_opts = { silent = true }

-- delete -> system clipboard
vim.keymap.set({ "n", "x" }, "d", '"+d', clipboard_map_opts)
vim.keymap.set("n", "D", '"+D', clipboard_map_opts)

-- yank -> system clipboard
vim.keymap.set({ "n", "x" }, "y", '"+y', clipboard_map_opts)
vim.keymap.set("n", "Y", '"+Y', clipboard_map_opts)

-- delete char -> system clipboard
vim.keymap.set({ "n", "x" }, "x", '"+x', clipboard_map_opts)
vim.keymap.set("n", "X", '"+X', clipboard_map_opts)

-- paste <- system clipboard
vim.keymap.set({ "n", "x" }, "p", '"+p', clipboard_map_opts)
vim.keymap.set({ "n", "x" }, "P", '"+P', clipboard_map_opts)

-- Сохранить всё и выйти.
vim.keymap.set("n", "<leader>xa", "<cmd>wa<cr><cmd>qa<cr>", { desc = "save all and quit" })
