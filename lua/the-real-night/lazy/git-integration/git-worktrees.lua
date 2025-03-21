return {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    dependencies = { 'nvim-lua/plenary.nvim', 'stevearc/overseer.nvim' },
    config = function()
        vim.g.git_worktree_log_level = "trace"
        require('telescope').load_extension('git_worktree')

        local Hooks = require 'git-worktree.hooks'
        local config = require('git-worktree.config')
        local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

        Hooks.register(Hooks.type.DELETE, function()
            vim.cmd(config.update_on_change_command)
        end)

        Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
            vim.notify('Moved:' .. prev_path .. '  ~>  ' .. path)
            update_on_switch(path, prev_path)
            local nvimTreeActions = require "nvim-tree.actions"
            nvimTreeActions.root.change_dir.fn(path)
            local tmuxUtil = require "the-real-night.tmux-setup"
            tmuxUtil.dir_change(path)
        end)

        local switch_worktree = function()
            require('telescope').extensions.git_worktree.git_worktree()
        end
        local create_worktree = function()
            require('telescope').extensions.git_worktree.create_git_worktree()
        end

        vim.keymap.set('n', '<leader>wG', create_worktree)
        vim.keymap.set('n', '<leader>wg', switch_worktree)
    end
}
