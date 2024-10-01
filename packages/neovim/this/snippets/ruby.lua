local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node

local regular_snippets = {
  s("pry", {
    t("require 'pry';binding.pry"),
  }),
}

local auto_snippets = {}

return regular_snippets, auto_snippets
