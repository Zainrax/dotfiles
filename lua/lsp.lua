-- Mappings
local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	-- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "E", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "ga", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<F7>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>'", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>[", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<Leader>]", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
end

local extension_path = "/home/abra/.vscode/extensions/vadimcn.vscode-lldb-1.6.7/"
local codelldb_path = extension_path .. "adapter/codelldb"
local coq = require("coq")
require("coq_3p")({
	{ src = "copilot", short_name = "COP", accept_key = "<c-j>" },
	{ src = "orgmode", short_name = "ORG" },
  { src = "vim_dadbod_completion", short_name = "DB"},
})
vim.g.coq_settings = {
	auto_start = true,
	display = {
		pum = {
			fast_close = false,
		},
	},
}
require('orgmode').setup_ts_grammar()

local lsp = require("lspconfig")
local lsp_configs = require("lspconfig.configs")
local lsp_util = require("lspconfig/util")

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

local function on_new_config(new_config, new_root_dir)
	local function get_typescript_server_path(root_dir)
		local project_root = lsp_util.find_node_modules_ancestor(root_dir)
		return project_root
				and (lsp_util.path.join(project_root, "node_modules", "typescript", "lib", "tsserverlibrary.js"))
			or ""
	end

	if
		new_config.init_options
		and new_config.init_options.typescript
		and new_config.init_options.typescript.serverPath == ""
	then
		new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
	end
end

local volar_cmd = { "volar-server", "--stdio" }
local volar_root_dir = lsp_util.root_pattern("package.json")

lsp_configs.volar_api = {
	default_config = coq.lsp_ensure_capabilities({
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,
		on_attach = on_attach,
		-- If you want to use Volar's Take Over Mode (if you know, you know)
    filetypes = {'typescript', 'javascript', 'vue', 'json'},
		init_options = {
			typescript = {
				serverPath = "",
			},
			languageFeatures = {
				references = true,
				definition = true,
				typeDefinition = true,
				callHierarchy = true,
				hover = true,
				rename = true,
				renameFileRefactoring = true,
				signatureHelp = true,
				codeAction = true,
				workspaceSymbol = true,
				completion = {
					defaultTagNameCase = "both",
					defaultAttrNameCase = "kebabCase",
					getDocumentNameCasesRequest = false,
					getDocumentSelectionRequest = false,
				},
			},
		},
	}),
}

lsp_configs.volar_doc = {
	default_config = coq.lsp_ensure_capabilities({
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,
		on_attach = on_attach,
		-- If you want to use Volar's Take Over Mode (if you know, you know):
    filetypes = {'typescript', 'javascript', 'vue', 'json'},
		init_options = {
			typescript = {
				serverPath = "",
			},
			languageFeatures = {
				documentHighlight = true,
				documentLink = true,
				codeLens = { showReferencesNotification = true },
				-- not supported - https://github.com/neovim/neovim/pull/14122
				semanticTokens = false,
				diagnostics = true,
				schemaRequestService = true,
			},
		},
	}),
}

lsp_configs.volar_html = {
	default_config = coq.lsp_ensure_capabilities({
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,
		on_attach = on_attach,
		-- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
    filetypes = {'typescript', 'javascript', 'vue'},
		init_options = {
			typescript = {
				serverPath = "",
			},
			documentFeatures = {
				selectionRange = true,
				foldingRange = true,
				linkedEditingRange = true,
				documentSymbol = true,
				-- not supported - https://github.com/neovim/neovim/pull/13654
				documentColor = false,
				documentFormatting = {
					defaultPrintWidth = 100,
				},
			},
		},
	}),
}

lsp.pyright.setup(coq.lsp_ensure_capabilities({
	on_attach = on_attach,
	settings = {
		python = {
			venvPath = "~/anaconda3/envs",
		},
	},
}))

lsp.denols.setup(coq.lsp_ensure_capabilities({
	root_dir = lsp.util.root_pattern("import_map.json"),
	on_attach = on_attach,
}))

-- lsp.tsserver.setup(coq.lsp_ensure_capabilities({
-- 	root_dir = lsp.util.root_pattern("tsconfig.json"),
-- 	on_attach = on_attach,
-- }))

lsp.tailwindcss.setup(coq.lsp_ensure_capabilities({
	root_dir = lsp.util.root_pattern("tailwind.config.js"),
	on_attach = on_attach,
}))

lsp.sqls.setup(coq.lsp_ensure_capabilities({
	on_attach = on_attach,
	settings = {
		sqls = {
			connections = {
				{
					driver = "postgresql",
					alias = "cacophony",
					proto = "tcp",
					user = "test",
					passwd = "test",
					host = "172.18.0.1",
					port = "5432",
					dbname = "cacophonytest",
				},
			},
		},
	},
}))

local rust_opts = {
	server = {
		on_attach = on_attach,
	},
}
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})
local servers = { "graphql", "tsserver", "svelte", "hls", "eslint", "gopls", "rnix", "kotlin_language_server", "volar"}
for _, lsp_name in ipairs(servers) do
	lsp[lsp_name].setup(coq.lsp_ensure_capabilities({ on_attach = on_attach }))
end
-- Lua
local sumneko_root_path = vim.fn.stdpath("cache") .. "/lspconfig/sumneko_lua/lua-language-server"
local sumneko_binary = "/usr/bin/lua-language-server"
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	flags = {
		debounce_text_changes = 150,
	},
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

local dap = require("dap")
dap.adapters.rt_lldb = function(on_adapter)
	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)

	local cmd = codelldb_path

	local handle, pid_or_err
	local opts = {
		stdio = { nil, stdout, stderr },
		detached = true,
	}
	handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
		stdout:close()
		stderr:close()
		handle:close()
		if code ~= 0 then
			print("codelldb exited with code", code)
		end
	end)
	assert(handle, "Error running codelldb: " .. tostring(pid_or_err))
	stdout:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			local port = chunk:match("Listening on port (%d+)")
			if port then
				vim.schedule(function()
					on_adapter({
						type = "server",
						host = "127.0.0.1",
						port = port,
					})
				end)
			else
				vim.schedule(function()
					require("dap.repl").append(chunk)
				end)
			end
		end
	end)
	stderr:read_start(function(err, chunk)
		assert(not err, err)
		if chunk then
			vim.schedule(function()
				require("dap.repl").append(chunk)
			end)
		end
	end)
end
dap.configurations.rust = {
	{
		name = "Launch file",
		type = "rt_lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
	},
}
dap.defaults.fallback.terminal_win_cmd = "30vsplit new"
dap.adapters.haskell = {
	type = "executable",
	command = "haskell-debug-adapter",
}
dap.configurations.haskell = {
	{
		type = "haskell",
		request = "launch",
		name = "Debug",
		workspace = "${workspaceFolder}",
		startup = "	${workspaceFolder}/test/Spec.hs",
		stopOnEntry = true,
		logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
		logLevel = "WARNING",
		ghciEnv = { test = "false" },
		ghciPrompt = "H>>= ",
		-- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
		ghciInitialPrompt = "Prelude>",
		ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
	},
}
require("dap-python").setup("~/anaconda3/bin/python")
-- Error in $.arguments.ghciEnv: parsing Map failed, expected Object, but encountered Array
dap.set_log_level("TRACE")
require("lsp_signature").setup()
require("dapui").setup({
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.25 },
				{ id = "breakpoints", size = 0.25 },
				{ id = "stacks", size = 0.25 },
				{ id = "watches", size = 0.25 },
			},
			size = 40,
			position = "left"
		},
		{
			elements = {
				'repl',
				'console'
			},
			size = 10,
			position = "bottom"
		}
	}
})
