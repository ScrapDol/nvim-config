
vim.g.mapleader = " "

vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q!<CR>', { noremap = true, silent = true })

vim.keymap.set('i', "jk", "<ESC>")
