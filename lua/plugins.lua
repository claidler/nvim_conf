local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'rbong/vim-crystalline'
  use { "catppuccin/nvim", as = "catppuccin" }

  use { "folke/which-key.nvim",
	  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
    require("which-key").setup {}
  end
  }
	use({
    "robitx/gp.nvim",
    config = function()
        require("gp").setup({
						openai_api_key = os.getenv("OPENAI_API_KEY"),
				})
    end,
})

  if packer_bootstrap then
    require('packer').sync()
  end
end)

local wk = require('which-key')

