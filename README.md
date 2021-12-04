# Promptua
> 📡 A customizable prompt "engine" for Hilbish.

Promptua is a custom prompt builder/engine for Hilbish. It allows you to easily
create good looking prompts with ease. For its use, it takes inspiration from
[oh-my-posh](https://ohmyposh.dev/) and Galaxyline for Neovim.

# Install
> Promptua requires Hilbish v0.6+

Clone to a Hilbish library directory:  
```
git clone --depth 1 https://github.com/TorchedSammy/Promptua ~/.local/share/hilbish/libs/promptua
```

# Usage
To make a Promptua prompt, you have to make a proper theme.
A theme is a table of [segments](#segments).

## Example
```lua
local promptua = require 'promptua'

local theme = {{
	provider = 'dir.path',
	style = 'blue',
},
{
	provider = 'prompt.icon',
	style = 'green'
}}

promptua.setTheme(theme)
promptua.init()
```  

## Segments
A segment is a table which has at least a `provider` key, which shows the info in the segment.
It can consist of the following keys:  
```lua
{
	provider = '',
	separator = '',
	condition = function() end,
}
```  
The `provider` can be a function or string. If it is a string, it will get a premade
provider function which matches.  
`condition` is a function which will determine whether to show the segment in the prompt.
If it returns false, the provider will not be run and the segment will be skipped,

### Premade Providers
- `dir.path` - Path of current directory
- `git.branch` - Git branch
- `git.dirty` - Icon if local git has unpushed changes
- `prompt.icon` - Main prompt icon
- `prompt.failSuccess` - Prompt icon based on exit code of command
- `command.execTime` - Time it took to run a command (hidden if 0s)
- `user.name` - Username
- `user.hostname` - Hostname of machine

## Config
If needed, a theme can have configuration for it. This is in place for things
like the `git.dirty` icon and prompt icon.

Promptua has a default config which looks like:  
```lua
{
	prompt = {
		icon = '%',
		fail = '!'
	},
	git = {
		dirtyIcon = '*'
	}	
}
```

# Contributing
If you want to contribute, read the [CONTRIBUTING.md](CONTRIBUTING.md) file to find
our guidelines, and easy ways to contribute.

# License
MIT

