<#
/--------------------- INFOS ---------------------\
Title...............: e_prompts.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 13:16
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 : File creation
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Create various toolboxes to prompt the user
\--------------------------------------------------------------------------------------------------/
#>

function Prompt_OpenedQuestion {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [array]$Message
    )
    $valueopen = @()
    Foreach ($question in $Message) {
        DisplayQuestion -Message "$question"
        do {
            $value = Read-Host "► "
        } until ($value -match '^[0-9a-zA-Z]*$')
        $valueopen += $value
    }
    return $valueopen
}

function Prompt_ADObjectName {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [array]$Message
    )
    $valueobject = @()
    Foreach ($question in $Message) {
        DisplayQuestion -Message "$question"
        do {
            $value = Read-Host "► "
        } until ($value -match '^([a-z]+\.)*([a-z]+)$')
        $valueobject += $value
    }
    return $valueobject
}

function Prompt_ClosedQuestion {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        $Message
    )
    $valueclose = @()
    Foreach ($question in $Message) {
        DisplayQuestion -Message "$question"
        do {
            $value = Read-Host "► "
        } until ($value -match '^[ON]*$')
        $valueclose += $value
    }
    return $valueclose
}