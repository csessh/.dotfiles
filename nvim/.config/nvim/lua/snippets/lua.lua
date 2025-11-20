require("luasnip.session.snippet_collection").clear_snippets "lua"

local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
  s("snippet", fmt('s("{}", fmt("{}", {{ {} }})),', { i(1), i(2), i(3) })),
  s("remap", fmt('vim.keymap.set("{}", "{}", "{}", {{ desc = {} }})', { i(1), i(2), i(3), i(4) })),
  s("nnoremap", fmt('vim.keymap.set("n", "{}", "{}", {{ noremap = true, {} }})', { i(1), i(2), i(3) })),
  s(
    "noremap",
    fmt('vim.keymap.set({{ "{}", {} }}, "{}", "{}", {{ noremap = true, {} }})', { i(1), i(2), i(3), i(4), i(5) })
  ),
})
