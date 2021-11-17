
-- vim.g.vimsys_embed = 'l'
--vim.g.netrw_browse_split = 2
vim.g.netrw_liststyle = 3
vim.g.netrw_keepdir = 1
--vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = 'cp -r'
--vim.api.nvim_command([[
--augroup ProjectDrawer
--autocmd VimEnter * :Vexplore
--augroup END
--]])
--
vim.api.nvim_command([[
  set number
]])
vim.api.nvim_command([[
augroup numbertoggle
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
]])


vim.api.nvim_command([[
  set tabstop=4
  set shiftwidth=4
  set expandtab
]])

