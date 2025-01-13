local luasnip = require("luasnip")
local s = luasnip.snippet
local t = luasnip.text_node

local regular_snippets = {
  s("pdb", {
    t("import pdb; pdb.set_trace();"),
  }),
}

local auto_snippets = {}

return regular_snippets, auto_snippets
