<#
/--------------------- INFOS ---------------------\
Title...............: m_menus.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 20:40
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Automatically create a menu
\--------------------------------------------------------------------------------------------------/
#>

function CreateMenu {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Title,
        [Parameter(Mandatory=$true,Position=0)]
        [array]$Body
    )
    $MakeTopAndButtom = MakeTopAndButtom
    $MakeSpaces = MakeSpaces

    $MakeTopAndButtom
    CenterText -Message $Title
    $MakeTopAndButtom
    $MakeSpaces

    foreach ($obj in $Body) {
        CenterText $obj
    }

    $MakeSpaces
    $MakeSpaces
    $MakeTopAndButtom
}

function MakeTopAndButtom {
    $string = "# "
    for($i = 0; $i -lt $Host.UI.RawUI.BufferSize.Width - 4; $i++)
    {
        $string = $string + "▬"
    }
    $string = $string + " #"

    return $string
}

function MakeSpaces {
    $string = "# "
    for($i = 0; $i -lt $Host.UI.RawUI.BufferSize.Width - 4; $i++)
    {
        $string = $string + " "
    }
    $string = $string + " #"
    return $string
}

function CenterText {
    param($Message)

    $string = "# "

    for($i = 0; $i -lt (([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Max(0, $Message.Length / 2))) - 4; $i++) {
        $string = $string + " "
    }

    $string = $string + $Message
    for($i = 0; $i -lt ($Host.UI.RawUI.BufferSize.Width - ((([Math]::Max(0, $Host.UI.RawUI.BufferSize.Width / 2) - [Math]::Max(0, $Message.Length / 2))) - 2 + $Message.Length)) - 2; $i++) {
        $string = $string + " "
    }
    $string = $string + " #"
    return $string
}

function LinesOfCodeInCorrentFolder
{
    return (Get-ChildItem -include *.ps1 -recurse | select-string .).Count
}