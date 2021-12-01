local bait = require 'bait'
local git = require 'providers.git'
local defaultConfig = {
	prompt = {
		icon = '%',
		fail = '!'
	},
	git = {
		dirtyIcon = '*'
	}
}
local M = {
	config = defaultConfig,
	promptInfo = {
		exitCode = 0
	},
	version = '0.1.0'
}

local function initProviders()
	local providerTbl = {
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

	M.providers = {}
	for k, v in pairs(providerTbl) do
		for kk, vv in pairs(v) do
			M.providers[k .. '.' .. kk] = vv
		end
	end
end

local function getProviderFunction(providerstr)
	return M.providers[providerstr]
end

local function loadTheme(thm)
	-- take a table (thm) and set M.prompt
	M.prompt = thm
end

function M.setConfig(config)
	-- Load config but add defaults
	local mt = {
		__index = function(_, k)
			return defaultConfig[k]
		end
	}
	setmetatable(config, mt)
	M.config = config
end

-- Sets a Promptua theme.
function M.setTheme(theme)
	if type(theme) == 'string' then
		local themeName = theme
		local dataDir = hilbish.home .. '/.config/promptua/'
		local themePath = dataDir .. 'themes/' .. theme .. '/'
		local themeFile = themePath .. 'theme.lua'
		local ok = nil
		ok, theme = pcall(dofile, themeFile)
		if not ok then
			error(string.format('promptua: error loading %s theme', themeName))
			return
		end
	end

	loadTheme(theme)
end

function M.init()
	if not M.theme then error 'promptua: no theme set' end
	bait.catch('command.exit', function (code)
		M.promptInfo.exitCode = code
		local promptStr = ''
		for _, segment in pairs(M.prompt) do
			local provider = segment.provider
			local separator = segment.separator or ''
			local info = ''
			if type(provider) == 'function' then
				info = provider()
			elseif type(provider) == 'string' then
				info = getProviderFunction(provider)()
			else
				error('Invalid provider type: ' .. type(provider))
			end

			promptStr = promptStr .. info .. separator
		end
		prompt(promptStr)
	end)
end

initProviders()
return M
