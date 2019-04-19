# This Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment.
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object
# code form of the Sample Code, provided that You agree: (i) to not use Our name, logo, or trademarks to market Your software
# product in which the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product in which the
# Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims
# or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code.inst

#CODE STARTS HERE
#--TODO: Put your Tenant ID here, similar to $GivenTenantID =  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
#--TODO: Put a designated location here for logs $OutputPath = 'example file path C:\...\Desktop\' + $env:USERNAME + "_" + $env:COMPUTERNAME + '.txt'


$PolictyState3 = ''
$PolictyState4 = ''
$KFMBlockOptInSet = 'False'
$KFMBlockOptOutSet = 'False'
$SpecificODPath = ''
$TotalItems = 0
$TotalSize = 0
[Long]$DesktopSize = 0
[Long]$DocumentsSize = 0
[Long]$PicturesSize = 0
$DesktopItems = 0
$DocumentsItems = 0
$PicturesItems = 0

$DesktopPath = [environment]::GetFolderPath("Desktop")
$DocumentsPath = [environment]::GetFolderPath("MyDocuments")
$PicturesPath = [environment]::GetFolderPath("MyPictures")

$ODAccounts = Get-ChildItem -Path HKCU:\Software\Microsoft\OneDrive\Accounts -name

$ODPath = foreach ($account in $ODAccounts){
    If($account -notlike 'Personal'){
        'HKCU:\Software\Microsoft\OneDrive\Accounts\' + $account
    }
}

foreach ($path in $ODPath){
    $ConfiguredTenantID = Get-ItemPropertyValue -path $path -name ConfiguredTenantID
    If ($GivenTenantID -eq $ConfiguredTenantID){
        $SpecificODPath = (Get-ItemPropertyValue -path $path -name UserFolder) + "\*"
        $KFMScanState = Get-ItemPropertyValue -path $path -name LastMigrationScanResult
        break
    }
}

$KFMGPOEligible = (($KFMScanState -ne 40) -and ($KFMScanState -ne 50))

$DesktopInOD = ($DesktopPath -like $SpecificODPath)
$DocumentsInOD = ($DocumentsPath -like $SpecificODPath)
$PicturesInOD = ($PicturesPath -like $SpecificODPath)

if(!$DesktopInOD){
    foreach ($item in (Get-ChildItem $DesktopPath -recurse | Where {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
       $DesktopSize += (Get-Item $item).length
       $DesktopItems++
    }
}

if(!$DocumentsInOD){
    foreach ($item in (Get-ChildItem $DocumentsPath -recurse | Where {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
       $DocumentsSize += (Get-Item $item).length
       $DocumentsItems++
    }
}

if(!$PicturesInOD){
    foreach ($item in (Get-ChildItem $PicturesPath -recurse | Where {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
       $PicturesSize += (Get-Item $item).length
       $PicturesItems++
    }
}

$TotalItems = $DesktopItems + $DocumentsItems + $PicturesItems
$TotalSize = $DesktopSize + $DocumentsSize + $PicturesSize

$PolictyState1 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMOptInWithWizard
$KFMOptInWithWizardSet = ($PolictyState1 -ne $null) -and ($PolictyState1 -eq $GivenTenantID)

$PolictyState2 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMSilentOptIn
$KFMSilentOptInSet = $PolictyState2 -eq $GivenTenantID

Try{
$PolictyState3 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMBlockOptIn
$KFMBlockOptInSet = ($PolictyState3 -ne $null) -and ($PolictyState3 -eq 1)
}Catch{}

Try{
$PolictyState4 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMBLockOptOut
$KFMBlockOptOutSet = ($PolictyState4 -ne $null) -and ($PolictyState4 -eq 1)
}Catch{}

$PolictyState5 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMSilentOptInWithNotification
$SendNotificationWithSilent = $PolictyState5 -eq 1

$ODVersion = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\OneDrive -Name Version



Set-Content $OutputPath "$KFMGPOEligible | Device_is_KFM_GPO_eligible"
if(!$DesktopInOD -or !$DocumentsInOD -or !$PicturesInOD){
    Add-Content $OutputPath "$TotalItems | Total_items" 
    Add-Content $OutputPath "$TotalSize | Total_size_bytes`n" 
}
Add-Content $OutputPath "$DesktopInOD | Desktop_is_in_OneDrive" 
if(!$DesktopInOD){
    Add-Content $OutputPath "$DesktopItems | Desktop_items" 
    Add-Content $OutputPath "$DesktopSize | Desktop_size_bytes`n" 
}
Add-Content $OutputPath "$DocumentsInOD | Documents_is_in_OneDrive"
if(!$DocumentsInOD){
    Add-Content $OutputPath "$DocumentsItems | Documents_items" 
    Add-Content $OutputPath "$DocumentsSize | Documents_size_bytes`n" 
}
Add-Content $OutputPath "$PicturesInOD | Pictures_is_in_OneDrive `n" 
if(!$PicturesInOD){
    Add-Content $OutputPath "$PicturesItems | Pictures_items" 
    Add-Content $OutputPath "$PicturesSize | Pictures_size_bytes`n" 
}
Add-Content $OutputPath "$KFMOptInWithWizardSet | KFM_Opt_In_Wizard_Set"
Add-Content $OutputPath "$KFMSilentOptInSet | KFM_Silent_Opt_In_Set"
Add-Content $OutputPath "$SendNotificationWithSilent | KFM_Silent_With_Notification_Set"
Add-Content $OutputPath "$KFMBlockOptInSet | KFM_Block_Opt_In_Set"
Add-Content $OutputPath "$KFMBlockOptOutSet | KFM_Block_Opt_Out_Set `n"
Add-Content $OutputPath "$ODVersion | OneDrive Sync client version"