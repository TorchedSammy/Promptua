package.loaded['promptua'] = nil
local promptua = require 'promptua'

local promptTheme = {
	{
		provider = 'dir.path',
		separator = ' ',
		style = 'blue',
	},
	{
		provider = 'git.branch',
		style = 'gray'
	},
	{
		provider = 'git.dirty',
		separator = ' ',
		style = 'yellow'
	},
	{
		provider = 'prompt.failSuccess',
		separator = ' ',
		style = function (info)
			if info.exitCode ~= 0 then
				return 'bold red'
			else
				return 'green'
			end
		end
	}
}

promptua.setTheme(promptTheme)
promptua.init()

