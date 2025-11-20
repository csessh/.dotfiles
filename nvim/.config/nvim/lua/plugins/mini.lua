return {
  "echasnovski/mini.nvim",
  version = "*",
  config = function()
    require("mini.splitjoin").setup {
      mappings = {
        join = ",J",
        split = ",j",
      },
    }

    require("mini.operators").setup {
      evaluate = { prefix = ",=" },
      replace = {
        prefix = ",r",
        reindent_linewise = true,
      },
      sort = {
        prefix = ",s",
        reindent_linewise = true,
      },
      exchange = {
        prefix = ",m",
        reindent_linewise = true,
      },
    }

    require("mini.hipatterns").setup {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

        -- Highlight hex color strings (`#rrggbb`) using that color
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    }
  end,
}
