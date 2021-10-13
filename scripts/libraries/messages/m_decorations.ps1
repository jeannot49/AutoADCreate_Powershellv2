<#
/--------------------- INFOS ---------------------\
Title...............: m_decorations.ps1
Author..............: Jean GUITTON
Date................: 2020-12-12, 13:01
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Decorations for script
\--------------------------------------------------------------------------------------------------/
#>

function Get-Funky{
    param([string]$Text)

    # Use a random colour for each character
    $Text.ToCharArray() | ForEach-Object{
        switch -Regex ($_){
            # Ignore new line characters
            "`r"{
                break
            }
            # Start a new line
            "`n"{
                Write-Host " ";break
            }
            # Use random colours for displaying this non-space character
            "[^ ]"{
                # Splat the colours to write-host
                $writeHostOptions = @{
                    ForegroundColor = ([system.enum]::GetValues([system.consolecolor])) | get-random
                    # BackgroundColor = ([system.enum]::GetValues([system.consolecolor])) | get-random
                    NoNewLine = $true
                }
                Write-Host $_ @writeHostOptions
                break
            }
            " "{Write-Host " " -NoNewLine}
        } 
        Write-Host
    }
}
