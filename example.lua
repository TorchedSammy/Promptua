package.loaded['promptua'] = nil
local promptua = require 'promptua'

local promptTheme = {
	{
		provider = 'dir.path',
		separator = ' '
	},
	{
		provider = 'git.branch',
	},
	{
		provider = 'git.dirty',
		separator = ' ',
	},
	{
		provider = 'prompt.failSuccess',
		separator = ' ',
	}
}

promptua.setTheme(promptTheme)
promptua.init()

