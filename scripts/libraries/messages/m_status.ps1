<#
/--------------------- INFOS ---------------------\
Title...............: m_status.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 20:31
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Function that displays various errors
\--------------------------------------------------------------------------------------------------/
#>

function DisplaySuccess {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Message
    )
    Write-Host -ForegroundColor Green "▲ $Message"
    Write-Host
}

function DisplayError {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Message
    )
    Write-Host -ForegroundColor Red "▼ $Message"
}

function DisplayInfo {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Message
    )
    Write-Host -ForegroundColor Yellow "► $Message"
}

function DisplayTitle {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Message
    )
    Write-Host -ForegroundColor White -BackgroundColor Black "▬▬▬▬▬ $Message"
}

function DisplayQuestion {
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Message
    )
    Write-Host -ForegroundColor Cyan "• $Message"
}

function DisplayExit {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Time
    )
    Start-Sleep -Seconds $Time ; Write-Host -ForegroundColor Cyan "• Au revoir..."
    Exit 
}