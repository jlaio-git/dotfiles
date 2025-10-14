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
vim.opt.clipboard = "unnamedplus"
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
	{ src = "https://github.com/junegunn/fzf" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
})
vim.g.fzf_layout = { window = { width = 1.0, height = 0.3, relative = true, yoffset = 1.0 } }
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



require('minuet').setup {
	provider = 'gemini',
	provider_options = {
		gemini = {
			model = 'gemini-2.5-flash',
			-- system = "see [Prompt] section for the default value",
			-- few_shots = "see [Prompt] section for the default value",
			-- chat_input = "See [Prompt Section for default value]",
			stream = true,
api_key = 'GEMINI_API_KEY',
			end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
			optional = {},
		},
	},
	virtualtext = {
	    auto_trigger_ft = {"ruby"},
 keymap = {
            accept = nil,
            accept_line = "<C-l>",
            accept_n_lines = nil,
            -- Cycle to next completion item, or manually invoke completion
            next = nil,
            -- Cycle to prev completion item, or manually invoke completion
            prev = nil,
            dismiss = nil,
        },
	},
}


require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
		-- Manually invoke minuet completion
		-- ['<A-y>'] = require('minuet').make_blink_map(),
	},
	sources = {
		-- Enable minuet for autocomplete
		default = { "lsp", "path", "snippets", "buffer" },
		-- 		providers = {
		-- 			minuet = {
		-- 				name = 'minuet',
		-- 				module = 'minuet.blink',
		-- 				async = true,
		-- 				-- Should match minuet.config.request_timeout * 1000,
		-- 				-- since minuet.config.request_timeout is in seconds
		-- 				timeout_ms = 3000,
		-- 				score_offset = 50, -- Gives minuet higher priority among suggestions
		-- 			},
		-- 		},
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
	-- Recommended to avoid unnecessary requests
	completion = {
		trigger = { prefetch_on_insert = false },
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
local function runner_func()
	local ft = vim.bo.filetype
	local filename = vim.fn.expand('%:p')

	if ft == "lua" then
		pcall(vim.cmd.source, "%")
		vim.notify("✓ Sourced " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
		return
	end

	if vim.env.TMUX == nil then
		vim.notify("Not running inside tmux!", vim.log.levels.ERROR)
		return
	end

	local runners = {
		python = "python " .. filename,
		ruby = "ruby " .. filename,
		javascript = "node " .. filename,
	}

	local cmd = runners[ft]
	if not cmd then return end

	local pane_count = tonumber(vim.fn.system("tmux list-panes | wc -l")) or 1

	if pane_count == 1 then
		-- Create pane
		vim.fn.system(string.format("tmux split-window -d -v -p 30 && sleep 1 && tmux send-keys -t 2 '%s' Enter",
			cmd))
	else
		-- Send immediately to existing pane
		vim.fn.system(string.format("tmux send-keys -t 2 '%s' Enter", cmd))
	end
end
-- }}}

-- Global Keymaps {{{

vim.keymap.set( "i", "jk", "<esc>") 
vim.keymap.set("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>NvimTmuxNavigateTop<CR>")
vim.keymap.set("n", "<leader><space>", "za")
vim.keymap.set("n", "<leader>ev", "<cmd>e ~/.config/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>=", function()
	vim.cmd.update()
	vim.lsp.buf.format({ async = false })
	vim.notify("✓ Formatted " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { desc = "Save (if modified) and format file with LSP" })

-- }}}
vim.keymap.set('n', '<leader>r', runner_func, { desc = "Run in tmux pane" })

-- vim: set foldmethod=marker:
