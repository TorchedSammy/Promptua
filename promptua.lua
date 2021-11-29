local bait = require 'bait'
local git = require 'providers.git'
local M = {}

local function initProviders()
	local providerTbl = {
		dir = {
			name = function()
				return '%d'
			end,
		},
		prompt = {
			icon = function ()
				return '%'
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

function M.setup()
	bait.catch('command.exit', function ()
		local promptStr = ''
		for _, segment in pairs(M.prompt) do
			local provider = segment.provider
			if type(provider) == 'function' then
				promptStr = promptStr .. provider()
			else
				promptStr = promptStr .. getProviderFunction(provider)()
			end
			promptStr = promptStr .. ' '
		end
		prompt(promptStr)
	end)
end

initProviders()
return M
