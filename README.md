# Promptua
> 📡 A customizable prompt "engine" for Hilbish.

Promptua is a custom prompt builder/engine for Hilbish. It allows you to easily
create good looking prompts. For its use, it takes inspiration from
[oh-my-posh](https://ohmyposh.dev/) and Galaxyline for Neovim.

# Install
> Promptua requires Hilbish v2.0+

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

local theme = {
	{
		provider = 'dir.path',
		style = 'blue',
	},
	{
		provider = 'prompt.icon',
		style = 'green'
	}
}

promptua.setTheme(theme)
promptua.init()
```

## Segments
A segment is a table which has at least a `provider` key, which shows the info in the segment.
It can consist of the following keys:

```lua
{
	provider = '',
	separator = ' ',
	condition = function() end,
	icon = '',
	style = '',
	format = '@style@icon@info'
}
```

- `provider`: A function or string which *provides* the info for that segment. A string
provider will use one of the [premade providers](#premade-providers). A function
provider is passed the segment itself to set default values. If you are creating a theme,
it is preferred to set `segment.defaults` for the default values in a segment.

- `condition`: A function which will determine whether to show the segment in the prompt.
If it returns false, the provider will not be run and the segment will be skipped,

- `style`: The color or general style of the info in the segment.
It is space separated and follows the naming of Lunacolors, which you can
find more info on by running `doc lunacolors`. The following styles are
available:
	- Colors: black, red, green, blue, yellow, magenta, cyan, white.
	- Modifiers: dim, italic, underline, invert.

### Premade Providers
- `dir.path` - Path of current directory
- `git.branch` - Git branch
- `git.dirty` - Icon if local git has unpushed changes
- `prompt.icon` - Main prompt icon
- `prompt.failSuccess` - Prompt icon based on exit code of command
- `command.execTime` - Time it took to run a command (hidden if 0s)
- `user.name` - Username
- `user.hostname` - Hostname of machine

## Using Premade Themes
If you do not want to create a prompt on your own, you can look at the
[premade themes](themes/) included in this repository. These themes
can be used by just passing the name to the setTheme function like:
`promptua.setTheme 'myeline'`

## Config
If needed, you can change the default separator or format for segments,
or have configuration for certain providers via the config.

Promptua has a default which looks like:
	
```lua
{
	format = '@style@icon@text',
	separator = ' ',
	prompt = {
		icon = '%',
		fail = '!',
		success = '%'
	}
}
```

# Contributing
If you want to contribute, read the [CONTRIBUTING.md](CONTRIBUTING.md) file to find
our guidelines, and easy ways to contribute.

# License
MIT

