return {
    's1n7ax/nvim-terminal',
    config = function()
        vim.o.hidden = true
        require('nvim-terminal').setup()
        local silent = { silent = true}
        vim.api.nvim_set_keymap('n', '<C-`>', ':lua NTGlobal["terminal"]:toggle()<cr>', silent)
        vim.api.nvim_set_keymap('n', '<leader>+', ':lua NTGlobal["window"]:change_height(2)<cr>', silent)
        vim.api.nvim_set_keymap('n', '<leader>-', ':lua NTGlobal["window"]:change_height(-2)<cr>', silent)
    end,
}
