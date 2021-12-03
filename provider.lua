local git = require 'providers.git'

Providers = {
	dir = {
		path = function()
			return '%d'
		end,
	},
	prompt = {
		icon = function ()
			return M.config.prompt.icon
		end,
		failSuccess = function ()
			local icon = ''
			if M.promptInfo.exitCode == 0 then
				local successPrompt =  M.config.prompt.success
				icon = successPrompt and successPrompt or M.config.prompt.icon
			else
				local failPrompt = M.config.prompt.fail
				icon = failPrompt and failPrompt or M.config.prompt.icon
			end

			return icon
		end
	},
	git = {
		branch = function ()
			local branch = git.getBranch()
			if not branch then
				return ''
			end

			return branch
		end,
		dirty = function ()
			local isDirty = git.isDirty()
			if not isDirty then
				return ''
			end

			return M.config.git.dirtyIcon
		end
	}
}
