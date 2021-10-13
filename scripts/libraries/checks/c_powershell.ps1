<#
/--------------------- INFOS ---------------------\
Title...............: c_powershell.ps1
Author..............: Jean GUITTON
Date................: 2020-11-30, 23:12
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Check If the correct Powershell version is installed on the computer
\--------------------------------------------------------------------------------------------------/
#>

$TargetDir = $Env:temp + '\ps'
$OSVersion = (Get-WmiObject -Class Win32_OperatingSystem).Caption           # Check OS version
$PSversion = $PSVersionTable.PSVersion.Major								# Check PS version
$TargetPSVersion = 5														# Target PS version

If (!(Test-Path -Path $TargetDir)) {
	New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

function InstallPS {
	If ($PSversion -lt $TargetPSversion ) {
		DisplayInfo "Version $PSVersion de Powershell détectée sur votre système"
		$LastPSchoice = Prompt_ClosedQuestion -Message "Installer la version $TargetPSVersion ? Oui (O), Non (N)"
		Switch ($LastPSchoice) {
			"O" {
				If ($OSVersion -like "*Microsoft Windows Server 2008 R2*" -or $OSVersion -like "*Microsoft Windows 7*") {
					$DownloadedZip = "Win7AndW2K8R2-KB3191566-x64.zip"
					$DownloadedFile = "$TargetDir\Install-WMF5.1.ps1"
					Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/$DownloadedZip" -OutFile "$TargetDir\$DownloadedZip"
			
					# Launch the upgrade to Powershell v5.1
					Expand-Archive -Path "$TargetDir\$DownloadedZip" -DestinationPath "$TargetDir"
					powershell.exe $DownloadedFile

					#Start-Sleep -Seconds 10 ; Restart-Computer -Force
					Exit
				
				} elseif ($OSVersion -like "*Microsoft Windows Server 2012 R2*" -or $OSVersion -like "*Microsoft Windows 8.1*") {
					$DownloadedFile = "Win8.1AndW2K12R2-KB3191564-x64.msu"
					Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/$DownloadedFile" -OutFile "$TargetDir\$DownloadedFile"
					
					# Launch the upgrade to Powershell v5.1
					cmd.exe /C wusa.exe $WorkingDir\downloads\$DownloadedFile /log /quiet /norestart
					Start-Sleep -Seconds 10 ; Restart-Computer -Force
					Exit
			
				} elseif ($OSVersion -like "*Microsoft Windows Server 2012*") {
					$DownloadedFile = "W2K12-KB3191565-x64.msu"
					Invoke-WebRequest -Uri "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/$DownloadedFile" -OutFile "$TargetDir\$DownloadedFile"
			
					# Launch the upgrade to Powershell v5.1
					cmd.exe /C wusa.exe $WorkingDir\downloads\$DownloadedFile /log /quiet /norestart
					Start-Sleep -Seconds 10 ; Restart-Computer -Force
					Exit
			
				} else {
					Write-Host "Windows Server 2008R2/2012/2012R2 not found."
					Write-Host "OS incompatible with the script, exiting..."
					Write-Host ""
					Wait-Event -Timeout 2
					Exit
				}
			}
			"N" {
				DisplayError -Message "Pas de MAJ, pas d'AD !"
				Exit
			}
		}
	}
	Else {
		DisplayInfo -Message "La version de Powershell - $PSVersion - est compatible avec ce script"
	}
}