local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {
  {
    "tpope/vim-obsession",
    lazy = false
  },
  {
    "machakann/vim-sandwich",
    lazy = false
  },

  -- This plugin 
  {
    'saecki/crates.nvim',
    ft = {"rust", "toml"},
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function()
      require "custom.configs.formatter"
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  {
    "hrsh7th/nvim-cmp",
    opts = {
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "cmp_tabnine" },
        {name = "crates"},
      },
    },

    -- dependencies = {
    --   {
    --     "tzachar/cmp-tabnine",
    --     build = "./install.sh",
    --     config = function()
    --       local tabnine = require "cmp_tabnine.config"
    --       tabnine:setup {
    --         max_lines = 1000,
    --         max_num_results = 20,
    --         sort = true,
    --         run_on_every_keystroke = true,
    --         snippet_placeholder = '..',
    --         show_prediction_strength = false
    --       }
    --     end,
    --   },
    -- },
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      overrides.mason,
      ensure_installed = {
        "rubocop",
        "solargraph",
        "eslint-lsp",
        "rust-analyzer",
        "jsonlint",
        "ktlint",
        "prettier",
      }
    }
  },
  "MunifTanjim/prettier.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function ()
      require("custom.configs.rust-tools")
    end,
    config = function(_, opts)
      require('rust-tools').setup(opts)
    end
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vimwiki",
        },
        {
          name = "gaming",
          path = "~/RolePlaying/",
        },
        {
          name = "recipes",
          path = "~/Recipes/"
        }
      },
    }
  },
  -- {
  --   "codota/tabnine-nvim",
  --   lazy = false,
  --   config = function()
  --     require("tabnine").setup({
  --       -- ydisable_auto_comment=true,
  --       accept_keymap="<C-a>",
  --       dismiss_keymap = "<C-]>",
  --       debounce_ms = 800,
  --       suggestion_color = {gui = "#808080", cterm = 244},
  --       exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  --       log_file_path = nil, -- absolute path to Tabnine log fileour configuration options
  --     })
  --   end,
  --   build = "./dl_binaries.sh"
  -- },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "/home/mtuckerb/.nix-profile/bin/op read op://private/OpenAI/credential --no-newline"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
}

return plugins
