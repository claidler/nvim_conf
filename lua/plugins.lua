local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("hrsh7th/nvim-cmp")
	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("rbong/vim-crystalline")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("jose-elias-alvarez/null-ls.nvim")
	use("MunifTanjim/prettier.nvim")
	use("tpope/vim-fugitive")
	use("github/copilot.vim")
	use("prisma/vim-prisma")
	use("lunarvim/horizon.nvim")
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	})
	use({
		"robitx/gp.nvim",
		config = function()
			require("gp").setup({
				openai_api_key = os.getenv("OPENAI_API_KEY"),
				chat_model = "gpt-4",
				chat_topic_gen_model = "gpt-4",
				command_model = "gpt-4",
				command_system_prompt = "You are a code editor. Only return the edited code. Do not explain your response"
			})
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	if packer_bootstrap then
		require("packer").sync()
	end
end)

local wk = require("which-key")
local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })

			-- format on save
			vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
			vim.api.nvim_create_autocmd(event, {
				buffer = bufnr,
				group = group,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, async = async })
				end,
				desc = "[lsp] format on save",
			})
		end

		if client.supports_method("textDocument/rangeFormatting") then
			vim.keymap.set("x", "<Leader>f", function()
				vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
			end, { buffer = bufnr, desc = "[lsp] format" })
		end
	end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

wk.register({
	["<leader>"] = {
		f = {
			name = "Find",
			f = { "<cmd>Telescope find_files<cr>", "Find Files" },
			g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
			b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
			r = { "<cmd>Telescope lsp_references<cr>", "LSP References" },
			d = { "<cmd>Telescope lsp_definitions<cr>", "LSP Definitions" },
		},
	},
}, {
	mode = "n", -- NORMAL mode
	prefix = "",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
})

wk.register({
	["<C-g>"] = {
		c = { ":<C-u>'<,'>GpChatNew<cr>", "Visual Chat New" },
		t = { ":<C-u>'<,'>GpChatToggle<cr>", "Visual Popup Chat" },

		r = { ":<C-u>'<,'>GpRewrite<cr>", "Visual Rewrite" },
		a = { ":<C-u>'<,'>GpAppend<cr>", "Visual Append" },
		b = { ":<C-u>'<,'>GpPrepend<cr>", "Visual Prepend" },
		e = { ":<C-u>'<,'>GpEnew<cr>", "Visual Enew" },
		p = { ":<C-u>'<,'>GpPopup<cr>", "Visual Popup" },
		s = { "<cmd>GpStop<cr>", "Stop" },
	},
}, {
	mode = "v", -- VISUAL mode
	prefix = "",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
})

wk.register({
	["<C-g>"] = {
		name = "gpt",
		c = { ":GpChatNew<cr>", "Chat New" },
		t = { ":GpChatToggle<cr>", "Popup Chat" },

		r = { ":GpRewrite<cr>", "Rewrite" },
		a = { ":GpAppend<cr>", "Append" },
		b = { ":GpPrepend<cr>", "Prepend" },
		e = { ":GpEnew<cr>", "Enew" },
		p = { ":GpPopup<cr>", "Popup" },
		s = { "<cmd>GpStop<cr>", "Stop" },
	},
}, {
	mode = "n", -- NORMAL mode
	prefix = "",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
})

wk.register({
	["<C-g>"] = {
		name = "gpt",
		c = { "<cmd>GpChatNew<cr>", "New Chat" },
		t = { "<cmd>GpChatToggle<cr>", "Toggle Popup Chat" },
		f = { "<cmd>GpChatFinder<cr>", "Chat Finder" },

		r = { "<cmd>GpRewrite<cr>", "Inline Rewrite" },
		a = { "<cmd>GpAppend<cr>", "Append" },
		b = { "<cmd>GpPrepend<cr>", "Prepend" },
		e = { "<cmd>GpEnew<cr>", "Enew" },
		p = { "<cmd>GpPopup<cr>", "Popup" },
		s = { "<cmd>GpStop<cr>", "Stop" },
	},
}, {
	mode = "i", -- INSERT mode
	prefix = "",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
