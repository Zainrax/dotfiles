local lsp_configs = require("lspconfig/configs")
local lsp_util = require("lspconfig/util")

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
	default_config = {
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,
		filetypes = { "vue" },
		-- If you want to use Volar's Take Over Mode (if you know, you know)
		--filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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
	},
}
lsp.volar_api.setup({})

lsp_configs.volar_doc = {
	default_config = {
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,

		filetypes = { "vue" },
		-- If you want to use Volar's Take Over Mode (if you know, you know):
		--filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
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
	},
}
lsp.volar_doc.setup({})

lsp_configs.volar_html = {
	default_config = {
		cmd = volar_cmd,
		root_dir = volar_root_dir,
		on_new_config = on_new_config,

		filetypes = { "vue" },
		-- If you want to use Volar's Take Over Mode (if you know, you know), intentionally no 'json':
		--filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
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
	},
}
lsp.volar_html.setup({})
