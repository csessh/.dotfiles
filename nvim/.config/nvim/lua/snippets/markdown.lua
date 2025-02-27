require("luasnip.session.snippet_collection").clear_snippets "markdown"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("markdown", {
    s("checkbox", fmt("- [ ] {}", { i(1) })),
    s("ref", fmt("[[{}]] ", { i(1) })),
})
