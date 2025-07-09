require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "javascript", "typescript", "go", "html", "css" },
	highlight = { enable = true },
	indent = { enable = false },
})
