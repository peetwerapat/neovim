require("yanky").setup {
  preserve_cursor_position = {
    enabled = false,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 300,
  },
}