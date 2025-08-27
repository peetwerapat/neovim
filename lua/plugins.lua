local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    cmd = "YankyRingHistory",
  },
  {
    "akinsho/toggleterm.nvim",
    config = true,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufRead",
    config = function()
      require("config.nvim-highlight-colors")
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("config.rainbow-delimiters")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    config = function()
      require("config.dashboard-nvim")
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },

  -- Completion Engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "quangnguyen30192/cmp-nvim-ultisnips",
      "SirVer/ultisnips",
    },
    event = "CmdlineEnter",
    config = function()
      require("config.nvim-cmp")
    end,
  },

  -- Formatter (ESLint, Prettier, gofmt, java-format)
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      require("config.null-ls")
    end,
  },

  -- Treesitter (syntax highlight)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- TypeScript/JS tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("config.ts-tools")
    end,
  },

  -- Java support
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- Go support
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    config = function()
      require("go").setup()
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = { "<space>s" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  -- UI: statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "BufRead",
    config = function()
      require("config.lualine")
    end,
  },

  -- UI: bufferline
  {
    "akinsho/bufferline.nvim",
    event = "BufEnter",
    config = function()
      require("config.bufferline")
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- For JSX-aware comment support
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("config.comment")
    end,
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    config = function()
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },

  -- File search
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    config = function()
      require("config.fzf-lua")
    end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("config.gitsigns")
    end,
  }

  -- Which-key
  --[[ { ]]
  --[[   "folke/which-key.nvim", ]]
  --[[   event = "VeryLazy", ]]
  --[[   config = function() ]]
  --[[     require("config.which-key") ]]
  --[[   end, ]]
  --[[ }, ]]
}

require("lazy").setup({
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
})
