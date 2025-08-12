-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

local plugins = {
    {
        "nvim-lua/plenary.nvim"
    },
    -- colorscheme
    {
        "loctvl842/monokai-pro.nvim"
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },

    -- bar
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- lsp
    {
        "williamboman/mason.nvim",
        lazy = false
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd({'BufWritePre'}, {
                pattern = "*.py",
                command = "lua vim.lsp.buf.format()"
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = false
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        },
        lazy = false
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        lazy = false
    },
    {
        "hrsh7th/vim-vsnip"
    },
    {
        "nvim-treesitter/nvim-treesitter"
    },
    -- telescope
    {
        "nvim-telescope/telescope.nvim"
    },

    -- latex
    {
        "lervag/vimtex"
    },

    -- copilot
    {
        "github/copilot.vim"
    },

    -- rust
    {
        "simrat39/rust-tools.nvim"
    },
    -- {
    --     "mrcjkb/rustaceanvim",
    --     version = '^6',
    --     lazy = false,
    -- },

    -- autopair
    {
        "windwp/nvim-autopairs"
    },
    {
        "windwp/nvim-ts-autotag"
    }
}


lazy.setup(plugins, opts)

-- colorscheme
-- require("monokai-pro").setup({
--     terminal_colors = true,
--     devicons = true,
--     filter = "classic"
-- })

vim.cmd([[colorscheme catppuccin]])

-- bar
require("lualine").setup {
    options = {
        theme = 'catppuccin',
        component_separators = '',
        section_separators = ''
    },
    sections = {
        lualine_c = { { 'filename', path=2 } }
    }
}

-- lsp
local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup {
    automatic_enable = true, -- HACK: rely on lspconfig[server_name].setup to enable the LSPs. For some reason, pyright doesn't get enabled this way
    handlers = { 
        function(server_name)
            if server_name == 'rust_analyzer' then
                print('NOPE!')
            end
        end
    }
}


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(_, bufnr)
  local attach_opts = { silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
end

vim.keymap.set("n", '<leader>i', 
    function() 
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
    end
)


local servers = { "ocamllsp" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end


local cmp = require("cmp")

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert',
        autocomplete = {
            cmp.TriggerEvent.TextChanged
        }
    },
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 1 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 1},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 1 },        -- source current buffer
    { name = 'vsnip', keyword_length = 1 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '/',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "zathura"


vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

-- rust
vim.g.rustfmt_autosave = 1

-- treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
-- ft_to_parser.mdx = "markdown"
vim.treesitter.language.register('markdown', 'mdx')

require('nvim-autopairs').setup()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('nvim-ts-autotag').setup()

require("rust-tools").setup({})
