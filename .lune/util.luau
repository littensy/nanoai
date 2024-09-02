--> Internal utility library depended upon by other scripts

local process = require("@lune/process")
local stdio = require("@lune/stdio")

return function(command: string)
	local args = command:split(" ")
	local program = table.remove(args, 1) :: string

	local result = process.spawn(program, args, {
		stdio = "forward",
		shell = true,
	})

	if not result.ok then
		stdio.ewrite(
			`\n{stdio.style("bold") .. stdio.color("red") .. "err" .. stdio.color("reset")}: {program} exited with code {result.code}\n`
		)
		process.exit(result.code)
	end
end
