local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
})

-- Fix Undefined global 'vim'
lsp.configure("lua-language-server", {
	diagnostics = {
		globals = { "vim" },
	},
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

lsp.setup_nvim_cmp({
	mapping = cmp_mappings,
})

lsp.set_preferences({
	suggest_lsp_servers = true,
	sign_icons = {
		error = "E",
		warn = "W",
		hint = "H",
		info = "I",
	},
})

local util = require("lspconfig.util")

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>gws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>gd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "<leader>[", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>]", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "ga", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "gr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)

	-- Stops tsserver from starting when opening a deno project
	if util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
		if client.name == "tsserver" then
			client.stop()
			return
		end
	end
end)

lsp.configure("tsserver", {
	root_dir = util.root_pattern({ "package.json", "tsconfig.json" }),
})

lsp.configure("eslint", {
	root_dir = util.root_pattern({ "package.json", "tsconfig.json" }),
})

lsp.configure("denols", {
	root_dir = util.root_pattern({ "deno.json", "deno.jsonc" }),
})

lsp.configure("prettier", {
	root_dir = util.root_pattern({ "package.json", "tsconfig.json" }),
	filetypes = {
		"css",
		"graphql",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"less",
		"markdown",
		"scss",
		"typescript",
		"typescriptreact",
		"yaml",
	},
})

lsp.setup()

local null_ls = require("null-ls")
local null_opts = lsp.build_options("null-ls", {})

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	on_attach = function(client, bufnr)
		null_opts.on_attach(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
		--- you can add more stuff here if you need it
	end,
	sources = {
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.stylua,
	},
})

vim.diagnostic.config({
	virtual_text = true,
})

-- Rust Tools

local rt = require("rust-tools")

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, remap = false }
			-- Hover actions
			vim.keymap.set("n", "<Leader>ra", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code action groups
			vim.keymap.set("n", "<Leader>rc", rt.code_action_group.code_action_group, { buffer = bufnr })
			-- Rust open cargo
			vim.keymap.set("n", "<Leader>ro", rt.open_cargo_toml.open_cargo_toml, { buffer = bufnr })
			-- Rust runnable
			vim.keymap.set("n", "<Leader>rr", rt.runnables.runnables, { buffer = bufnr })

			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>gws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			vim.keymap.set("n", "<leader>gd", function()
				vim.diagnostic.open_float()
			end, opts)
			vim.keymap.set("n", "<leader>[", function()
				vim.diagnostic.goto_prev()
			end, opts)
			vim.keymap.set("n", "<leader>]", function()
				vim.diagnostic.goto_next()
			end, opts)
			vim.keymap.set("n", "ga", function()
				vim.lsp.buf.code_action()
			end, opts)
			vim.keymap.set("n", "gr", function()
				vim.lsp.buf.references()
			end, opts)
			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("i", "<C-h>", function()
				vim.lsp.buf.signature_help()
			end, opts)
		end,
	},
	tools = {
		autoSetHints = true,
		cache = true,
		hover_actions = {
			auto_focus = true,
		},
	},
})
