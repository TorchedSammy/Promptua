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
		separator = ''
	},
	{
		provider = 'git.dirty',
		style = 'yellow'
	},
	{
		provider = 'user.time',
		style = 'gray'
	},
	{
		provider = 'prompt.failSuccess',
		separator = ' '
	}
}

promptua.setTheme(promptTheme)
promptua.init()

