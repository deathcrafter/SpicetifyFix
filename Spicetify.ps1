function CheckSpotify {
    if (![System.IO.File]::Exists("$($env:APPDATA)\Spotify\Spotify.exe")) {
        Write-Host "The desktop version of spotify is needed for spicetify to work properly. Please try again after installing."
        Start-Process "https://www.spotify.com/us/download/windows/"
        return $false
    }
    return $true
}
if (!CheckSpotify) {
    return
}
function Install-Spicetify {
    Invoke-WebRequest -UseBasicParsing `
        "https://raw.githubusercontent.com/khanhas/spicetify-cli/master/install.ps1" |
    Invoke-Expression

    spicetify config extensions webnowplaying.js

    DisableSpicetifyThemes

    spicetify backup apply
}
function IsSpicetifyAvailable {
    try {
        spicetify -v | Out-Null
        return $true
    }
    catch {
        if ((Read-Host "Spicetify doesn't seem to be installed. Do you want to install it now? 'Y/N'") -match 'Y') {
            Install-Spicetify
            return $true
        }
        else {
            return $false
        }
    }
}
if (!(IsSpicetifyAvailable)){
    return
}
function ApplySpicetify {
    spicetify upgrade
    spicetify backup apply
}
function DisableSpicetifyThemes {
    spicetify config inject_css 0 replace_colors 0
    ApplySpicetify
}
function EnableSpicetifyThemes {
    spicetify config inject_css 1 replace_colors 1
    ApplySpicetify
}
function InstallSpicetifyMarketPlace {
    Invoke-WebRequest -UseBasicParsing `
        "https://raw.githubusercontent.com/CharlieS1103/spicetify-marketplace/master/install.ps1" |
    Invoke-Expression
}
function FixSpicetifyPrefsPath {
    function Get-IniContent {
        param(
            [Parameter(Mandatory)]
            [string]
            $FilePath
        )

        $ini = @{}
        switch -regex -file $FilePath {
            “^\[(.+)\]” { # Section
                $section = $matches[1]
                $ini[$section] = @{}
                $CommentCount = 0
            }
            “^(;.*)$” { # Comment
                $value = $matches[1]
                $CommentCount = $CommentCount + 1
                $name = “Comment” + $CommentCount
                $ini[$section][$name] = $value
            }
            “(.+?)\s*=(.*)” { # Key
                $name, $value = $matches[1..2]
                $ini[$section][$name] = $value
            }
        }
        return $ini
    }
    function Write-IniContent {
        param(
            [Parameter(Mandatory)]
            [hashtable]
            $InputObject,
            [Parameter(Mandatory)]
            [string]
            $FilePath
        )
    
        if (-not [System.IO.File]::Exists($FilePath)) {
            New-Item $FilePath.Replace('\\[^\\]+$', '') -Name $FilePath.Replace('^(.+)\\([^\\]+?)$', '$2') -Value ''
        }
        else {
            Clear-Content $FilePath
        }
    
        foreach ($i in $InputObject.keys) {
            if (!($($InputObject[$i].GetType().Name) -eq “Hashtable”)) {
                #No Sections
                Add-Content -Path $FilePath -Value “$i=$($InputObject[$i])”
            }
            else {
                #Sections
                Add-Content -Path $FilePath -Value “[$i]”
                Foreach ($j in ($InputObject[$i].keys | Sort-Object)) {
                    if ($j -match “^Comment[\d]+”) {
                        Add-Content -Path $FilePath -Value “$($InputObject[$i][$j])”
                    }
                    else {
                        Add-Content -Path $FilePath -Value “$j=$($InputObject[$i][$j])”
                    }

                }
                Add-Content -Path $FilePath -Value “”
            }
        }
    }

    $configPath = "$($HOME)\.spicetify\config-xpui.ini"

    if ([System.IO.File]::Exists($configPath)) {
        $ini = Get-IniContent -FilePath $configPath
        $ini.Setting.prefs_path = "$($env:APPDATA)\Spotify\prefs"
        Write-IniContent -InputObject $ini -FilePath $configPath
    }
    else {
        if ((Read-Host "Config file seems to be missing. Want to reinstall spicetify now? (Y/N)") -match 'Y') {
            Install-Spicetify
        }
    }
}
function FixSpicetify {
    if (-not (IsSpicetifyAvailable)) {
        return
    }
    spicetify config extensions webnowplaying.js
    DisableSpicetifyThemes
    FixSpicetifyPrefsPath
    ApplySpicetify
}