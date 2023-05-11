-- Lua DAP

local dap = require('dap')

-- Keymaps
vim.api.nvim_set_keymap('n', '<F5>', '<cmd>lua require"dap".continue()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>lua require"dap".step_over()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F11>', '<cmd>lua require"dap".step_into()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<F12>', '<cmd>lua require"dap".step_out()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>rb', '<cmd>lua require"dap".toggle_breakpoint()<CR>', {noremap = true, silent = true})
