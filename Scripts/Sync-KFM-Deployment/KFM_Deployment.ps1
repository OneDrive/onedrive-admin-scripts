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
        
        Deployment Guidance: https://docs.microsoft.com/en-us/onedrive/redirect-known-folders        
#>
#CODE STARTS HERE


#TenantID is now a required parameter. Use -GivenTenantID to set TenantID, e.g. "-GivenTenantID =  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'"
#OutputPath is now a required parameter. Use -OutputPath to designate location for logs, e.g. "-OutputPath = 'C:\...\Desktop\' + $env:USERNAME + "_" + $env:COMPUTERNAME + '.txt'"
#Parameters will now be asked for upon execution of the script if not provided in the command line that runs the script.
param(
    [parameter(Mandatory=$true, HelpMessage="Specify the tenant ID, e.g. xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")]
    [ValidateNotNullOrEmpty()]
    [string]$GivenTenantID,

    [parameter(Mandatory=$true, HelpMessage='Specify the output path for log files. Example file path: C:\...\Desktop\ + $env:USERNAME + "_" + $env:COMPUTERNAME + ".txt" ')]
    [ValidateNotNullOrEmpty()]
    [string]$OutputPath
)

$PolicyState3 = ''
$PolicyState4 = ''
$KFMBlockOptInSet = 'False'
$KFMBlockOptOutSet = 'False'
$SpecificODPath = ''
$TotalItemsNotInOneDrive = 0
$TotalSizeNotInOneDrive = 0
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

$TotalItemsNotInOneDrive = $DesktopItems + $DocumentsItems + $PicturesItems
$TotalSizeNotInOneDrive = $DesktopSize + $DocumentsSize + $PicturesSize

$PolicyState1 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMOptInWithWizard
$KFMOptInWithWizardSet = ($PolicyState1 -ne $null) -and ($PolicyState1 -eq $GivenTenantID)

$PolicyState2 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMSilentOptIn
$KFMSilentOptInSet = $PolicyState2 -eq $GivenTenantID

Try{
$PolicyState3 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMBlockOptIn
$KFMBlockOptInSet = ($PolicyState3 -ne $null) -and ($PolicyState3 -eq 1)
}Catch{}

Try{
$PolicyState4 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMBLockOptOut
$KFMBlockOptOutSet = ($PolicyState4 -ne $null) -and ($PolicyState4 -eq 1)
}Catch{}

$PolicyState5 = Get-ItemPropertyValue -path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -name KFMSilentOptInWithNotification
$SendNotificationWithSilent = $PolicyState5 -eq 1

$ODVersion = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\OneDrive -Name Version



Set-Content $OutputPath "$KFMGPOEligible | Device_is_KFM_GPO_eligible"
if(!$DesktopInOD -or !$DocumentsInOD -or !$PicturesInOD){
    Add-Content $OutputPath "$TotalItemsNotInOneDrive | Total_items_not_in_OneDrive" 
    Add-Content $OutputPath "$TotalSizeNotInOneDrive | Total_size_bytes_not_in_OneDrive`n" 
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
