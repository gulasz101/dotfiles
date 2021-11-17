-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
--vim._update_package_paths()

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
  }

  use 'neovim/nvim-lspconfig' 	 	-- Collection of configurations for built-in LSP client
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'	 	-- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'	 	    -- Autocompletion plugin

  use 'L3MON4D3/LuaSnip' 		    -- Snippets plugin
  use 'saadparwaiz1/cmp_luasnip' 	-- Snippets source for nvim-cmp
end)
