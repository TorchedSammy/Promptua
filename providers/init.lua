local bait = require 'bait'
local config = require 'promptua.config'
local git = require 'promptua.providers.git'
local execTime = nil

return {
	dir = {
		path = function()
			return '%d'
		end,
	},
	user = {
		name = function()
			return '%u'
		end,
		hostname = function()
			return '%h'
		end,
		time = function(segment)
			segment.defaults.icon = '🕙 '
			-- get the time with lua's os.time()
			-- and convert it to a string
			return os.date('%I:%M:%S %p', os.time())
		end,
	},
	prompt = {
		icon = function ()
			return config.prompt.icon
		end,
		failSuccess = function(segment)
			if hilbish.exitCode == 0 then
				-- defaults for success prompt
				segment.defaults = {
					style = 'green',
					icon = config.prompt.success or config.prompt.icon
				}
			else
				segment.defaults = {
					style = 'bold red',
					icon = config.prompt.fail or config.prompt.icon
				}
			end
		end
	},
	git = {
		branch = function(segment)
			segment.defaults.condition = git.isRepo
			local branch = git.getBranch()
			if not branch then
				return ''
			end

			return branch
		end,
		dirty = function(segment)
			segment.defaults = {
				condition = function()
					return git.isRepo() and git.isDirty()
				end,
				style = 'gray',
				icon = '*'
			}
		end
	},
	command = {
		execTime = function(segment)
			if not execTime then
				execTime = {stamp = os.time()}
				bait.catch('command.preexec', function()
					execTime.stamp = os.time()
				end)
			end

			local execTime = os.time() - execTime.stamp
			segment.defaults.condition = function()
				return execTime > 1
			end

			if execTime > 60 then
				return string.format('%dm %ds', math.floor(execTime / 60), execTime % 60)
			else
				return string.format('%ds', execTime)
			end
		end
	}
}
