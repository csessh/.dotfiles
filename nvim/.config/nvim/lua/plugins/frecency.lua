return {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-telescope/telescope.nvim'
    },
    config = function()
        require('telescope').load_extension('frecency')
        vim.keymap.set('n', '<leader>ff', ':Telescope frecency<CR>', {})
    end
}
