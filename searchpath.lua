local fs = require 'fs'

-- package.searchpath function (hilbish is 5.1 so we don't have it)
return function(name, path, sep, rep)
	if type(name) ~= 'string' then
		error(('bad argument #1 to \'searchpath\' (string expected, got %s)'):format(type(path)), 2)
	end
	if type(path) ~= 'string' then
		error(('bad argument #2 to \'searchpath\' (string expected, got %s)'):format(type(path)), 2)
	end
	if sep ~= nil and type(sep) ~= 'string' then
		error(('bad argument #3 to \'searchpath\' (string expected, got %s)'):format(type(path)), 2)
	end
	if rep ~= nil and type(rep) ~= 'string' then
		error(('bad argument #4 to \'searchpath\' (string expected, got %s)'):format(type(path)), 2)
	end
	sep = sep or '.'
	rep = rep or '/'
	do
		local s, e = name:find(sep, nil, true)
		while s do
			name = name:sub(1, s - 1) .. rep .. name:sub(e + 1, -1)
			s, e = name:find(sep, s + #rep + 1, true)
		end
	end
	local tried = {}
	for m in path:gmatch('[^;]+') do
		local nm = m:gsub('?', name)
		tried[#tried + 1] = nm
		local ok = pcall(fs.stat, nm)
		if ok then
			return nm
		end
	end
	return nil
end
