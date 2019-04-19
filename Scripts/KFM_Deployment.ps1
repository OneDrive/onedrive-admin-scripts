<#       
    .DESCRIPTION
        Script to gather KFM state that can help KFM planning and deployment.

        The sample scripts are not supported under any Microsoft standard support 
        program or service. The sample scripts are provided AS IS without warranty  
        of any kind. Microsoft further disclaims all implied warranties including,  
        without limitation, any implied warranties of merchantability or of fitness for 
        a particular purpose. The entire risk arising out of the use or performance of  
        the sample scripts and documentation remains with you. In no event shall 
        Microsoft, its authors, or anyone else involved in the creation, production, or 
        delivery of the scripts be liable for any damages whatsoever (including, 
        without limitation, damages for loss of business profits, business interruption, 
        loss of business information, or other pecuniary loss) arising out of the use 
        of or inability to use the sample scripts or documentation, even if Microsoft 
        has been advised of the possibility of such damages.
        
        Author: Carter Green - cagreen@microsoft.com
        
        Deployment Guidnace: https://docs.microsoft.com/en-us/onedrive/redirect-known-folders        
#>
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
    foreach ($item in (Get-ChildItem $DesktopPath -recurse | Where-Object {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
       $DesktopSize += (Get-Item $item).length
       $DesktopItems++
    }
}

if(!$DocumentsInOD){
    foreach ($item in (Get-ChildItem $DocumentsPath -recurse | Where-Object {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
       $DocumentsSize += (Get-Item $item).length
       $DocumentsItems++
    }
}

if(!$PicturesInOD){
    foreach ($item in (Get-ChildItem $PicturesPath -recurse | Where-Object {-not $_.PSIsContainer} | ForEach-Object {$_.FullName})) {
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