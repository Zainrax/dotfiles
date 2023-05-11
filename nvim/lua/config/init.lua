require("config.packer")
-- require("config.lsp")
require("config.set")
require("config.style")
require("config.remap")

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
