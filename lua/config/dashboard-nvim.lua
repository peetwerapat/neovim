local api = vim.api
local keymap = vim.keymap
local dashboard = require("dashboard")

local conf = {}
conf.header = {
  "                                                       ",
  "                                                       ",
  "                                                       ",
  "████████╗██╗  ██╗██╗███╗   ██╗██╗  ██╗    ██████╗ ██╗      █████╗ ███╗   ██╗    ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗███████╗",
  "╚══██╔══╝██║  ██║██║████╗  ██║██║ ██╔╝    ██╔══██╗██║     ██╔══██╗████╗  ██║    ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██╔════╝",
  "   ██║   ███████║██║██╔██╗ ██║█████╔╝     ██████╔╝██║     ███████║██╔██╗ ██║    █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   █████╗  ",
  "   ██║   ██╔══██║██║██║╚██╗██║██╔═██╗     ██╔═══╝ ██║     ██╔══██║██║╚██╗██║    ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══╝  ",
  "   ██║   ██║  ██║██║██║ ╚████║██║  ██╗    ██║     ███████╗██║  ██║██║ ╚████║    ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ███████╗",
  "   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝    ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝",
  "                                                       ",
  "                                                       ",
  -- "                                                       ",
  -- "                                                       ",
}

-- conf.header = {
--   "                                                ",
--   "                                                ",
--   "                                                ",
--   "                                                ",
--   "  ███████████  ██████████ ██████████ ███████████",
--   " ░░███░░░░░███░░███░░░░░█░░███░░░░░█░█░░░███░░░█",
--   "  ░███    ░███ ░███  █ ░  ░███  █ ░ ░   ░███  ░ ",
--   "  ░██████████  ░██████    ░██████       ░███    ",
--   "  ░███░░░░░░   ░███░░█    ░███░░█       ░███    ",
--   "  ░███         ░███ ░   █ ░███ ░   █    ░███    ",
--   "  █████        ██████████ ██████████    █████   ",
--   " ░░░░░        ░░░░░░░░░░ ░░░░░░░░░░    ░░░░░    ",
--   "                                                ",
--   "                                                ",
-- }

conf.center = {
  {
    icon = "󰈞  ",
    desc = "Find  File                              ",
    action = "FzfLua files",
    key = "<Leader> f f",
  },
  {
    icon = "󰈢  ",
    desc = "Recently opened files                   ",
    action = "FzfLua oldfiles",
    key = "<Leader> f r",
  },
  {
    icon = "󰈬  ",
    desc = "Project grep                            ",
    action = "FzfLua live_grep",
    key = "<Leader> f g",
  },
  {
    icon = "  ",
    desc = "Open Nvim config                        ",
    action = "tabnew $MYVIMRC | tcd %:p:h",
    key = "<Leader> e v",
  },
  {
    icon = "  ",
    desc = "New file                                ",
    action = "enew",
    key = "e",
  },
  {
    icon = "󰗼  ",
    desc = "Quit Nvim                               ",
    -- desc = "Quit Nvim                               ",
    action = "qa",
    key = "q",
  },
}

conf.footer = {
  "",
  "",
  "Business | Trade | Develop",
}

-- local stats = require("lazy").stats()
-- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

dashboard.setup {
  theme = "hyper",
  -- shortcut_type = "number",
  config = {
    shortcut = {
      -- {
      --   desc =  "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
      --   group = "DashboardShortcutDesc",
      -- },
    },
    shortcut_type = "letter",
    header = conf.header,
    -- center = conf.center,
    footer = conf.footer,
    packages = { enable = false },
    -- week_header = {
    --   enable = true,
    -- },
  },
}

api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
  callback = function()
    keymap.set("n", "q", ":qa<CR>", { buffer = true, silent = true })
    keymap.set("n", "e", ":enew<CR>", { buffer = true, silent = true })
  end,
})