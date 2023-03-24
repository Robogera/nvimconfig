vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.encoding = 'utf-8'
vim.opt.backspace = 'indent,eol,start'
vim.opt.startofline = true
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 100
vim.opt.showmatch = true
vim.opt.scrolloff = 12
vim.opt.list = false
vim.opt.foldenable = false
vim.opt.wrap = true
vim.cmd(':set linebreak breakindent')
vim.opt.eol = false
vim.opt.showbreak = '↪ '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = 'yes'
vim.opt.modelines = 0
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.matchtime = 1
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.wildmenu = true

vim.opt.updatetime = 300

require('plugins')

vim.cmd.colorscheme "catppuccin-mocha"

vim.diagnostic.config({
  virtual_text = false,
})

vim.g.mapleader = ' '
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>b', '<Cmd>BufferLineCyclePrev<CR>', {})
vim.keymap.set('n', '<leader>n', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<leader>p', '<Cmd>BufferLinePick<CR>', {})
vim.keymap.set('n', '<leader>cc', '<Cmd>BufferLinePickClose<CR>', {})
vim.keymap.set('n', '<leader>cl', '<Cmd>BufferLineCloseLeft<CR>', {})
vim.keymap.set('n', '<leader>cr', '<Cmd>BufferLineCloseRight<CR>', {})

vim.keymap.set('n', '<leader>t', '<Cmd>NvimTreeToggle<CR>', {})
vim.keymap.set('n', '<leader>-', '<Cmd>NvimTreeResize -2<CR>', {})
vim.keymap.set('n', '<leader>=', '<Cmd>NvimTreeResize +2<CR>', {})

local diagnosticSigns = {
  Error = "",
  Warning = "",
  Hint = "",
  Information = "",
}

for severity, sign in pairs(diagnosticSigns) do
  local hlGroup = "DiagnosticSign" .. severity
  vim.fn.sign_define(hlGroup, { texthl = hlGroup, numhl = hlGroup, text = sign })
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<leader>gD', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>g<C-d>', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, bufopts)

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>rf', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp = require "lspconfig"
local lsp_defaults = lsp.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require("cmp_nvim_lsp").default_capabilities()
)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = 'nvim_lsp',               keyword_length = 1 },
    { name = 'nvim_lsp_signature_help' },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})
lsp.gopls.setup({
  on_attach = on_attach,
})
lsp.cssls.setup({ on_attach = on_attach })
lsp.html.setup({ on_attach = on_attach })
lsp.ansiblels.setup({ on_attach = on_attach })
lsp.clangd.setup({ on_attach = on_attach })
lsp.dartls.setup({ on_attach = on_attach })
lsp.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
