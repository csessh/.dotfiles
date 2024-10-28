return {
    'bennypowers/splitjoin.nvim',
    lazy = true,
    keys = {
        { 'gj', function() require 'splitjoin'.join() end,  { noremap = true, desc = 'Join the object under cursor' } },
        { 'gJ', function() require 'splitjoin'.split() end, { noremap = true, desc = 'Split the object under cursor' } },
    },
}
