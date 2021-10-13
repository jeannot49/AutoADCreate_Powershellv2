<#
/--------------------- INFOS ---------------------\
Title...............: e-textcompliance.ps1
Author..............: Jean GUITTON
Date................: 2020-12-01, 20:39
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Removes french accents and uppercase strings
\--------------------------------------------------------------------------------------------------/
#>

function RemoveStringDiacritic
{
<#
    .NOTES
        Auteur  : Francois-Xavier Cat
        Mail    : @lazywinadmin
        Site    : www.lazywinadmin.com
#>
    
    param
    (
        [ValidateNotNullOrEmpty()]
        [Alias('Text')]
        [System.String]$String,
        [System.Text.NormalizationForm]$NormalizationForm = "FormD"
    )
    
    BEGIN
    {
        $Normalized = $String.Normalize($NormalizationForm)
        $NewString = New-Object -TypeName System.Text.StringBuilder
        
    }
    PROCESS
    {
        $normalized.ToCharArray() | ForEach-Object -Process {
            if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($psitem) -ne [Globalization.UnicodeCategory]::NonSpacingMark)
            {
                [void]$NewString.Append($psitem)
            }
        }
    }
    END
    {
        Write-Output $($NewString -as [string]).ToLower()
    }
}