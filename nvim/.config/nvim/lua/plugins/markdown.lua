return {
    'iamcco/markdown-preview.nvim',
    cmd = {
        'MarkdownPreviewToggle',
        'MarkdownPreview',
        'MarkdownPreviewStop'
    },
    ft = {'markdown'},
    init = function()
        vim.fn['mkdp#util#install']()
    end
}
