# Promptua
> 📡 A customizable prompt "engine" for Hilbish.

Promptua is a custom prompt builder/engine for Hilbish. It allows you to easily
create good looking prompts with ease. For its use, it takes inspiration from
[oh-my-posh](https://ohmyposh.dev/) and Galaxyline for Neovim.

# Install
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
	provider = 'dir.path'
},
{
	provider = 'prompt.icon'
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
	separator = ''
}
```  
The `provider` can be a function or string. If it is a string, it will get a premade
provider function which matches.

### Premade Providers
- `dir.path` - Path of current directory
- `git.branch` - Git branch
- `git.dirty` - Icon if local git has unpushed changes
- `prompt.icon` - Main prompt icon

## Config
If needed, a theme can have configuration for it. This is in place for things
like the `git.dirty` icon and prompt icon.

Promptua has a default config which looks like:  
```lua
{
	prompt = {
		icon = '%',
		success = {
			icon = '%'
		},
		fail = {
			icon = '%'
		}
	},
	git = {
		dirtyIcon = '*'
	}	
}
```

# License
MIT

