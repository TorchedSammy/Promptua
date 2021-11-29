local bait = require 'bait'
local git = require 'providers.git'
local defaultConfig = {
	promptIcon = '%',
	git = {
		dirtyIcon = '*'
	}
}
local M = {config = defaultConfig}

local function initProviders()
	local providerTbl = {
		dir = {
			path = function()
				return '%d'
			end,
		},
		prompt = {
			icon = function ()
				return M.config.promptIcon
			end,
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

local function loadTheme(themeTbl)
	-- take a table (thm) and set M.prompt
	M.prompt = themeTbl
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
		theme = require(theme)
		local themePath = 'themes/' .. theme .. '/'
		local themeFile = themePath .. 'theme.lua'
		theme = dofile(themeFile)
	end

	loadTheme(theme)
end

function M.init()
	bait.catch('command.exit', function ()
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
