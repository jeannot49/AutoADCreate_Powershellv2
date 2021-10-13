<#
/--------------------- INFOS ---------------------\
Title...............: e_rsat.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 23:12
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Install RSAT tools depending on the OS
\--------------------------------------------------------------------------------------------------/
#>

$OSVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption           # Check OS version
$ADRSAT = @(
	"Rsat.ServerManager.Tools~~~~0.0.1.0",
	"Rsat.Dns.Tools~~~~0.0.1.0",
	"Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
)

function InstallRSAT {
	DisplayInfo -Message "OS : $OSVersion"
	
	Switch -Wildcard ($OSVersion) { 
		'*Microsoft Windows 10*' {
			foreach ($Tool in $ADRSAT) {
				If ((Get-WindowsCapability -Name $tool -Online).State -eq 'NotPresent') {
					$ToolName = (Get-WindowsCapability -Online -Name $tool).DisplayName
					$LastPSchoice = Prompt_ClosedQuestion -Message "Installer RSAT ? Oui (O), Non (N)"
					Switch ($LastPSchoice) {
						"O" {
							DisplayInfo -Message "Installation - $ToolName"
							Add-WindowsCapability -Online -Name $Tool 
							If (Get-WindowsCapability -Name $Tool -Online) {
								DisplaySuccess -Message "$Tool : installé"
							} else {
								DisplayError -Message "Erreur lors de l'installation"
							}
						}
						"N" {
							DisplayInfo -Message "OK, continuons..."
						}
					}
				}
			}
			RestartToRelaunch
		}
		
		'*Microsoft Windows 7*' {
			DisplayInfo -Message "RSAT pour Windows 7 sera bientôt disponible..."
		}

		"*Microsoft Windows Server*" {
			If ((Get-WindowsFeature -Name RSAT).InstallState -eq 'Available') {
				$LastPSchoice = Prompt_ClosedQuestion -Message "Installer RSAT ? Oui (O), Non (N)"
				Switch ($LastPSchoice) {
					"O" {
						DisplayInfo -Message "Installation - RSAT"
						Install-WindowsFeature –Name RSAT -IncludeAllSubFeature -IncludeManagementTools | Out-Null
						If (Get-WindowsFeature -Name RSAT) {
							DisplaySuccess -Message "RSAT : installé"
							RestartToRelaunch
						} catch {
							DisplayError -Message "Erreur lors de l'installation"
						}
					}
					"N" {
						DisplayInfo -Message "Ok, continuons..."
					}
				}
			}
		}
	}
}