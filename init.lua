require("core")


vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use { "catppuccin/nvim", as = "catppuccin" }
  
  -- LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  
  -- Автодополнение
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- Дополнительные плагины по вашему выбору
end)

-- Настройка LSP
local lspconfig = require('lspconfig')
local cmp = require('cmp')

require("mason").setup()
require("mason-lspconfig").setup()

-- Настройка автодополнения
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Настройка серверов LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Пример настройки для Python (pyright)
lspconfig.pyright.setup {
  capabilities = capabilities,
}

-- Добавьте другие серверы по аналогии, например:
-- lspconfig.tsserver.setup {
--   capabilities = capabilities,
-- }

-- Глобальные маппинги для LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})



lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Укажите, какую версию Lua вы используете (LuaJIT для Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Получать диагностику для глобальных переменных Neovim
        globals = {'vim'},
      },
      workspace = {
        -- Сделать сервер осведомленным о рантайме Neovim
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Не отправлять телеметрию
      telemetry = {
        enable = false,
      },
    },
  },
}

lspconfig.clangd.setup {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--pch-storage=memory",
    "--clang-tidy",
    "--suggest-missing-includes",
    "--all-scopes-completion",
    "--pretty",
    "--header-insertion=iwyu",
  },
  filetypes = {"c", "cpp", "objc", "objcpp"},
  root_dir = lspconfig.util.root_pattern(
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git'
  ),
  single_file_support = true,
}


lspconfig.zls.setup {
  capabilities = capabilities,
  cmd = {"zls"},
  filetypes = {"zig", "zir"},
  root_dir = lspconfig.util.root_pattern("build.zig", ".git"),
  single_file_support = true,
  settings = {
    zls = {
      -- Здесь вы можете добавить специфические настройки для ZLS
      -- Например:
      -- enable_snippets = true,
      -- warn_style = true,
      -- enable_semantic_tokens = true,
    }
  }
}

require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

vim.cmd.colorscheme "catppuccin"
