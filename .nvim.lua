require("luau-lsp").config({
	server = {
		settings = {
			["luau-lsp"] = {
				require = {
					mode = "relativeToFile",
					directoryAliases = {
						["@lune"] = "~/.lune/.typedefs/0.8.8/",
					},
				},
				completion = {
					imports = {
						enabled = true,
					},
				},
			},
		},
	},
	platform = {
		type = "standard",
	},
	sourcemap = {
		enabled = true,
		autogenerate = true,
		rojo_project_file = "dev.project.json",
	},
})
