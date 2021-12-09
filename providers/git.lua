local M = {}

function M.isRepo()
	-- just run rev-parse to see if it's a git repo
	return os.execute("git rev-parse --git-dir > /dev/null 2>&1") == 0
end

function M.getBranch()
	if not M.isRepo() then
		return nil
	end

	local headfile = io.open '.git/HEAD'
	if not headfile then
		return nil
	end

	local inf = headfile:read '*a'
	headfile:close()
	-- there is a format like 'ref: refs/heads/master'
	-- so get just the branch name
	-- and handle detached head case
	local branch = inf:match 'ref: refs/heads/(.+)' or inf:match 'ref: (.+)'

	-- remove newline
	if branch then branch = branch:gsub('\n', '') end

	-- return nil if no branch found
	return branch or nil
end

function M.isDirty()
	local res = io.popen 'git status --porcelain | wc -l'
	local dirt = res:read():gsub('\n', '')
	res:close()

	return (dirt ~= '0')
end

return M
