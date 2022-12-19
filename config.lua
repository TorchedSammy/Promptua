local defaults = {
	format = '@style@icon@info',
	separator = ' ',
	prompt = {
		icon = '%',
	}
}
local conf = {}
local M = {
	set = function(c)
		conf = c
	end
}

return setmetatable(M, {
	__index = function(_, k)
		return conf[k] or defaults[k]
	end
})
