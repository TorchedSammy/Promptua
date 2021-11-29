package.loaded['promptua'] = nil
local promptua = require 'promptua'

local promptTheme = {
	{
		provider = 'dir.name'
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

