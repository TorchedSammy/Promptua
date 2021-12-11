local bait = require 'bait'
local git = require 'providers.git'
local _execTime = nil

Providers = {
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
		time = function()
			-- get the time with lua's os.time()
			-- and convert it to a string
			return os.date('🕙 %I:%M:%S %P', os.time())
		end,
	},
	prompt = {
		icon = function ()
			return M.config.prompt.icon
		end,
		failSuccess = function(segment)
			local icon = ''
			if M.promptInfo.exitCode == 0 then
				local successPrompt =  M.config.prompt.success
				icon = successPrompt and successPrompt or M.config.prompt.icon
				segment.setStyle 'green'
			else
				local failPrompt = M.config.prompt.fail
				icon = failPrompt and failPrompt or M.config.prompt.icon
				segment.setStyle 'bold red'
			end

			return icon
		end
	},
	git = {
		branch = function(segment)
			segment.setCondition(git.isRepo)
			local branch = git.getBranch()
			if not branch then
				return ''
			end

			return branch
		end,
		dirty = function(segment)
			segment.setCondition(git.isRepo)
			local isDirty = git.isDirty()
			if not isDirty then
				return ''
			end

			return M.config.git.dirtyIcon
		end
	},
	command = {
		execTime = function()
			if not _execTime then
				_execTime = {}
				bait.catch('command.preexec', function()
					_execTime.stamp = os.time()
				end)
				return ''
			end

			local execTime = os.time() - _execTime.stamp
			if execTime == 0 then return '' end
			if execTime > 60 then
				return string.format('%dm %ds', execTime / 60, execTime % 60)
			else
				return string.format('%ds', execTime)
			end

		end
	}
}
