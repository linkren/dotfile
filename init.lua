vim.cmd [[
    syntax enable

    set termguicolors
    let g:edge_style = 'aura'
    let g:edge_enable_italic = 1
    let g:edge_disable_italic_comment = 1
    " colorscheme material
    colorscheme edge
    " colorscheme atom-dark
    " colorscheme onedark
    " colorscheme one-nvim
    " colorscheme OceanicNext

    set number
    set cursorline

    set tabstop=4
    set softtabstop=4
    set shiftwidth=2
    set expandtab

    set wildmenu
    set showcmd
    set noshowmode

    set mouse=a
    set clipboard+=unnamedplus

    set list
    set listchars=tab:»\ ,trail:·,extends:>,precedes:<

    set hidden
]]

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end

require("paq"):setup({
    http_proxy = "child-prc.intel.com:913",
    https_proxy = "child-prc.intel.com:913",
})
{
    'savq/paq-nvim';                  -- Let Paq manage itself

    'kyazdani42/nvim-tree.lua';
    'octol/vim-cpp-enhanced-highlight';
    'itchyny/lightline.vim';
    'Th3Whit3Wolf/one-nvim';
    'sainnhe/edge';
    'marko-cerovac/material.nvim';
    'junegunn/goyo.vim';
    -- 'mhartington/oceanic-next';
    -- 'monsonjeremy/onedark.nvim';
    -- 'navarasu/onedark.nvim';
    'nvim-lua/plenary.nvim';
    'lewis6991/gitsigns.nvim';

    'neovim/nvim-lspconfig';          -- Mind the semi-colons
    'nvim-lua/lsp-status.nvim';
    'ray-x/lsp_signature.nvim';
    'nvim-treesitter/nvim-treesitter';
    'windwp/nvim-autopairs';
    'hrsh7th/cmp-nvim-lsp';
    'hrsh7th/cmp-buffer';
    'hrsh7th/nvim-cmp';

    'phaazon/hop.nvim';

    { 'junegunn/fzf', run = "./install --bin" };
    'vijaymarupudi/nvim-fzf';
    'ibhagwan/fzf-lua';
}

-- local function prequire(...)
--     local status, lib = pcall(require, ...)
--     if(status) then return lib end
--     return setmetatable({}, { __index = function(self, key)
--       return function (...) vim.cmd('PaqInstall') end
--     end
--     })
-- end

-- require('onedark').setup()

require('hop').setup {}
-- require('feline').setup {}

require('gitsigns').setup()

-- vim.cmd([[ let g:lightline = {'colorscheme': 'onedark'} ]])
-- vim.cmd([[ let g:nvim_tree_ignore = [ '.git', '.github', '.cache', '.ccls-cache' ] ]])

require('nvim-tree').setup {}
require('nvim-autopairs').setup {}
require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_ft_on_setup     = {'.git', '.github', '.cache', '.ccls-cache'},
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local cmp = require'cmp'
cmp.setup({ snippet = {
    expand = function(args) end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  require "lsp_signature".on_attach()

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- local lsp_status = require('lsp-status')
-- lsp_status.register_progress()

require('lspconfig').ccls.setup {
  -- handlers = lsp_status.extensions.ccls.setup(),
  on_attach = on_attach;
  on_init = function(client)
    client.notify("Initializing...")
    return true
  end;
  flags = {
    debounce_text_changes = 150;
  };
  init_options = {
    clang =  {
      resourceDir = "/nfs/site/proj/icl/rdrive/ref/clang/12.0.1/rhel80/efi2/lib/clang/12.0.1";
    };
    cache = {
      directory = ".ccls-cache";
    };
    highlight = {
      lsRanges = true;
    };
  };
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
}

vim.cmd([[

nnoremap <C-n> :NvimTreeToggle<CR>
map <space>j :HopLineStartAC<CR>
map <space>k :HopLineStartBC<CR>
map <space>w :HopWordAC<CR>
map <space>b :HopWordBC<CR>

]])
