<#
/--------------------- INFOS ---------------------\
Title...............: engine.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 20:22
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Launch the entire set of scripts, extenstions and functions in ont point
    - Directly executed by the user
        . Execute a quick check before launching all the tasks
\--------------------------------------------------------------------------------------------------/
#>

# Dot sourcing of all files
$WorkingDir = (Get-Location)
Get-ChildItem $WorkingDir\libraries -Recurse -Filter *.ps1 | ForEach-Object {
    . $PSItem.FullName
}

# First checks
DisplayTitle -Message "Vérifications"
CheckUTF8
SetInternetRequirements
InstallPS
InstallRSAT

# Install Active Directory roles
Try {
    Import-Module -Name ActiveDirectory -ErrorAction SilentlyContinue
    DisplayInfo -Message "Domaine installé : $((Get-WmiObject Win32_ComputerSystem).Domain)"
}
Catch {
    DisplayInfo -Message "Ce serveur n'est pas contrôleur de domaine"
    DisplayTitle -Message "Installation du rôle Active Directory"
    CreateMenu -Title "Menu AD" -Body @(
        "1) Installer une nouvelle forêt Active Directory",
        "2) Installer un contrôleur de domaine Active Directory",
        "3) Continuer sans rien faire"
    )
    do {
        Write-Host ""
        $task = Read-Host "Entrez le numéro de la tâche à exécuter "
    } until ($task -match '^[123]+$')
    switch ($task) {
        "1" {
            AddADForest
        }
        "2" {
            AddADDomainController
        }
        "3" {
            DisplayError -Message "Pas d'AD, pas de script..."
        }
    }
}

# Install OU structure
CreateMenu -Title "Menu Principal" -Body @(
    "1) Installer une structure d'OU de base"
    "2) Créer des utilisateurs"
    "3) Créer des modèles d'utilisateurs"
    "4) Créer des groupes"
    "5) Créer des partages AGDLP (4 Groupes + OU)"
    "6) Mode automatique (fichiers CSV)"
    "7) Sortir"
)
do {
    Write-Host ""
    $task = Read-Host "Entrez le numéro de la tâche à exécuter "
} until ($task -match '^[1234567]+$')
switch ($task) {
    "1" {
        
    }
    "2" {
        
    }
    "3" {
        
    }
    "4" {
        
    }
    "5" {
        
    }
    "6" {
        
    }
    "7" {
        DisplayExit -Time 2
    }
}