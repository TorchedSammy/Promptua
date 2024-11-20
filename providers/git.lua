local M = {}

function M.isRepo()
	-- just run rev-parse to see if it's a git repo
	local gitRepo = io.popen 'git rev-parse --git-dir'
	local getHeadfile = gitRepo:read('*a'):gsub('\n', '')
	gitRepo:close()
	local isRepo = not getHeadfile:match 'fatal: not a git repository' or false

	if isRepo then
		return true, getHeadfile
	else
		return false, ''
	end
end

function M.getBranch()
	local isRepo, getHeadfile = M.isRepo()
	if not isRepo then
		return nil
	end

	local headfile = io.open(getHeadfile .. '/HEAD')
	if not headfile then
		return nil
	end

	local inf = headfile:read '*a'
	headfile:close()
	-- there is a format like 'ref: refs/heads/master'
	-- so get just the branch name
	-- and handle detached head case
	local branch = inf:match 'ref: refs/heads/(.+)' or inf:match 'ref: (.+)' or inf:match '(.+)'

	-- remove newline
	if branch then branch = branch:gsub('\n', '') end

	-- return nil if no branch found
	-- its falsy if branch is empty string which is why the or works
	return branch or nil
end

function M.isDirty()
	local res = io.popen 'git status --porcelain | wc -l'
	local dirt = res:read():gsub('\n', '')
	res:close()

	return (dirt ~= '0')
end

-- check if local is ahead of remote
-- will return nil if not a repo
function M.aheadRemote()
	if not M.isRepo() then
		return nil
	end

	local res = io.popen 'git rev-list @..@{u}'
	local ahead = res:read():gsub('\n', '')
	res:close()

	return (ahead ~= '0')
end

-- check if local is behind remote
-- will return nil if not a repo
function M.behindRemote()
	if not M.isRepo() then
		return nil
	end

	local res = io.popen 'git rev-list @{u}..@'
	local behind = res:read():gsub('\n', '')
	res:close()

	return (behind ~= '0')
end

return M

