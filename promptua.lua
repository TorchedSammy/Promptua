local bait = require 'bait'
local lunacolors = require 'lunacolors'
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

local function callDefaultProvider(providerstr)
	return M.providers[providerstr]()
end

local function loadTheme(thm)
	-- take a table (thm) and set M.prompt
	M.prompt = thm
end

local function ansi(open, close, text)
	if text == nil then return '\27[' .. open .. 'm' end
	return '\27[' .. open .. 'm' .. text .. '\27[' .. close .. 'm'
end
local styles = {
	reset = {'{reset}', ansi(0)},
	bold = {'{bold}', ansi(1)},
	dim = {'{dim}', ansi(2)},
	italic = {'{italic}', ansi(3)},
	underline = {'{underline}', ansi(4)},
	invert = {'{invert}', ansi(7)},
	bold_off = {'{bold-off}', ansi(22)},
	underline_off = {'{underline-off}', ansi(24)},
	black = {'{black}', ansi(30)},
	red = {'{red}', ansi(31)},
	green = {'{green}', ansi(32)},
	yellow = {'{yellow}', ansi(33)},
	blue = {'{blue}', ansi(34)},
	magenta = {'{magenta}', ansi(35)},
	cyan = {'{cyan}', ansi(36)},
	white = {'{white}', ansi(37)},
	red_bg = {'{red-bg}', ansi(41)},
	green_bg = {'{green-bg}', ansi(42)},
	yellow_bg = {'{green-bg}', ansi(43)},
	blue_bg = {'{blue-bg}', ansi(44)},
	magenta_bg = {'{magenta-bg}', ansi(45)},
	cyan_bg = {'{cyan-bg}', ansi(46)},
	white_bg = {'{white-bg}', ansi(47)},
	gray = {'{gray}', ansi(90)},
	bright_red = {'{bright-red}', ansi(91)},
	bright_green = {'{bright-green}', ansi(92)},
	bright_yellow = {'{bright-yellow}', ansi(93)},
	bright_blue = {'{bright-blue}', ansi(94)},
	bright_magenta = {'{bright-magenta}', ansi(95)},
	bright_cyan = {'{bright-cyan}', ansi(96)}
}

-- fmt takes a string with format verbs and a style
local function fmt(formatstr, style, verbs)
	local stylesformatted = style:gsub('%a+', function(v)
		if not styles[v] then
			return ''
		end
		return '{' .. v .. '}'
	end)
	formatstr = lunacolors.format(stylesformatted:gsub('%s', '') .. formatstr)
	local formatted = formatstr:gsub('@%a+', function(v)
		return verbs[v:sub(2)] or v
	end)

	return formatted
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
	if not M.prompt then error 'promptua: no theme set' end
	bait.catch('command.exit', function (code)
		M.promptInfo.exitCode = code
		local promptStr = ''
		for _, segment in pairs(M.prompt) do
			local cond = segment.condition
			local function handleSegment()
				local provider = segment.provider
				local separator = segment.separator or ''
				local style = segment.style
				local format = segment.format or '@info'
				local info = ''

				if type(provider) == 'function' then
					info = provider()
				elseif type(provider) == 'string' then
					info = callDefaultProvider(provider)
				else
					error('promptua: invalid provider')
				end

				if style then
					local fmtbl = {info = info}
					if type(style) == 'string' then
						info = fmt(format, style, fmtbl)
					elseif type(style) == 'function' then
						info = fmt(format, style(M.promptInfo), fmtbl)
					end
				end

				promptStr = promptStr .. info .. separator
			end

			if type(cond) == 'function' then
				if cond() then
					handleSegment()
				end
			elseif type(cond) == 'nil' then
				handleSegment()
			else
				error('promptua: invalid condition')
			end
		end
		prompt(promptStr)
	end)
end

initProviders()
return M
