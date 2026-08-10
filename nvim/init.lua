-- Pure Native Neovim (No plugins, fast boot)
-------------------------------------------------------------------------------
-- 1. LEADER KEY (Must be defined first before any mappings)
-------------------------------------------------------------------------------
vim.g.mapleader = " "

-------------------------------------------------------------------------------
-- 2. CORE OPTIONS & SPEED TUNING
-------------------------------------------------------------------------------
local opt = vim.opt

opt.number = true -- Line numbers
opt.relativenumber = true -- Relative line numbers
opt.termguicolors = true -- 24-bit RGB colors
opt.signcolumn = "yes" -- Always show sign column
opt.cursorline = true -- Highlight cursor line
opt.tabstop = 4 -- 4 space tab
opt.shiftwidth = 4
opt.expandtab = true -- Convert tabs to spaces
opt.smartindent = true
opt.ignorecase = true -- Search case insensitive
opt.smartcase = true

opt.updatetime = 250 -- Faster UI updates
opt.timeoutlen = 300 -- Faster shortcut responses
opt.scrolloff = 8 -- Keep 8 context lines while scrolling
opt.undofile = true -- Persistent undo across restarts
opt.splitright = true -- Natural split directions
opt.splitbelow = true

-- Native Folding (Safe fallback: uses indentation level instead of missing plugins)
opt.foldmethod = "indent"
opt.foldlevelstart = 99 -- Keep all sections expanded when opening files

-------------------------------------------------------------------------------
-- 3. EXTERNAL TOOLS INTEGRATION (:grep / ripgrep)
-------------------------------------------------------------------------------
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-------------------------------------------------------------------------------
-- 4. AUTOCOMMANDS
-------------------------------------------------------------------------------
-- Automatically open quickfix list after running :grep
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  command = "copen",
})

-- Markdown Note-Taking Settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true -- Soft wrap long sentences
    vim.opt_local.linebreak = true -- Wrap at whole words, not middle of words
    vim.opt_local.spell = true -- Turn on spell check
    vim.opt_local.conceallevel = 2 -- Hide raw markdown syntax (bold/italic markers)
    
    -- Press `gf` on a link like `[Note](file)` or `[[file]]` to jump directly to file.md
    vim.opt_local.suffixesadd:append(".md")
  end,
})

-- Automatically insert YAML frontmatter into NEW Markdown files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    -- Get file name without path or extension (e.g., "inter_state_water_disputes")
    local filename = vim.fn.expand("%:t:r")
    -- Format title: replace underscores/dashes with spaces and capitalize words
    local title = filename:gsub("[%-_]", " "):gsub("(%a)([%w_']*)", function(first, rest)
      return first:upper() .. rest:lower()
    end)
    local date = os.date("%Y-%m-%d")

    local frontmatter = {
      "---",
      'title: "' .. title .. '"',
      "date: " .. date,
      "tags: []",
      "status: draft",
      "---",
      "",
      "# " .. title,
      "",
    }

    -- Insert template at the top of the buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, frontmatter)
    -- Move cursor to line 4 (inside the tags brackets `[]`)
    vim.api.nvim_win_set_cursor(0, { 4, 7 })
  end,
})

-- Command 1: Fast Git Sync for Notes / Config
vim.api.nvim_create_user_command("SyncNotes", function()
  print("Syncing notes with remote...")
  vim.cmd("silent !git add . && git commit -m 'Auto-sync: " .. os.date("%Y-%m-%d %H:%M") .. "' && git pull --rebase && git push")
  print("Sync complete!")
end, { desc = "Git Add, Commit, Pull, and Push" })

-- Command 2: Publish shared section to public repository
vim.api.nvim_create_user_command("PublishShared", function()
  local public_dir = vim.fn.expand("~/notes/public/")
  local target_repo = vim.fn.expand("~/public-repo/") -- Path to cloned public repo

  print("Publishing shared notes...")
  -- Sync contents of public folder to target public repository folder
  vim.cmd("silent !rsync -av --delete " .. public_dir .. " " .. target_repo)
  -- Commit and push the public repository
  vim.cmd("silent !cd " .. target_repo .. " && git add . && git commit -m 'Update public notes' && git push")
  print("Public notes successfully published!")
end, { desc = "Publish public folder to public git repository" })

-- Mapping



-------------------------------------------------------------------------------
-- 5. KEY MAPPINGS
-------------------------------------------------------------------------------
-- File / Buffer Operations
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "Native file explorer" })

-- Git automation shortcut 
vim.keymap.set("n", "<leader>ps", "<cmd>SyncNotes<CR>", { desc = "Sync Notes via Git" })
vim.keymap.set("n", "<leader>pp", "<cmd>PublishShared<CR>", { desc = "Publish Shared Folder" })

-- Search & Quickfix Navigation
vim.keymap.set("n", "<leader>fg", ":grep ", { desc = "Grep text with ripgrep" })
vim.keymap.set("n", "[c", "<cmd>cprevious<CR>", { desc = "Previous quickfix" })
vim.keymap.set("n", "]c", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- Buffer Navigation
vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Visual Mode Line Movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Screen Centering During Jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result centered" })

-- Register & Clipboard Operations
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- External Utilities
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Launch tmux-sessionizer" })

