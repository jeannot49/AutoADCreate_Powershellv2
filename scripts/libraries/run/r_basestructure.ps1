<#
/--------------------- INFOS ---------------------\
Title...............: r_basestructure.ps1
Author..............: Jean GUITTON
Date................: 2021-10-13, 16:18
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 : File creation
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Create Active Directory base structure
\--------------------------------------------------------------------------------------------------/
#>

function CreateBaseStructure {
    Param (
        [string] $RootOrganizationUnit
	)
	# Déclaration de variables
    $DomainDN = (Get-ADDomain).distinguishedname
    $RootArray = @('Utilisateurs','Ordinateurs','Groupes','Ressources','Partages')
    $tabOU = Import-csv -Path csv\new_ou.csv -delimiter ";"   # Importation du tableau contenant les services à placer dans l'annuaire, au sein de l'OU Racine
	
    # Création de l'OU racine
    Write-Host ""
    Write-Host "/!\ Étape n°1.0 : Création de l'OU racine, correspondant à la première valeur de la colonne 'ou2name' dans le fichier 'csv\newOU.csv'"
	$RootOrganizationUnit = $tabOU[0].ou2name

	CheckOU -Name "$RootOrganizationUnit"
	if ($Global:is_thesame -eq $false) {
		New-ADOrganizationalUnit -DisplayName $RootOrganizationUnit -Name $RootOrganizationUnit -Path $DomainDN -ProtectedFromAccidentalDeletion $false -Verbose
	}

    # Création des OU de base sous la racine
	Write-Host ""
    Write-Host "/!\ Étape n°1.1 : Création d'OU de base, sous la racine --> voir ligne suivante"
    Write-Host "                  Ordinateurs, Utilisateurs, Groupes, Partages, Ressources"
	$path = (Get-ADOrganizationalUnit -Filter {name -eq $RootOrganizationUnit}).distinguishedname
	foreach ($item in $RootArray) {

		CheckOU -Name "$item"
		if ($Global:is_thesame -eq $false) {
			New-ADOrganizationalUnit -DisplayName $item -Name $item -Path $path -ProtectedFromAccidentalDeletion $false -verbose
		}
	}

    # Création d'OU sous les OU de base mentionnées plus haut
    Write-Host ""
    Write-Host "/!\ Etape n°1.2 : Création des OU de services"
	foreach ($item in $tabOU) {                            # Création d'OU de base, en fonction du fichier .csv "csv\new_OU.csv"
        $oucreate = $item.name
        #$oupath = $item.path
        $oupath1 = $item.ou1name
        $OUegal = "OU="
        $virgule = ","
        #OU=Utilisateurs,OU=KHOLAT,DC=GUITTON,DC=fr
        $usersoupath = "$OUegal$oupath1$virgule$OUegal$RootOrganizationUnit$virgule$DomainDN"

		CheckOU -Name "$oucreate"
		if ($Global:is_thesame -eq $false) {
			New-ADOrganizationalUnit -Name $oucreate -Path $usersoupath -ProtectedFromAccidentalDeletion $false -verbose
		}
    }
    
    # Création de groupes de sécurité, basé sur les sous-OU de l'OU Utilisateurs
    Write-Host ""
    Write-Host "/!\ Etape n°2 : Création de groupes de sécurité, portant le même nom que les OU de service sous Utilisateurs"
	$tabGroupOU = ($tabOU | Where-Object {$_.ou1name -match "Utilisateurs"}).name
	foreach ($item in $tabGroupOU) {
        CheckGroup -Name $item -Scope '2'                   # Création de groupes de sécurité globaux
        if ($Global:group_same -eq $false) {
            CreateSimpleGroup -Name $item -Scope '2'
        }
    }
}