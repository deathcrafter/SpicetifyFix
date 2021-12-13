# SpicetifyHelpers

**This script, though works most of the time, isn't guaranteed to work every time. 
Some times, spicetify just doesn't work due to a rather big change in Spotify's base code. 
So, you just gotta wait for a new update.**

<h2><i>If you see warnings from spicetify that you need to reinstall spotify cause versions mismatch, do it and try again.</i></h2>

## FixSpicetify.ps1
> This if you want just a quick fix of spicetify (for Rainmeter)

```ps1
(Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/deathcrafter/SpicetifyHelpers/master/FixSpicetify.ps1").Content |
Invoke-Expression
```

<hr></hr>

## Spicetify.ps1
> This if you want to perform other actions

```ps1
(Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/deathcrafter/SpicetifyHelpers/master/Spicetify.ps1").Content |
Invoke-Expression
```

After running the above snippet, you can use the functions listed below:
### DisableSpicetifyThemes
> Disables spicetify custom themes.
### EnableSpicetifyThemes
> Enables spicetify custom themes. Find the themes [here](https://github.com/morpheusthewhite/spicetify-themes), or use the market place.
### FixSpicetify
> Fixes your spicetify installation, from a Rainmeter perspective.
### FixSpotifyPaths
> Changes the spicetify paths to desktop installation location.
### InstallSpicetifyMarketPlace
> Let's you install themes and extensions for spicetify directly from Spotify. Repo [here](https://github.com/CharlieS1103/spicetify-marketplace).
