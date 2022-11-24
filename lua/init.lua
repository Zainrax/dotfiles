require("lsp")
require("style")

P = function(v)
	print(vim.inspect(v))
	return v
end

if pcall(require, "plenary") then
	RELOAD = require("plenary.reload").reload_module

	R = function(name)
		RELOAD(name)
		return require(name)
	end
end

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.org = {
	install_info = {
		url = "https://github.com/milisims/tree-sitter-org",
		revision = "main",
		files = { "src/parser.c", "src/scanner.cc" },
	},
	filetype = "org",
}

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
	},
})


require("orgmode").setup({
	org_agenda_files = { "~/orgs/**/*" },
	org_default_notes_file = "~/orgs/inbox.org",
	org_hide_leading_stars = true,
	org_todo_keywords = {
		"TODO(t)",
		"NEXT(n)",
		"STARTED(s)",
		"WAITING(w)",
		"|",
		"DELEGATED(l)",
		"SOMEDAY(m)",
		"DONE(d)",
	},
	org_agenda_template = {
		t = { description = "Todo", template = "* TODO %?\n %T %a" },
	},
	org_todo_keyword_faces = {
		TODO = ":background #0fbcf9 :foreground #ecf0f1 :weight bold",
		NEXT = ":background #e67e22 :foreground #ecf0f1 :weight bold",
		STARTED = ":background #ff5e57 :foreground #ecf0f1 :weight bold",
		WAITING = ":background #ffa801 :foreground #ecf0f1 :weight bold",
		DELEGATED = ":background #3498db :foreground #ecf0f1 :weight bold",
		SOMEDAY = ":background #34495e :foreground #ecf0f1 :weight bold",
		DONE = ":background #7f8c8d :foreground #2c3e50 :weight bold",
	},
})

require("org-bullets").setup({
	symbols = { "◉", "○", "✸", "✿" },
})

vim.g.copilot_filetypes = {
	TelescopePrompt = false,
}

local telescope = require("telescope")

telescope.setup({
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})
