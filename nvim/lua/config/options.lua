-- Terminal with Nerd font
vim.g.have_nerd_font = false 

vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true -- You can also add relative line numbers, to help with jumping.

vim.o.mouse = 'a' -- Mouse Enabled

vim.o.showmode = false -- Don't show the mode, since it's already in the status line
vim.o.undofile = true
vim.o.signcolumn = 'yes' -- always keep little column on the left for signs, even if there are no signs atm
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- needs to be vim.opt for tables
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.confirm = true -- ask if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),

-- use spaces instead of tabs
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

--smart indent
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})


-- vim.o.cursorline = true Show which line your cursor is on

-- Sync clipboard between OS and Neovim.
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)


