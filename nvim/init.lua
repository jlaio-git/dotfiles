-- Basic Settings {{{
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- }}}

-- Plugins {{{
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		-- "stylua",
	},
})

vim.lsp.config("lua_ls", {})
require("vague").setup({
	-- optional configuration here
})

vim.cmd("colorscheme vague")
require("blink.cmp").setup({
	keymap = { preset = "default" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
	},
})

require("nvim-tmux-navigation").setup({
	disable_when_zoomed = true, -- defaults to false
})
--}}}

-- Helper Funcs {{{
-- }}}

-- Global Keymaps {{{
vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateTop<CR>")
vim.keymap.set("n", "<leader><space>", "za")
vim.keymap.set("n", "<leader>=", function()
	vim.cmd.update()
	vim.lsp.buf.format({ async = false })
	vim.notify("✓ Formatted " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Save (if modified) and format file with LSP" })

-- }}}

-- Auto Commands {{{
local config_group = vim.api.nvim_create_augroup("LuaConfig", { clear = true })

-- 3. Create the autocommand and assign it to the group
vim.api.nvim_create_autocmd("FileType", {
	-- Assign the autocommand to our group
	group = config_group,

	-- The pattern for which the autocommand should run
	pattern = "lua",

	-- The function to execute when the event is triggered
	callback = function()
		-- Set the keymap for the current buffer only
		vim.keymap.set("n", '<leader>s', function()
			vim.cmd.update()
			pcall(vim.cmd.source, "%")
			vim.notify("✓ Sourced " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
		end, { desc = "Save (if modified) and format file with LSP" })
	end,
})
-- }}}

-- vim: set foldmethod=marker:
