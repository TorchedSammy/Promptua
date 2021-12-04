local bait = require 'bait'
local promptua = require 'promptua'

local conf = {
	prompt = {
		icon = 'ﴨ',
		success = '✓',
		fail = '✕'
	}
}
promptua.setConfig(conf)

return {
	{
		provider = 'prompt.failSuccess',
		style = function(info)
			if info.exitCode ~= 0 then
				return 'bold red'
			else
				return 'bold green'
			end
		end
	},
	{
		provider = 'user.name',
		style = 'bold yellow'
	},
	{
		provider = 'user.hostname',
		style = 'bold blue'
	},
	{
		provider = function()
			-- the current directory
			local cwd = hilbish.cwd()
			local splitwd = string.split(cwd, '/')
			-- truncate to last 2 directories
			-- if we are at root, just show the root
			if #splitwd == 1 then
				return splitwd[1]
			else
				-- if in home, show ~
				if cwd == hilbish.home then return '~' end
				return splitwd[#splitwd - 1] .. '/' .. splitwd[#splitwd]
			end
		end,
		style = 'bold magenta'
	},
	{
		provider = 'git.branch',
		style = 'bold cyan'
	},
	{
		provider = 'command.execTime',
		style = 'bold blue'
	},
	{
		provider = function()
			return '\n'
		end,
		separator = ''
	},
	{
		provider = 'prompt.icon',
		style = 'bold blue'
	}
}
