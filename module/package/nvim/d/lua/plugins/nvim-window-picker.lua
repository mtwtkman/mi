local utils = require("utils")
local window_picker = require("window-picker")

window_picker.setup({
  show_prompt = false,
})

utils.nmap(
  "<leader>p",
  function()
    local winid = window_picker.pick_window()
    vim.fn["win_gotoid"](winid)
  end,
  {}
)
