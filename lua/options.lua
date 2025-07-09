local opt = vim.opt

-- Indentation behavior
opt.autoindent = true
opt.smartindent = false
opt.cindent = false

-- Tabs and spaces
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Other useful options
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.termguicolors = true

opt.clipboard:append("unnamedplus")
