"------------------
"      Other
"------------------

filetype plugin indent on
colorscheme gruvbox-material

au BufNewFile,BufRead *.ejs set filetype=html

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, <bang>0)
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command Reload :source $MYVIMRC

autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd FileType html,typescript,javascript,typescriptreact,javascriptreact 
   \ autocmd InsertCharPre * lua require('template-string').update()

command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Detect Indentation
augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

" Restore cursor on exit
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver20-blinkwait400-blinkoff400-blinkon400
augroup END


lua << EOF
require('telescope').setup{
   pickers = {
    find_files = {
      find_command = {
        "rg",
        "--no-ignore",
        "--hidden",
        "--files",
        "-g",
        "!**/node_modules/*",
        "-g",
        "!**/.git/*",
      },
    },
  },
 defaults = {
    file_ignore_patterns = {"node_modules/", ".git/", "dist/", ".next/", ".nx/"},
    mappings = {
      i = {
        ["<Esc>"] = "close"
      }
    }
  },
 extensions = {
        gitmoji = {
            action = function(entry)
                -- entry = {
                --   display = "🐛 Fix a bug.",
                --   index = 4,
                --   ordinal = "Fix a bug.",
                --   value = {
                --     description = "Fix a bug.",
                --     text = ":bug:",
                --     value = "🐛"
                --   }
                -- }
                local emoji = entry.value.value
                vim.ui.input({ prompt = "Enter commit message: " .. emoji .. " "}, function(msg)
                    if not msg then
                        return
                    end
                    -- Insert text instead of emoji in message
                    local emoji_text = entry.value.text
                    vim.cmd(':G commit -m "' .. emoji_text .. ' ' .. msg .. '"')
                end)
            end,
        },
    },
}
require("telescope").load_extension("gitmoji")


require("oil").setup({
  default_file_explorer = true,
  columns = {
    "size",
    "icon",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  watch_for_changes = true,
  keymaps = {
     ["t"] = "actions.parent",
  },
  view_options = {
    show_hidden = true,
  }
})

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-j>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-]>",
  },
  log_level = "off",
})

require('gitsigns').setup()

require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = true
  },
})
require('mini.move').setup()

require('neoscroll').setup({
  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>', '<C-d>',
    '<C-b>', '<C-f>',
    '<C-y>', '<C-e>',
    'zt', 'zz', 'zb',
  },
  hide_cursor = true,          -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 0.35,   -- Global duration multiplier
  easing = 'linear',           -- Default easing function
  pre_hook = nil,              -- Function to run before the scrolling animation starts
  post_hook = nil,             -- Function to run after the scrolling animation ends
  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  ignored_events = {           -- Events ignored while scrolling
      'WinScrolled', 'CursorMoved'
  },
})

vim.lsp.config('ruff', {
})
vim.lsp.enable('ruff')

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})


require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "vimdoc",  "markdown", "markdown_inline", "python", "typescript", "javascript", "tsx" },
  sync_install = false,
  auto_install = true,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = {},
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
  },
}

require('nvim-ts-autotag').setup({
  aliases = {
  }
})

require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.3,      -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "botright",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window
    
    -- Floating window configuration (only applies when position = "float")
    float = {
      width = "80%",        -- Width: number of columns or percentage string
      height = "80%",       -- Height: number of rows or percentage string
      row = "center",       -- Row position: number, "center", or percentage string
      col = "center",       -- Column position: number, "center", or percentage string
      relative = "editor",  -- Relative to: "editor" or "cursor"
      border = "rounded",   -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
  -- File refresh settings
  refresh = {
    enable = true,           -- Enable file change detection
    updatetime = 100,        -- updatetime when Claude Code is active (milliseconds)
    timer_interval = 1000,   -- How often to check for file changes (milliseconds)
    show_notifications = true, -- Show notification when files are reloaded
  },
  -- Git project settings
  git = {
    use_git_root = true,     -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',        -- Command separator used in shell commands
    pushd_cmd = 'pushd',     -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',       -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude",        -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<leader>cc",       -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = "<leader>cc",     -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})
