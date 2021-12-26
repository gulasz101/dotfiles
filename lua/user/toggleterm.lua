local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then return end

local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup({
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {border = "curved", winblend = 0, highlights = {border = "Normal", background = "Normal"}}
})

local opts = {noremap = true}
function _G.set_terminal_keymaps()
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local tt = Terminal:new({
    direction = "float",
    float_opts = {border = "double"},
    -- function to run on opening the terminal
    on_open = function(term)
        -- vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>lua _tt_toggle()<CR>", {noremap = true, silent = true})
    end,
    -- function to run on closing the terminal
    on_close = function(term)
        -- vim.cmd("Closing terminal")
    end
})

function _tt_toggle()
    tt:toggle()
end

vim.api.nvim_buf_set_keymap(0, "n", "<leader>tt", "<cmd>lua _tt_toggle()<CR>", opts)
