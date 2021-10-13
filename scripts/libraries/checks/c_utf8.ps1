<#
/--------------------- INFOS ---------------------\
Title...............: c_utf8.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 23:12
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 : Set UTF-8 for the script
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Script template to use on all scripts of the project
\--------------------------------------------------------------------------------------------------/
#>

function CheckUTF8 {
    $detected = $PSDefaultParameterValues['Out-File:Encoding']
    if ($detected -like 'utf8') {
        DisplayInfo -Message "La codage par défaut - $detected - est compatible avec ce script"
    }
    else {
        $choice = Prompt_ClosedQuestion -Message "Le codage clavier '$detected' risque de provoquer des erreurs d'affichage. Voulez-vous le modifier ? Oui (O), Non (N) "
        switch ($choice) {
            "O" {
                $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
                DisplaySuccess -Message "Vous verrez les accents sur les E (é)"
            }
            "N" {
                DisplayError -Message "Vous ne verrez pas les accents sur les E (é)"
            }
        }
    }
}