curl -o bin/roblox.d.luau https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua

rojo sourcemap dev.project.json -o sourcemap.json

luau-lsp analyze \
	--defs=bin/roblox.d.luau \
	--flag:LuauTinyControlFlowAnalysis=true \
	--sourcemap=sourcemap.json \
	src

selene src
stylua --check src
eslint src

rm bin/roblox.d.luau
