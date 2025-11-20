require("luasnip.session.snippet_collection").clear_snippets "zsh"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("zsh", {
  -- s("", fmt("", {})),
})
