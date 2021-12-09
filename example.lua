package.loaded['promptua'] = nil
local promptua = require 'promptua'
local git = require 'providers.git'

local promptTheme = {
	{
		provider = 'dir.path',
		style = 'blue',
	},
	{
		provider = 'git.branch',
		style = 'gray',
		separator = '',
		condition = git.isRepo
	},
	{
		provider = 'git.dirty',
		style = 'yellow',
		condition = git.isRepo
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

