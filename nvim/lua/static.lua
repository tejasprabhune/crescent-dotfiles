local set = vim.opt

set.tabstop         = 4
set.softtabstop 	= 4
set.shiftwidth		= 4
set.expandtab		= true
set.number          = true
set.termguicolors   = true

local g = vim.g

g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>jj", "<cmd>bnext<CR>")
vim.keymap.set("n", "<leader>kk", "<cmd>bprev<CR>")
vim.keymap.set("n", "<leader>dd", "<cmd>bdelete<CR>")

vim.diagnostic.config {
    virtual_text = true,
    virtual_lines = false
}
