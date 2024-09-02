--> Runs checks on code quality

local exec = require("util")

exec("luau-lsp analyze --settings=.vscode/settings.json --sourcemap=sourcemap.json src")
exec("selene src")
exec("stylua --check src")
