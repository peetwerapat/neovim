local fn = vim.fn
local api = vim.api

-- highlight yanked region
api.nvim_create_autocmd("TextYankPost", {
	group = api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "YankColor", timeout = 200 })
	end,
})

-- auto create directory before saving
api.nvim_create_autocmd("BufWritePre", {
	group = api.nvim_create_augroup("auto_create_dir", { clear = true }),
	pattern = "*",
	callback = function(ctx)
		local dir = fn.fnamemodify(ctx.file, ":p:h")
		if fn.isdirectory(dir) == 0 then
			fn.mkdir(dir, "p")
		end
	end,
})

-- reload file if changed outside
api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
	group = api.nvim_create_augroup("autoread", { clear = true }),
	pattern = "*",
	callback = function()
		if fn.getcmdwintype() == "" then vim.cmd("checktime") end
	end,
})

api.nvim_create_autocmd("FileChangedShellPost", {
	group = "autoread",
	pattern = "*",
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded!", vim.log.levels.INFO)
	end,
})

-- resize splits on terminal resize
api.nvim_create_autocmd("VimResized", {
	group = api.nvim_create_augroup("resize_splits", { clear = true }),
	command = "wincmd =",
})

-- open NvimTree if nvim starts with directory
api.nvim_create_autocmd("VimEnter", {
	callback = function(data)
		if fn.isdirectory(data.file) == 1 then
			vim.cmd("enew")
			vim.cmd("bw " .. data.buf)
			require("nvim-tree.api").tree.open()
		end
	end,
})

-- auto insert mode on terminal open
api.nvim_create_autocmd("TermOpen", {
	group = api.nvim_create_augroup("term_setup", { clear = true }),
	pattern = "*",
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.cmd("startinsert")
	end,
})

-- toggle relative number based on focus/mode
local number_toggle = api.nvim_create_augroup("number_toggle", { clear = true })

api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = number_toggle,
	pattern = "*",
	callback = function()
		if vim.wo.number then vim.wo.relativenumber = true end
	end,
})

api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = number_toggle,
	pattern = "*",
	callback = function()
		if vim.wo.number then vim.wo.relativenumber = false end
	end,
})

-- optimize for large files (> 0.5MB)
api.nvim_create_autocmd("BufReadPre", {
	group = api.nvim_create_augroup("large_file", { clear = true }),
	pattern = "*",
	callback = function(ev)
		local max_size = 1024 * 512 -- 0.5 MB
		local fsize = fn.getfsize(ev.file)
		if fsize > max_size or fsize == -2 then
			vim.bo.bufhidden = "unload"
			vim.bo.undolevels = -1
			vim.bo.swapfile = false
			vim.wo.number = false
			vim.wo.relativenumber = false
		end
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("custom_highlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "YankColor", {
			fg = "#34495E",
			bg = "#2ECC71",
			ctermfg = 59,
			ctermbg = 41,
		})
	end,
})
