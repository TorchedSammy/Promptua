local bait = require 'bait'
local lunacolors = require 'lunacolors'
local providers = require 'promptua.providers' -- get Providers tables
local config = require 'promptua.config'
local searchpath = require 'promptua.searchpath'

local M = {
	version = 'v0.4.0'
}
setmetatable(M, {
	__index = function(_, k)
		if k == 'config' then return config end
	end
})

local function initProviders()
	M.providers = {}
	for k, v in pairs(providers) do
		for kk, vv in pairs(v) do
			M.providers[k .. '.' .. kk] = vv
		end
	end
end

local function callDefaultProvider(providerstr, segment)
	return M.providers[providerstr](segment)
end

local function loadTheme(thm)
	-- take a table (thm) and set M.prompt
	M.prompt = thm
end

-- fmt takes a string with format verbs and a style and returns a formatted string,
-- with style applied
local function fmt(formatstr, style, verbs)
	local formatted = formatstr:gsub('@%a+', function(v)
		-- if its @style use our style
		if v:sub(2) == 'style' then
			return style:gsub('%a+', function(key)
				if not lunacolors.formatColors[key] then
					return ''
				end
				return lunacolors.formatColors[key]
			end):gsub('%s+', '')
		end
		return verbs[v:sub(2)] or v
	end)

	return formatted
end

function M.setConfig(c)
	config.set(c)
end

-- Sets a Promptua theme.
function M.setTheme(theme)
	if type(theme) == 'string' then
		local themeName = theme
		local dataDir = hilbish.home .. '/.config/promptua/themes/'
		local themeFile = dataDir .. theme .. '/' .. 'theme.lua'
		local ok = nil
		ok, theme = pcall(dofile, themeFile)
		if not ok then
			themeFile = searchpath('promptua.themes.' .. theme, package.path)
			ok, theme = pcall(dofile, themeFile)
			if not ok then
				error(string.format('promptua: error loading %s theme', themeName))
				return
			end
		end
	end

	loadTheme(theme)
end

local function handleCond(cond)
	if type(cond) == 'function' then
		if cond() then
			return true
		end
	elseif type(cond) == 'nil' then
		return true
	else
		error('promptua: invalid condition')
	end
end

function M.handlePrompt(code)
	if not code then code = 0 end
	local promptStr = ''
	for _, segment in pairs(M.prompt) do
		local cond = segment.condition
		local function handleSegment()
			local provider = segment.provider
			local info = ''

			if type(provider) == 'function' then
				info = provider(segment)
			elseif type(provider) == 'string' then
				info = callDefaultProvider(provider, segment)
			elseif provider == nil then
				info = ''
			else
				error('promptua: invalid provider')
			end
			local style = segment.style or segment.defaults.style
			local icon = segment.icon or segment.defaults.icon or ''
			local format = segment.format or segment.defaults.format or M.config.format
			local separator = segment.separator or segment.defaults.separator or M.config.separator
			local condition = segment.condition or segment.defaults.condition
			if not handleCond(condition) then return end

			if style then
				-- reason for info or is because some segments only set icon and no info
				local fmtbl = {info = info or '', icon = icon}
				if type(style) == 'string' then
					info = fmt(format, style, fmtbl)
				elseif type(style) == 'function' then
					info = fmt(format, style(segment), fmtbl)
				end
			end

			promptStr = promptStr .. info .. separator .. lunacolors.formatColors.reset
		end

		if handleCond(cond) then handleSegment() end
	end
	hilbish.prompt(promptStr)
end

function M.init()
	if not M.prompt then error 'promptua: no theme set' end
	-- add functions to segments in M.prompt
	for _, segment in pairs(M.prompt) do
		if type(segment.provider) == 'string' and not M.providers[segment.provider] then
			error(string.format('promptua: unknown provider %s', segment.provider))
		end
		segment.defaults = {}
	end

	M.handlePrompt()
	bait.catch('command.exit', M.handlePrompt)
end

initProviders()
M.setConfig {}
return M
