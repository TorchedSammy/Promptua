local M = {}

function M.getBranch()
	local res = io.popen 'git rev-parse --abbrev-ref HEAD 2> /dev/null'
	local gitbranch = res:read()
	res:close()

	-- return nil if no git branch
	return gitbranch == '' and nil or gitbranch
end

return M
