require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
	},
	indent = {
		enable = true,
	},
	incremental_selection = { enable = true },
	textobjects = { enable = true },
})
