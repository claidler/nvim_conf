local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup language servers.
local lspconfig = require('lspconfig')

lspconfig.tsserver.setup {
  capabilities = capabilities
}
lspconfig.eslint.setup{
  capabilities = capabilities
}
lspconfig.lua_ls.setup{
	capabilities = capabilities,
	settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognise the `vim` global
        globals = {'vim'},
      },
    },
  },
}

local wk = require('which-key')
wk.register({
	['<leader>'] = {
		l = {
			name = 'LSP',
			a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
			d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition' },
			D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
			i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
			r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'References' },
			R = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
			s = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help' },
			t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type Definition' },
			x = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' },
			X = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Line Diagnostics' },
			['['] = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Previous Diagnostic' },
			[']'] = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next Diagnostic' },
		}
	}
})

