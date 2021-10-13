<#
/--------------------- INFOS ---------------------\
Title...............: c_pendingrestart.ps1
Author..............: Jean GUITTON
Date................: 2020-12-05, 15:02
Version.............: 0.1
Revision............: 0.1.1
\-------------------------------------------------/


/-------------------- CHANGES ---------------------------------------------------------------------\
    - V0.1.1 :
\--------------------------------------------------------------------------------------------------/


/------------------ DESCRIPTION -------------------------------------------------------------------\
    - Check if the server is pending restart and send reboot instruction
\--------------------------------------------------------------------------------------------------/
#>

function RestartAD {
    $ToReboot = CheckRestartAD
    If ($ToReboot) {
        $AnswerReboot = Prompt_ClosedQuestion -Message "Faut-il redémarrer le poste dans 30 secondes ?"
        If ($AnswerReboot -eq 'O') {
            DisplayInfo -Message "Redémarrage dans 30 secondes..."
            Start-Job -ScriptBlock {Start-Sleep -Seconds 30 ; Restart-Computer -Force} | Out-Null
            DisplaySpinner
        } else {
            DisplayInfo -Message "Ok, continuons..."
        }
    } else {
        DisplayInfo -Message "Pas de redémarrage nécessaire"
    }
}

function CheckRestartAD {
    $pendingRebootTests = @(
    @{
        Name = 'RebootPending'
        Test = { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing'  Name 'RebootPending' -ErrorAction Ignore }
        TestType = 'ValueExists'
    }
    @{
        Name = 'RebootRequired'
        Test = { Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update'  Name 'RebootRequired' -ErrorAction Ignore }
        TestType = 'ValueExists'
    }
    @{
        Name = 'PendingFileRenameOperations'
        Test = { Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations' -ErrorAction Ignore }
        TestType = 'NonNullValue'
    })

    Foreach ($test in $pendingRebootTests) {
        $result = $test.Test
        If ($test.TestType -eq 'ValueExists' -and $result) {
            return $true
        } elseif ($test.TestType -eq 'NonNullValue' -and $result -and $result.($test.Name)) {
            return $true
        } else {
            return $false
        }
    }
}

function RestartToRelaunch {
    $ToReboot = (CheckRestartAD)
    If ($ToReboot) {
        $AnswerTask = Prompt_ClosedQuestion -Message "Faut-il créer une tâche planifiée pour relancer le script après redémarrage ?"
        If ($AnswerTask -eq 'O') {
            $ScriptDir = "$env:LOCALAPPDATA"
            If ((Get-Location).Path -notcontains $env:LOCALAPPDATA) {
                DisplayInfo -Message "Copie du script en local"
                Copy-Item -Recurse -Path ..\..\AutoADCreate_Powershellv2 -Destination $ScriptDir\temp
            }
            DisplayInfo -Message "Création de la tâche planifiée"
            $TaskA = New-ScheduledTaskAction `
                -Execute "powershell.exe" `
                -Argument "-ExecutionPolicy Unrestricted -File engine.ps1" `
                -WorkingDirectory "$ScriptDir\Temp\AutoADCreate_Powershellv2\scripts" 
            $TaskT = New-ScheduledTaskTrigger -AtLogon
            $TaskP = New-ScheduledTaskPrincipal -UserID "$env:username" -LogonType Interactive -RunLevel Highest
            $TaskS = New-ScheduledTaskSettingsSet
            $TaskD = New-ScheduledTask -Action $TaskA -Principal $TaskP -Trigger $TaskT -Settings $TaskS
            Register-ScheduledTask "Relancer le script AD" -InputObject $TaskD | Out-Null
        }
        RestartAD
    } else {
        DisplayInfo -Message "Pas de redémarrage nécessaire"
    }
}