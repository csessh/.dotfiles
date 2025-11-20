require("luasnip.session.snippet_collection").clear_snippets "go"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("go", {
  s("printf", fmt('fmt.Printf("{} %d\\n", {})', { i(1), i(2) })),
  s("!err", fmt("if err != nil{{\n\t{}\n}}\n\n{}", { i(1), i(2) })),
})
