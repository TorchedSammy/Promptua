package.loaded['promptua'] = nil
local promptua = require 'promptua'

local promptTheme = {
	{
		provider = 'dir.path'
	},
	{
		provider = 'git.branch'
	},
	{
		provider = 'git.dirty'
	},
	{
		provider = 'prompt.icon'
	}
}

promptua.setTheme(promptTheme)
promptua.init()

