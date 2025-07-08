local function roslyn_cmd()
	local mason_path = vim.fn.stdpath("data") .. "/mason/packages/roslyn"
	local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")

	return {
		mason_path .. "/roslyn",
		"--stdio",
		"--logLevel=Information",
		"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
		"--razorSourceGenerator="
			.. vim.fs.joinpath(mason_path, "libexec", "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
		"--razorDesignTimePath=" .. vim.fs.joinpath(
			vim.fn.stdpath("data"),
			"mason",
			"packages",
			"rzls",
			"libexec",
			"Targets",
			"Microsoft.NET.Sdk.Razor.DesignTime.targets"
		),
		"--extension",
		vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
	}
end

return {
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"tris203/rzls.nvim",
				config = function()
					---@diagnostic disable-next-line: missing-fields
					require("rzls").setup({})
				end,
			},
		},
		config = function()
			require("roslyn").setup({
				filewatching = "off",
				handlers = require("rzls.roslyn_handlers"),
			})
			vim.lsp.config("roslyn", {
				cmd = roslyn_cmd(),
				handlers = require("rzls.roslyn_handlers"),
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,

						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
				},
			})
			vim.lsp.enable("roslyn", true)

			vim.lsp.config("rzls", {
				cmd = { "rzls" },
			})
			vim.lsp.enable("rzls", true)
		end,
	},
	-- {
	-- 	"tris203/tree-sitter-razor",
	-- 	ft = { "razor" },
	-- },
}
