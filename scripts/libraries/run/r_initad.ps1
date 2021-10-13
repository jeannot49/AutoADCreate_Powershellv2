<#
/--------------------- INFOS ---------------------\
Title...............: r_initad.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 21:43
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 : File creation
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Install and promote as Domain Controller
\--------------------------------------------------------------------------------------------------/
#>

function AddADForest {
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [string]$DomainName,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$NetBIOSName
    )

    $GetDHCP = (Get-NetIPInterface | Where-Object {($PSItem.InterfaceIndex -eq (Get-NetIPConfiguration).InterfaceIndex) `
        -and ($PSItem.AddressFamily -eq 'IPv4')}).Dhcp

    If ($GetDHCP -notmatch "Enabled") {
        DisplayInfo -Message "IP Fixe"
        $DomainName = Prompt_ADObjectName -Message "Veuillez entrer le nom DNS du domaine"
        $NetBIOSName = Prompt_OpenedQuestion -Message "Veuillez entrer le nom NetBIOS du domaine"
        $FeatureList = @("RSAT-AD-Tools","AD-Domain-Services","DNS")

        Foreach ($Feature in $FeatureList) {
            If (((Get-WindowsFeature -Name $Feature).InstallState) -eq "Available") {
                DisplayInfo -Message "$Feature : Installation"
                Try {
                    Add-WindowsFeature -Name $Feature -IncludeManagementTools -IncludeAllSubFeature
                    $ForestConfiguration = @{
                        '-DatabasePath'= 'C:\Windows\NTDS';
                        '-DomainMode' = 'Default';
                        '-DomainName' = $DomainName;
                        '-DomainNetbiosName' = $NetBIOSName;
                        '-ForestMode' = 'Default';
                        '-InstallDns' = $true;
                        '-LogPath' = 'C:\Windows\NTDS';
                        '-NoRebootOnCompletion' = $true;
                        '-SysvolPath' = 'C:\Windows\SYSVOL';
                        '-Force' = $true;
                        '-CreateDnsDelegation' = $false
                    }
                    Install-ADDSForest @ForestConfiguration
                    DisplaySuccess -Message "AD, DNS et outils RSAT installés"
                    RestartToRelaunch
                } Catch {
                    DisplayError -Message "$Feature : Erreur pendant l'installation"
                }
            } else {
                DisplayInfo -Message "$Feature : Déjà présent sur le serveur" 
            }
        }

    } else {
        DisplayError -Message "DHCP incompatible avec un Active Directory, veuillez reconfigurer la/les carte(s) réseau"
    }
}

function AddADDomainController {
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [string]$DomainName,
        [Parameter(Mandatory=$false,Position=0)]
        [string]$NetBIOSName
    )

    $GetDHCP = (Get-NetIPInterface | Where-Object {($PSItem.InterfaceIndex -eq (Get-NetIPConfiguration).InterfaceIndex) `
        -and ($PSItem.AddressFamily -eq 'IPv4')}).Dhcp

    If ($GetDHCP -notmatch "Enabled") {
        DisplayInfo -Message "IP Fixe"
        $DomainName = Prompt_ADObjectName -Message "Veuillez entrer le nom DNS du domaine"
        $NetBIOSName = Prompt_OpenedQuestion -Message "Veuillez entrer le nom NetBIOS du domaine"
        $FeatureList = @("RSAT-AD-Tools","AD-Domain-Services","DNS")

        Foreach ($Feature in $FeatureList) {
            If (((Get-WindowsFeature -Name $Feature).InstallState) -eq "Available") {
                DisplayInfo -Message "$Feature : Installation"
                Try {
                    Add-WindowsFeature -Name $Feature -IncludeManagementTools -IncludeAllSubFeature
                    $DomainConfiguration = @{
                        '-DomainName' = $DomainName;
                        '-InstallDns' = $true;
                        '-Credential' = (Get-Credential "$NetBIOSName\administratreur")
                    }
                    Install-ADDSDomainController @DomainConfiguration
                    DisplaySuccess -Message "AD, DNS et outils RSAT installés"
                    RestartToRelaunch
                } Catch {
                    DisplayError -Message "$Feature : Erreur pendant l'installation"
                }
            } else {
                DisplayInfo -Message "$Feature : Déjà présent sur le serveur" 
            }
        }
    } else {
        DisplayError -Message "DHCP incompatible avec un Active Directory, veuillez reconfigurer la/les carte(s) réseau"
    }
}