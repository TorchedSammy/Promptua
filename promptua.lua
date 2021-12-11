local bait = require 'bait'
local _ = require 'provider' -- get Providers tables
local _ = require 'packagesearch'

local defaultConfig = {
	prompt = {
		icon = '%',
		fail = '!'
	},
	git = {
		dirtyIcon = '*'
	}
}
M = {
	config = defaultConfig,
	promptInfo = {
		exitCode = 0
	},
	version = '0.2.0'
}

local function initProviders()
	M.providers = {}
	for k, v in pairs(Providers) do
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
	reset = ansi(0),
	bold = ansi(1),
	dim = ansi(2),
	italic = ansi(3),
	underline = ansi(4),
	invert = ansi(7),
	bold_off = ansi(22),
	underline_off = ansi(24),
	black = ansi(30),
	red = ansi(31),
	green = ansi(32),
	yellow = ansi(33),
	blue = ansi(34),
	magenta = ansi(35),
	cyan = ansi(36),
	white = ansi(37),
	red_bg = ansi(41),
	green_bg = ansi(42),
	yellow_bg = ansi(43),
	blue_bg = ansi(44),
	magenta_bg = ansi(45),
	cyan_bg = ansi(46),
	white_bg = ansi(47),
	gray = ansi(90),
	bright_red = ansi(91),
	bright_green = ansi(92),
	bright_yellow = ansi(93),
	bright_blue = ansi(94),
	bright_magenta = ansi(95),
	bright_cyan = ansi(96)
}

-- fmt takes a string with format verbs and a style and returns a formatted string,
-- with style applied
local function fmt(formatstr, style, verbs)
	local formatted = formatstr:gsub('@%a+', function(v)
		-- if its @style use our style
		if v:sub(2) == 'style' then
			return style:gsub('%a+', function(key)
				if not styles[key] then
					return ''
				end
				return styles[key]
			end):gsub('%s+', '')
		end
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
		local dataDir = hilbish.home .. '/.config/promptua/themes/'
		local themeFile = dataDir .. theme .. '/' .. 'theme.lua'
		local ok = nil
		ok, theme = pcall(dofile, themeFile)
		if not ok then
			themeFile = package.searchpath('promptua.themes.' .. theme, package.path)
			ok, theme = pcall(dofile, themeFile)
			if not ok then
				error(string.format('promptua: error loading %s theme', themeName))
				return
			end
		end
	end

	loadTheme(theme)
end

function M.handlePrompt(code)
	if not code then code = 0 end
	M.promptInfo.exitCode = code
	local promptStr = ''
	for _, segment in pairs(M.prompt) do
		local cond = segment.condition
		local function handleSegment()
			local provider = segment.provider
			local separator = segment.separator or ' '
			local style = segment.style
			local format = segment.format or '@style@icon@info'
			local info = ''

			if type(provider) == 'function' then
				info = provider()
			elseif type(provider) == 'string' then
				info = callDefaultProvider(provider)
			else
				error('promptua: invalid provider')
			end

			if style then
				local fmtbl = {info = info, icon = segment.icon or ''}
				if type(style) == 'string' then
					info = fmt(format, style, fmtbl)
				elseif type(style) == 'function' then
					info = fmt(format, style(M.promptInfo), fmtbl)
				end
			end

			promptStr = promptStr .. info .. separator .. styles.reset
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
end

function M.init()
	if not M.prompt then error 'promptua: no theme set' end
	M.handlePrompt()
	bait.catch('command.exit', M.handlePrompt)
end

initProviders()
return M
