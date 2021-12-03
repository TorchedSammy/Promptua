# 📡 Promptua
<!--
## Themes
One way of contributing is making a theme to ship with Promptua. A theme isn't  
promised to be added to the main repository since there shouldn't be too much themes.

If you think that your theme is unique though, not much reason to oppose to it!  
-->
## Providers
Promptua doesn't have that much providers, but you can change that. A good way to
contribute is to add a provider function.

To do so, edit the [provider source file](../provider.lua).  
The `Providers` table there have all premade provider functions, and have
nested tables of the functions. This is for better organization.  

To add, for example, a `dir.basename` provider you would have a basename table in
the dir table.  
```lua
Providers = {
	dir = {
		path = function()
			-- ...
		end,
		-- our basename provider here
		basename = function()
			-- ... code here
		end
	}
}
```

## Bug Reports
For bug reports, include the version of Promptua (`require 'promptua'.version`)
and/or git commit hash if you just pulled the latest git commit.  
Also include ways to reproduce the bug.

## Code Contribution
A contribution of code is simple: just make a pull request to the master branch.  
You *must* use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).
If any commit doesn't follow this standard, the pull request will not be considered.
If you made any breaking changes, be sure to document them.

### Code Style
- Prefer omitting parens if a function takes a single string argument (like `print 'hi'`)
- Use tabs
- camelCase for function names

### Finding ways to contribute code
Check out the [help wanted](https://github.com/TorchedSammy/Promptua/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+)
label to see anything Promptua needs help working on.

The [up for grabs](https://github.com/TorchedSammy/Promptua/issues?q=is%3Aissue+is%3Aopen+label%3A%22up+for+grabs%22+)
label is also available for easy issues. Have fun!
