local opts = { noremap = true, silent = true }

vim.g.mapleader = ","

vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)

vim.keymap.set("n", "<leader>w", function()
	vim.lsp.buf.format({ async = false })
	vim.cmd("write")
end, { desc = "Save + Format", noremap = true, silent = true })

vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>", { desc = "FZF Files" })

vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, {
	desc = "Find Files (fzf)",
	noremap = true,
	silent = true,
})

vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set({ "n", "v" }, "H", "0", opts)
vim.keymap.set({ "n", "v" }, "L", "$", opts)
