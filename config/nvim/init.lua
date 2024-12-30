local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = {
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.6',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { 'rose-pine/neovim', name = 'rose-pine' },
        { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        {'L3MON4D3/LuaSnip'},
        {
            'stevearc/oil.nvim',
            opts = {},
            dependencies = { { "echasnovski/mini.icons", opts = {} } }
        },
        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = true
        },
        {'windwp/nvim-ts-autotag'},
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" }
        }
    },
})

--------------------
-- Editor
--------------------

vim.cmd.colorscheme('rose-pine')

vim.g.mapleader = ' '

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.splitright = true


-------------------
-- LspZero
-------------------
local lsp = require("lsp-zero")

lsp.preset("recommended")

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp.default_setup,
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    })
})
lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

------------------
-- Telescope
------------------

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>pf', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input('Grep > ')});
end)

------------------
-- Treesitter
------------------

require'nvim-treesitter.configs'.setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'query' },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    autotag  = {
        enable = true,
        filetypes = { }
    },

    indent = {
        enable = true
    }
}

-----------------
-- Harpoon
-----------------

local harpoon = require('harpoon')
harpoon:setup({})

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-r>", function() harpoon:list():remove() end)

require("oil").setup({
    default_file_explorer = true,
    columns = { },
    view_options = {
        show_hidden = true,
    }
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', '<leader>pv', "<CMD>Oil<CR>")

