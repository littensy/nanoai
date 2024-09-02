local exec = require("util")

exec("rojo sourcemap dev.project.json --output sourcemap.json --watch & darklua process src/ rbx/ --watch")
