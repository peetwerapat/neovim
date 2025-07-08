local M = {}

M.colorscheme_conf = {
  onedark = function()
    -- Lua
    require("onedark").setup {
      style = "darker",
    }
    require("onedark").load()
  end,
  edge = function()
    vim.g.edge_style = "default"
    vim.g.edge_enable_italic = 1
    vim.g.edge_better_performance = 1

    vim.cmd([[colorscheme edge]])
  end,
  sonokai = function()
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_better_performance = 1

    vim.cmd([[colorscheme sonokai]])
  end,
  gruvbox_material = function()
    -- foreground option can be material, mix, or original
    vim.g.gruvbox_material_foreground = "original"
    --background option can be hard, medium, soft
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    vim.cmd([[colorscheme gruvbox-material]])
  end,
  everforest = function()
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_better_performance = 1

    vim.cmd([[colorscheme everforest]])
  end,
  nightfox = function()
    vim.cmd([[colorscheme carbonfox]])
  end,
  catppuccin = function()
    vim.cmd("colorscheme catppuccin")
  end,
  onedarkpro = function()
    -- set colorscheme after options
    -- onedark_vivid does not enough contrast
    vim.cmd("colorscheme onedark_dark")
  end,
  material = function()
    vim.g.material_style = "darker"
    vim.cmd("colorscheme material")
  end,
  arctic = function()
    vim.cmd("colorscheme arctic")
  end,
  kanagawa = function()
    vim.cmd("colorscheme kanagawa-wave")
  end,
  tokyonight = function()
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_enable_italic = 1
    vim.cmd("colorscheme tokyonight")
  end,
  dracula = function()
    vim.cmd("colorscheme dracula")
  end,
  tokyodark = function()
    vim.cmd("colorscheme tokyodark")
  end,
  neon = function()
    vim.cmd [[colorscheme neon]]
  end,
  cyberdream = function()
    vim.cmd("colorscheme cyberdream")

    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#1e90ff", bold = true })
    vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#ffcba4", italic = true })
  end,
  lytmode = function()
    vim.cmd("colorscheme lytmode")
  end,
  moonfly = function()
    vim.cmd([[colorscheme moonfly]])
  end,
  citruszest = function()
    vim.cmd([[colorscheme citruszest]])
  end,
  bluloco = function()
    vim.cmd([[colorscheme bluloco-dark]])
  end


}

M.set_colorscheme = function()
  M.colorscheme_conf.cyberdream()
end

M.set_colorscheme()

return M