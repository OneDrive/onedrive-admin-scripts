# OneDrive Policy Module
#https://docs.microsoft.com/en-us/onedrive/use-group-policy#list-of-policies

#region RegistryKeys

$allowFileSyncConflicts = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$blockTenantList = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\BlockTenantList'
$coauthor = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$teamlibraryautosync = 'HKCU:\Software\Policies\Microsoft\OneDrive\TenantAutoMount'
$synconmetered = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$synconpowersave = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$convertsyncedfiles = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$disabletutorial = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$downloadbandwidthlimit = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$automaticuploadbandwidthpercentage = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$fixeduploadbandwidthlimit = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$blockbeforesignin = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$blockremoteaccess = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$kfmblockoptin = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$kfmblockoptout = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$disablecustomroot = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive\DisableCustomRoot'
$preventpersonalsync = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$defaultlocation = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive\DefaultRootDir'
$kfmoptinwizard = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$enterprisering = 'HKCU:\SOFTWARE\Policies\Microsoft\OneDrive'
$maxsizeautodownload = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive\DiskSpaceCheckThresholdMB'
$clientring = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$kfmsilentoptin = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'
$silentsignin = 'HKLM:\SOFTWARE\Policies\Microsoft\OneDrive'

#endregion

#region AllowTenantList

<#
.SYNOPSIS
Adds a tenant ID from the allow sync list.

.DESCRIPTION
This setting lets you prevent users from easily uploading files to other organizations by specifying a list of allowed tenant IDs.

If you enable this setting, users will get an error if they attempt to add an account from an organization that is not allowed. If a user has already added the account, the files will stop syncing.

.PARAMETER TenantId
Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD.

.EXAMPLE
Add-ODAllowTenantList -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES
Takes priority over the tenant ID block list. Do not enable both settings at the same time.

SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AllowTenantList

#>

function Add-ODAllowTenantList {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($allowTenantList)

    New-ItemProperty -Path $allowTenantList -Name $TenantId -Value $TenantId -PropertyType String -Force
}

<#
.SYNOPSIS
Removes a tenant ID from the allow sync list.

.DESCRIPTION
This setting removes a tenant ID from the allow list.

.PARAMETER TenantId
Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD.

.EXAMPLE
Remove-ODAllowTenantList -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES

SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AllowTenantList
#>

function Remove-ODAllowTenantList {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    Test-ODKey($allowTenantList)

    Remove-ItemProperty -Path $allowTenantList -Name $TenantId -Force
}

#endregion

#region OfficefileSyncConflict

<#
.SYNOPSIS
This setting specifies what happens when conflicts occur between Office file versions during sync.

.DESCRIPTION
By default, users can decide if they want to merge changes or keep both copies. Users can also change settings in the OneDrive sync client to always keep both copies. 
(This option is available for Office 2016 or later only. With earlier versions of Office, both copies are always kept.)

If you enable this setting, users can decide if they want to merge changes or keep both copies.

.EXAMPLE
Enable-ODOfficeFileSyncConflict

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableHoldTheFile
#>

function Enable-ODOfficeFileSyncConflict {

    Test-ODKey($allowFileSyncConflicts)

    New-ItemProperty -Path $allowFileSyncConflicts -Name 'EnableHoldTheFile' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting specifies what happens when conflicts occur between Office file versions during sync.

.DESCRIPTION
By default, users can decide if they want to merge changes or keep both copies. Users can also change settings in the OneDrive sync client to always keep both copies. 
(This option is available for Office 2016 or later only. With earlier versions of Office, both copies are always kept.)

If you disable this setting, users cannot decide if they want to merge changes or keep both copies.

.EXAMPLE
Disable-ODOfficeFileSyncConflict

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableHoldTheFile
#>

function Disable-ODOfficeFileSyncConflict {

    Remove-ItemProperty -Path $allowFileSyncConflicts -Name 'EnableHoldTheFile' -Force
}

#endregion

#region BlockTenantList

<#
.SYNOPSIS
This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.

.DESCRIPTION
This setting lets you prevent users from easily uploading files to another organization by specifying a list of blocked tenant IDs.

If you enable this setting, users will get an error if they attempt to add an account from an organization that is blocked. If a user has already added the account, the files will stop syncing.

.PARAMETER TenantId
Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD.

.EXAMPLE
Add-ODBlockTenantList -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES
Takes priority over the tenant ID block list. Do not enable both settings at the same time.

SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#BlockTenantList

#>

function Add-ODBlockTenantList {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($blockTenantList)

    New-ItemProperty -Path $blockTenantList -Name $TenantId -Value $TenantId -PropertyType String -Force
}

<#
.SYNOPSIS
Remove a tenant from the tenant block list.

.DESCRIPTION
Removes a tenant from the tenant block list allowing users to synchronize with the tenant.

.PARAMETER TenantId
Remove-ODBlockTenantList -TenantId 'AAAA-BBBB-CCCC-DDDD'

.EXAMPLE
An example

.NOTES

SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#BlockTenantList
#>

function Remove-ODBlockTenantList {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    Test-ODKey($blockTenantList)

    Remove-ItemProperty -Path $blockTenantList -Name $TenantId -Force
}

#endregion

#region CoAuthorAndShare

<#
.SYNOPSIS
This setting lets multiple users use the Office 365 ProPlus, Office 2019, or Office 2016 desktop apps to simultaneously edit an Office file stored in OneDrive. It also lets users share files from the Office desktop apps.

.DESCRIPTION
This setting lets multiple users use the Office 365 ProPlus, Office 2019, or Office 2016 desktop apps to simultaneously edit an Office file stored in OneDrive. It also lets users share files from the Office desktop apps.

If you enable this setting, the Office tab will appear in OneDrive sync settings, and "Use Office 2016 to sync Office files that I open" will be selected by default.

.EXAMPLE
Enable-ODCoAuthorAndShare

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableAllOcsiClients
#>

function Enable-ODCoAuthorAndShare {
    Test-ODKey($coauthor)

    New-ItemProperty -Path $coauthor -Name 'EnableAllOcsiClients' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting prevents multiple users use the Office 365 ProPlus, Office 2019, or Office 2016 desktop apps to simultaneously edit an Office file stored in OneDrive.

.DESCRIPTION
This setting prevents multiple users use the Office 365 ProPlus, Office 2019, or Office 2016 desktop apps to simultaneously edit an Office file stored in OneDrive.

.EXAMPLE
Disable-ODCoAuthorAndShare

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableAllOcsiClients
#>

function Disable-ODCoAuthorAndShare {
    Test-ODKey($coauthor)

    New-ItemProperty -Path $coauthor -Name 'EnableAllOcsiClients' -Value 0 -PropertyType Dword -Force
}

#endregion

#region TeamSiteLibraryAutoSync

<#
.SYNOPSIS
This setting allows you to specify SharePoint team site libraries to sync automatically the next time users signs in to the OneDrive sync client (OneDrive.exe).

.DESCRIPTION
This setting allows you to specify SharePoint team site libraries to sync automatically the next time users signs in to the OneDrive sync client (OneDrive.exe). 
It may take up to 8 hours after a users signs in before the library begins to sync. To use the setting, you must enable OneDrive Files On-Demand, 
and the setting applies only for users on computers running Windows 10 Fall Creators Update (version 1709) or later. Do not enable this setting for the same library to more than 1,000 devices. 
This feature is not enabled for on-premises SharePoint sites.

.PARAMETER LibraryName
The display name of the Document Library.

.PARAMETER LibraryID
The GUID of the Document Library.

.EXAMPLE
Add-ODTeamSiteLibraryAutoSync -LibraryName 'Documents' -LibraryID 'e274dc8c-fee3-4774-a6f3-18723f050bac'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AutoMountTeamSites
#>

function Add-ODTeamSiteLibraryAutoSync {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Document Library name")]
        [string]$LibraryName,
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Document Library ID")]
        [string]$LibraryID
    )

    Test-Path($teamlibraryautosync)

    New-ItemProperty -Path $teamlibraryautosync -Name $LibraryName -Value $LibraryID -PropertyType String -Force
}

<#
.SYNOPSIS
This cmdlet removes a Document Library from the list of automatically synchronized libraries.

.DESCRIPTION
This cmdlet removes a Document Library from the list of automatically synchronized libraries.

.PARAMETER LibraryName
The display name of the Document Library.

.EXAMPLE
Remove-ODTeamSiteLibraryAutoSync -LibraryName 'Documents'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AutoMountTeamSites
#>

function Remove-ODTeamSiteLibraryAutoSync {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Document Library name")]
        [string]$LibraryName
    )

    Test-Path($teamlibraryautosync)

    Remove-ItemProperty -Path $teamlibraryautosync -Name $LibraryName -Force
}

#endregion

#region SyncOnMeteredNetworks

<#
.SYNOPSIS
This setting lets you turn off the auto-pause feature when devices connect to metered networks.

.DESCRIPTION
If you enable this setting, syncing will continue when devices are on a metered network. OneDrive will not automatically pause syncing.

If you disable or do not configure this setting, syncing will pause automatically when a metered network is detected and a notification will be displayed. 
Users can choose not to pause by clicking "Sync Anyway" in the notification. 
When syncing is paused, users can resume syncing by clicking the OneDrive cloud icon in the notification area of the taskbar and then clicking the alert at the top of the activity center.

.EXAMPLE
Enable-ODSyncOnMeteredNetworks

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePauseOnMeteredNetwork
#>

function Enable-ODSyncOnMeteredNetworks {
    Test-ODKey($synconmetered)

    New-ItemProperty -Path $synconmetered -Name 'DisablePauseOnMeteredNetwork' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting turns on the auto-pause feature when devices connect to metered networks.

.DESCRIPTION
This setting turns on the auto-pause feature when devices connect to metered networks.

.EXAMPLE
Disable-ODSyncOnMeteredNetworks

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePauseOnMeteredNetwork
#>

function Disable-ODSyncOnMeteredNetworks {
    Test-ODKey($synconmetered)

    New-ItemProperty -Path $synconmetered -Name 'DisablePauseOnMeteredNetwork' -Value 0 -PropertyType Dword -Force
}

#endregion

#region SyncOnPowerSave

<#
.SYNOPSIS
This setting lets you turn off the auto-pause feature for devices that have battery saver mode turned on.

.DESCRIPTION
If you enable this setting, syncing will continue when users turn on battery saver mode. OneDrive will not automatically pause syncing.

If you disable or do not configure this setting, syncing will pause automatically when battery saver mode is detected and a notification will be displayed. 
Users can choose not to pause by clicking "Sync Anyway" in the notification. 
When syncing is paused, users can resume syncing by clicking the OneDrive cloud icon in the notification area of the taskbar and then clicking the alert at the top of the activity center.

.EXAMPLE
Enable-ODSyncOnPowerSave

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePauseOnBatterySaver
#>

function Enable-ODSyncOnPowerSave {
    Test-ODKey($synconpowersave)

    New-ItemProperty -Path $synconpowersave -Name 'DisablePauseOnBatterySaver' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting lets you turn on the auto-pause feature for devices that have battery saver mode turned on.

.DESCRIPTION
If you enable this setting, syncing will stop when users turn on battery saver mode. OneDrive will automatically pause syncing.

.EXAMPLE
Disable-ODSyncOnPowerSave

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePauseOnBatterySaver
#>

function Disable-ODSyncOnPowerSave {
    Test-ODKey($synconpowersave)

    Remove-ItemProperty -Path $synconpowersave -Name 'DisablePauseOnBatterySaver' -Value 0 -PropertyType Dword -Force
}

#endregion

#region ConvertSyncTeamSiteToOnlineOnly

<#
.SYNOPSIS
This setting lets you convert synced SharePoint files to online-only files when you enable OneDrive Files On-Demand.

.DESCRIPTION
Enabling this setting helps you minimize network traffic and local storage usage if you have many PCs syncing the same team site.

If you enable this setting, files in currently syncing team sites will be changed to online-only files by default. Files later added or updated in the team site will also be downloaded as online-only files.

.EXAMPLE
Enable-ODConvertSyncTeamSiteToOnlineOnly

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DehydrateSyncedTeamSites
#>

function Enable-ODConvertSyncTeamSiteToOnlineOnly {
    Test-ODKey($convertsyncedfiles)

    New-ItemProperty -Path $convertsyncedfiles -Name 'DehydrateSyncedTeamSites' -Value 1 -PropertyType Dword -Force
}
#endregion

#region Tutorial

<#
.SYNOPSIS
This setting disables the OneDrive tutorial that appears at the end of Setup.

.DESCRIPTION
This setting lets you prevent the tutorial from launching in a web browser at the end of OneDrive Setup.

If you enable this setting, users will not see the tutorial after they complete OneDrive Setup.

.EXAMPLE
Disable-ODTutorial

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisableFRETutorial
#>

function Disable-ODTutorial {
    Test-ODKey($disabletutorial)

    New-ItemProperty -Path $disabletutorial -Name 'DisableTutorial' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting enables the OneDrive tutorial that appears at the end of Setup.

.DESCRIPTION
This setting allows the tutorial to launchat the end of OneDrive Setup.

If you enable this disable setting, users will see the tutorial after they complete OneDrive Setup.

.EXAMPLE
Enable-ODTutorial

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisableFRETutorial
#>

function Enable-ODTutorial {
    Test-ODKey($disabletutorial)

    New-ItemProperty -Path $disabletutorial -Name 'DisableTutorial' -Value 0 -PropertyType Dword -Force
}

#endregion

#region DownloadBandwidthLimit

<#
.SYNOPSIS
This setting lets you configure the maximum speed at which the sync client can download files.

.DESCRIPTION
This setting lets you configure the maximum speed at which the OneDrive sync client (OneDrive.exe) can download files. This rate is a fixed value in kilobytes per second, and applies only to syncing, not to downloading updates. The lower the rate, the slower files will download.

We recommend that you use this setting in cases where Files On-Demand is NOT enabled and where strict traffic restrictions are required, such as when you initially deploy the sync client in your organization or enable syncing of team sites. We don't recommend that you use this setting on an ongoing basis because it will decrease sync client performance and negatively impact the user experience. After initial sync, users typically sync only a few files at a time, and it doesn't have a significant effect on network performance. If you enable this setting, computers will use the maximum download rate that you specify, and users will not be able to change it.

If you enable this setting, enter the rate (from 1 to 100000) in the Bandwidth box. The maximum rate is 100000 KB/s. Any input lower than 50 KB/s will set the limit to 50 KB/s, even if the UI shows a lower value.

If you disable or do not configure this setting, the download rate is unlimited and users can choose to limit it in OneDrive sync client settings.

.EXAMPLE
Set-ODDownloadBandwidthLimit -Rate 200000

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DownloadBandwidthLimit
#>

function Set-ODDownloadBandwidthLimit {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a value between 50 and 100000. This value is in KB/s")]
        [int]$Rate
    )

    Test-ODKey($downloadbandwidthlimit)

    $val = [System.String]::Format('{0:x}', $rate)

    New-ItemProperty -Path $downloadbandwidthlimit -Name 'DownloadBandwidthLimit' -Value $val -PropertyType Dword -Force

}

<#
.SYNOPSIS
This setting disables the bandwidth restrictions for sync clients.

.DESCRIPTION
Disabling this setting will allow clients to download files as fast as possible.

.EXAMPLE
An example

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DownloadBandwidthLimit
#>
function Disable-ODDownloadBandwidthLimit {
    Test-ODKey($downloadbandwidthlimit)

    Remove-ItemProperty -Path $downloadbandwidthlimit -Name 'DownloadBandwidthLimit' -Force
}

#endregion

#region AutoUploadBandwidthPercentage

<#
.SYNOPSIS
This setting lets you balance the performance of different upload tasks on a computer by specifying the percentage of the computer's upload throughput that the OneDrive sync client (OneDrive.exe) can use to upload files.

.DESCRIPTION
This setting lets you balance the performance of different upload tasks on a computer by specifying the percentage of the computer's upload throughput that the OneDrive sync client (OneDrive.exe) can use to upload files. Setting this as a percentage lets the sync client respond to both increases and decreases in throughput. The lower the percentage you set, the slower files will upload. We recommend a value of 50% or higher. The sync client will periodically upload without restriction for one minute and then slow down to the upload percentage you set. This lets small files upload quickly while preventing large uploads from dominating the computer’s upload throughput. We recommend enabling this setting temporarily when you roll out Silently move Windows known folders to OneDrive or Prompt users to move Windows known folders to OneDrive to control the network impact of uploading known folder contents.

.EXAMPLE
Set-ODAutoUploadBandwidthPercentage -Rate 30

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AutomaticUploadBandwidthPercentage
#>
function Set-ODAutoUploadBandwidthPercentage {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a value between 10 and 99. This value is a percentage of upload bandwidth.")]
        [int]$Rate
    )

    Test-ODKey($automaticuploadbandwidthpercentage)

    $val = [System.String]::Format('{0:x}', $rate)

    New-ItemProperty -Path $automaticuploadbandwidthpercentage -Name 'AutomaticUploadBandwidthPercentage' -Value $val -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting disables the upload bandwidth percentage setting.

.DESCRIPTION
Disabling this setting will unrestrict bandwidth uploads allowing files to be uploaded as fast as possible.

.EXAMPLE
Disable-ODAutoUploadBandwidthPercentage

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#AutomaticUploadBandwidthPercentage
#>
function Disable-ODAutoUploadBandwidthPercentage {
    Test-ODKey($automaticuploadbandwidthpercentage)

    Remove-ItemProperty -Path $automaticuploadbandwidthpercentage -Name 'AutomaticUploadBandwidthPercentage' -Force
}

#endregion

#region FixedUploadBandwidth

<#
.SYNOPSIS
This setting lets you configure the maximum speed at which the OneDrive sync client (OneDrive.exe) can upload files. This rate is a fixed value in kilobytes per second. The lower the rate, the slower the computer will upload files.

.DESCRIPTION
This setting lets you configure the maximum speed at which the OneDrive sync client (OneDrive.exe) can upload files. This rate is a fixed value in kilobytes per second. The lower the rate, the slower the computer will upload files.

If you enable this setting and enter the rate (from 1 to 100000) in the Bandwidth box, computers will use the maximum upload rate that you specify, and users will not be able to change it in OneDrive settings. The maximum rate is 100000 KB/s. Any input lower than 50 KB/s will set the limit to 50 KB/s, even if the UI shows a lower value.

If you disable or do not configure this setting, users can choose to limit the upload rate to a fixed value (in KB/second), or set it to "Adjust automatically" which sets the upload rate to 70% of throughput. For info about the end-user experience, see Change the OneDrive sync client upload or download rate.

We recommend that you use this setting only used in cases where strict traffic restrictions are required. In scenarios where you need to limit the upload rate (such as when you roll out Known Folder Move), we recommend enabling Limit the sync client upload rate to a percentage of throughput to set a limit that adjusts to changing conditions. You should not enable both settings at the same time.

.EXAMPLE
Set-ODFixedUploadBandwidth -Rate 20000

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#UploadBandwidthLimit
#>
function Set-ODFixedUploadBandwidth {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a value between 50 and 100000. This value is in KB/s.")]
        [int]$Rate
    )

    Test-ODKey($fixeduploadbandwidthlimit)

    $val = [System.String]::Format('{0:x}', $rate)

    New-ItemProperty -Path $fixeduploadbandwidthlimit -Name 'UploadBandwidthLimit' -Value $val -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting disables the bandwidth restrictions on uploading files.

.DESCRIPTION
Disabling this setting will allow files to upload as fast as possible.

.EXAMPLE
An example

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#UploadBandwidthLimit
#>
function Disable-ODFixedUploadBandwidth {
    Test-ODKey($fixeduploadbandwidthlimit)

    Remove-ItemProperty -Path $fixeduploadbandwidthlimit -Name 'UploadBandwidthLimit' -Force
}

#endregion

#region BlockNetworkTrafficBeforeSignIn

<#
.SYNOPSIS
This setting lets you block the OneDrive sync client (OneDrive.exe) from generating network traffic (checking for updates, etc.) until users sign in to OneDrive or start syncing files on their computer.

.DESCRIPTION
If you enable this setting, users must sign in to the OneDrive sync client on their computer, or select to sync OneDrive or SharePoint files on the computer, for the sync client to start automatically.

If you disable or do not configure this setting, the OneDrive sync client will start automatically when users sign in to Windows.

.EXAMPLE
Enable-ODBlockNetworkTrafficBeforeSignIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#PreventNetworkTraffic
#>
function Enable-ODBlockNetworkTrafficBeforeSignIn {
    Test-ODKey($fixeduploadbandwidthlimit)

    New-ItemProperty -Path $fixeduploadbandwidthlimit -Name 'PreventNetworkTrafficPreUserSignIn' -PropertyType Dword -Value 1 -Force
}

<#
.SYNOPSIS
This setting lets you allow the OneDrive sync client (OneDrive.exe) to generate network traffic (checking for updates, etc.) prior to the users signing in to OneDrive.

.DESCRIPTION
If you disable this setting, users do not need to sign in to the OneDrive sync client on their computer for the sync client to start automatically.

.EXAMPLE
Disable-ODBlockNetworkTrafficBeforeSignIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#PreventNetworkTraffic
#>
function Disable-ODBlockNetworkTrafficBeforeSignIn {
    Test-ODKey($fixeduploadbandwidthlimit)

    Remove-ItemProperty -Path $fixeduploadbandwidthlimit -Name 'PreventNetworkTrafficPreUserSignIn' -Force
}

#endregion

#region BlockRemoteAccess
<#
.SYNOPSIS
This setting lets you block users from using the fetch feature when they’re signed in to the OneDrive sync client (OneDrive.exe) with their personal OneDrive account.

.DESCRIPTION
This setting lets you block users from using the fetch feature when they’re signed in to the OneDrive sync client (OneDrive.exe) with their personal OneDrive account. The fetch feature lets users go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive sync client, and access all files from that computer. By default, users can use the fetch feature.

If you enable this setting, users will be prevented from using the fetch feature.

.EXAMPLE
Enable-ODBlockRemoteAccess

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#RemoteAccessGPOEnabled
#>

function Enable-ODBlockRemoteAccess {
    Test-ODKey($blockremoteaccess)

    New-ItemProperty -Path $blockremoteaccess -Name 'GPOEnabled' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting lets you allow users to use the fetch feature when they’re signed in to the OneDrive sync client (OneDrive.exe) with their personal OneDrive account.

.DESCRIPTION
This setting lets you allow users to use the fetch feature when they’re signed in to the OneDrive sync client (OneDrive.exe) with their personal OneDrive account. The fetch feature lets users go to OneDrive.com, select a Windows computer that's currently online and running the OneDrive sync client, and access all files from that computer. By default, users can use the fetch feature.

If you disable this setting, users will be allowed to use the fetch feature.

.EXAMPLE
Disable-ODBlockRemoteAccess

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#RemoteAccessGPOEnabled
#>

function Disable-ODBlockRemoteAccess {
    Test-ODKey($blockremoteaccess)

    New-ItemProperty -Path $blockremoteaccess -Name 'GPOEnabled' -Value 0 -PropertyType Dword -Force
}
#endregion

#region PreventChangeLocation

<#
.SYNOPSIS
This setting lets you block users from changing the location of the OneDrive folder on their computer.

.DESCRIPTION
This setting lets you block users from changing the location of the OneDrive folder on their computer.

To use this setting, in the Options box, click Show to enter your tenant ID, and enter 1 to enable the setting or 0 to disable it.

If you enable this setting, the “Change location” link is hidden in OneDrive Setup. The OneDrive folder will be created in the default location, or in the custom location you specified if you enabled Set the default location for the OneDrive folder.
.EXAMPLE
Enable-ODPreventChangeLocation -TenantId AAAA-BBBB-CCCC-DDDD

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisableCustomRoot
#>
function Enable-ODPreventChangeLocation {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($disablecustomroot)

    New-ItemProperty -Path $disablecustomroot -Name $TenantId -Value 1 -PropertyType String -Force
}

<#
.SYNOPSIS
This setting lets you allowe users to change the location of the OneDrive folder on their computer.

.DESCRIPTION
This setting lets you allowe users to change the location of the OneDrive folder on their computer.

To use this setting, in the Options box, click Show to enter your tenant ID, and enter 1 to enable the setting or 0 to disable it.

If you disable this setting, the “Change location” link is shown in OneDrive Setup.

.EXAMPLE
Disable-ODPreventChangeLocation -TenantId AAAA-BBBB-CCCC-DDDD

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisableCustomRoot
#>
function Disable-ODPreventChangeLocation {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($disablecustomroot)

    New-ItemProperty -Path $disablecustomroot -Name $TenantId -Value 0 -PropertyType String -Force
}
#endregion

#region PreventKFMRedirectOptIn

<#
.SYNOPSIS
This setting prevents users from moving their Documents, Pictures, and Desktop folders to any OneDrive for Business account.

.DESCRIPTION
If you enable this setting, users won't be prompted with a window to protect their important folders, and the "Start protection" command will be disabled. If the user has already moved their known folders, the files in those folders will remain in OneDrive. This setting will not take effect if you've enabled "Prompt users to move Windows known folders to OneDrive" or "Silently move Windows known folders to OneDrive."

If you disable or do not configure this setting, users can choose to move their known folders.

.EXAMPLE
Enable-ODKFMBlockOptIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#BlockKnownFolderMove
#>

function Enable-ODKFMBlockOptIn {

    Test-ODKey($kfmblockoptin)

    New-ItemProperty -Path $kfmblockoptin -Name 'KFMBlockOptIn' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting allows users to move their Documents, Pictures, and Desktop folders to any OneDrive for Business account.

.DESCRIPTION
If you disable this setting, users will be prompted with a window to protect their important folders, and the "Start protection" command will be enabled. Users can also choose to move their known folders.

.EXAMPLE
Disable-ODKFMBlockOptIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#BlockKnownFolderMove
#>

function Disable-ODKFMBlockOptIn {

    Test-ODKey($kfmblockoptin)

    New-ItemProperty -Path $kfmblockoptin -Name 'KFMBlockOptIn' -Value 0 -PropertyType Dword -Force
}
#endregion

#region PreventKFMRedirectOptOut

<#
.SYNOPSIS
This setting forces users to keep their Documents, Pictures, and Desktop folders directed to OneDrive.

.DESCRIPTION
If you enable this setting, the "Stop protecting" button in the "Set up protection of important folders" window will be disabled and users will receive an error if they try to stop syncing a known folder.

If you disable or do not configure this setting, users can choose to redirect their known folders back to their PC.

.EXAMPLE
Enable-ODKFMBlockOptOut

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMBlockOptOut
#>

function Enable-ODKFMBlockOptOut {

    Test-ODKey($kfmblockoptout)

    New-ItemProperty -Path $kfmblockoptout -Name 'KFMBlockOptOut' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting forces users to keep their Documents, Pictures, and Desktop folders directed to OneDrive.

.DESCRIPTION
If you disable this setting, the "Stop protecting" button in the "Set up protection of important folders" window will be enabled and users can choose to redirect their known folders back to their PC.

.EXAMPLE
Disable-ODKFMBlockOptOut

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMBlockOptOut
#>

function Disable-ODKFMBlockOptOut {
    Test-ODKey($kfmblockoptout)

    New-ItemProperty -Path $kfmblockoptout -Name 'KFMBlockOptOut' -Value 0 -PropertyType Dword -Force
}
#endregion

#region PreventPersonalSync

<#
.SYNOPSIS
This setting lets you block users from signing in with a Microsoft account to sync their personal OneDrive files. By default, users are allowed to sync personal OneDrive accounts.

.DESCRIPTION
This setting lets you block users from signing in with a Microsoft account to sync their personal OneDrive files. By default, users are allowed to sync personal OneDrive accounts.

If you enable this setting, users will be prevented from setting up a sync relationship for their personal OneDrive account. Users who are already syncing their personal OneDrive when you enable this setting won’t be able to continue syncing (and will be shown a message that syncing has stopped), but any files synced to the computer will remain on the computer.

.EXAMPLE
Enable-ODPreventPersonalSync

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePersonalSync
#>
function Enable-ODPreventPersonalSync {
    
    Test-ODKey($preventpersonalsync)

    New-ItemProperty -Path $preventpersonalsync -Name 'DisablePersonalSync' -Value 1 -Dword String -Force
}

<#
.SYNOPSIS
This setting lets you allow users to sign in with a Microsoft account to sync their personal OneDrive files.

.DESCRIPTION
This setting lets you allow users to sign in with a Microsoft account to sync their personal OneDrive files.

If you enable this setting, users will be allowed to set up a sync relationship for their personal OneDrive account.
.EXAMPLE
Disable-ODPreventPersonalSync

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DisablePersonalSync
#>
function Disable-ODPreventPersonalSync {
    
    Test-ODKey($preventpersonalsync)

    New-ItemProperty -Path $preventpersonalsync -Name 'DisablePersonalSync' -Value 0 -Dword String -Force
}

#endregion

#region KFMOptInWizard

<#
.SYNOPSIS
This setting displays the window that prompts users to move their Documents, Pictures, and Desktop folders to OneDrive.

.DESCRIPTION
If you enable this setting and provide your tenant ID, users who are syncing their OneDrive will see the window above when they're signed in. If they close the window, a reminder notification will appear in the activity center until they move all three known folders. If a user has already redirected their known folders to a different OneDrive account, they will be prompted to direct the folders to the account for your organization (leaving existing files behind).

If you disable or do not configure this setting, the window that prompts users to protect their important folders won't appear.

.EXAMPLE
Enable-ODKFMOptInWizard -TenantId AAAA-BBBB-CCCC-DDDD

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMOptInWithWizard
#>

function Enable-ODKFMOptInWizard {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )

    Test-ODKey($kfmoptinwizard)

    New-ItemProperty -Path $kfmblockoptin -Name 'KFMOptInWithWizard' -Value $TenantId -PropertyType String -Force
}

<#
.SYNOPSIS
This setting prevents the display of the window that prompts users to move their Documents, Pictures, and Desktop folders to OneDrive.

.DESCRIPTION
If you disable this setting and provide your tenant ID, the window that prompts users to protect their important folders won't appear.

.EXAMPLE
Disable-ODKFMOptInWizard -TenantId AAAA-BBBB-CCCC-DDDD

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMOptInWithWizard
#>

function Disable-ODKFMOptInWizard {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )

    Test-ODKey($kfmoptinwizard)

    New-ItemProperty -Path $kfmoptinwizard -Name 'KFMOptInWithWizard' -Value $TenantId -PropertyType String -Force
}
#endregion

#region EnterpriseRing

<#
.SYNOPSIS
This setting lets you specify the Enterprise ring for users in your organization. 

.DESCRIPTION
This setting lets you specify the Enterprise ring for users in your organization. We release OneDrive sync client (OneDrive.exe) updates to the public through three rings— first to Insiders, then Production, and finally Enterprise.

Selecting the Enterprise ring gives you some extra time to prepare for updates, but means users will need to wait to receive the latest improvements. The Enterprise ring also lets you deploy updates from an internal network location on your own schedule.

.EXAMPLE
An example

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableEnterpriseUpdate
#>

function Enable-ODEnterpriseRing {

    Test-ODKey($enterprisering)

    New-ItemProperty -Path $enterprisering -Name 'EnableEnterpriseUpdate' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting lets you disable the Enterprise ring for users in your organization. 

.DESCRIPTION
This setting lets disable the Enterprise ring for users in your organization. Users will not need to wait to receive the latest improvements.

.EXAMPLE
Enable-ODEnterpriseRing

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#EnableEnterpriseUpdate
#>

function Disable-ODEnterpriseRing {

    Test-ODKey($enterprisering)

    New-ItemProperty -Path $enterprisering -Name 'EnableEnterpriseUpdate' -Value 0 -PropertyType Dword -Force
}
#endregion

#region DefaultLocation

<#
.SYNOPSIS
This setting lets you set a specific path as the default location of the OneDrive folder on users' computers. By default, the path is under %userprofile%.

.DESCRIPTION
This setting lets you set a specific path as the default location of the OneDrive folder on users' computers. By default, the path is under %userprofile%.

If you enable this setting, the default location of the OneDrive - {organization name} folder will be the path that you specify. Click Show in the Options box to specify your tenant ID and the path.

.EXAMPLE
Set-ODDefaultLocation -TenantId 'AAAA-BBBB-CCCC-DDDD' -RootPath 'E:\OneDrive\'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DefaultRootDir
#>
function Set-ODDefaultLocation {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId,
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter the desired path for the root directory")]
        [string]$RootPath
    )
    
    Test-ODKey($defaultlocation)

    New-ItemProperty -Path $defaultlocation -Name $TenantId -Value $RootPath -PropertyType String -Force
}

<#
.SYNOPSIS
This setting removes a default location for OneDrive from the registry.

.DESCRIPTION
This setting removes a default location for OneDrive from the registry. This will not revert the location of a previously set default if OneDrive was previously redirected.

.EXAMPLE
Remove-ODDefaultLocation -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DefaultRootDir
#>
function Remove-ODDefaultLocation {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($defaultlocation)

    Remove-ItemProperty -Path $defaultlocation -Name $TenantId -Force
}

#endregion

#region MaxSizeAutoDownload

<#
.SYNOPSIS
This setting is used in conjunction with Silently sign in users to the OneDrive sync client with their Windows credentials on devices that don't have OneDrive Files On-Demand enabled.

.DESCRIPTION
This setting is used in conjunction with Silently sign in users to the OneDrive sync client with their Windows credentials on devices that don't have OneDrive Files On-Demand enabled. Any user who has a OneDrive that's larger than the specified threshold (in MB) will be prompted to choose the folders they want to sync before the OneDrive sync client (OneDrive.exe) downloads the files.

In the Options box, click Show to enter the tenant ID and the maximum size in MB (from 0 to 4294967295). The default value is 500.

.EXAMPLE
Set-ODMaxSizeAutoDownload -TenantId 'AAAA-BBBB-CCCC-DDDD' -MaxSize 1500

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DiskSpaceCheckThresholdMB
#>
function Set-ODMaxSizeAutoDownload {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId,
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter the maximum size to automatically download. Valid values are between 0 and 4294967295. The default is 500.")]
        [long]$MaxSize
    )
    
    Test-ODKey($maxsizeautodownload)

    New-ItemProperty -Path $maxsizeautodownload -Name $TenantId -Value $MaxSize -PropertyType Dword -Force
}

<#
.SYNOPSIS
This setting removes the maximum size files are automatically downloaded for the specified tenant.

.DESCRIPTION
This setting removes the maximum size files are automatically downloaded for the specified tenant.

.EXAMPLE
Remove-ODMaxSizeAutoDownload -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#DiskSpaceCheckThresholdMB
#>
function Remove-ODMaxSizeAutoDownload {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )
    
    Test-ODKey($maxsizeautodownload)

    Remove-ItemProperty -Path $maxsizeautodownload -Name $TenantId -Force
}

#endregion

#region ClientRing

<#
.SYNOPSIS
This setting lets you specify the ring for users in your organization. When you enable this setting and select a ring, users won't be able to change it.

.DESCRIPTION
We release OneDrive sync client (OneDrive.exe) updates to the public through three rings- first to Insiders, then Production, and finally Enterprise. This setting lets you specify the ring for users in your organization. When you enable this setting and select a ring, users won't be able to change it.

Insiders ring users will receive builds that let them preview new features coming to OneDrive.

Production ring users will get the latest features as they become available. This ring is the default.

Enterprise ring users get new features, bug fixes, and performance improvements last. This ring lets you deploy updates from an internal network location and control the timing of the deployment (within a 60-day window).

If you disable or do not configure this setting, users can join the Windows Insider program or the Office Insider program to get updates on the Insiders ring.

Set the value 4 for Insider, 5 for Production, or 0 for Enterprise.

.EXAMPLE
Set-ODClientRing -Ring 4

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#GPOSetUpdateRing
#>

function Set-ODClientRing {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter the Ring ID. Valid values are 0 (Enterprise), 4 (Insider), and 5 (Production).")]
        [int]$Ring
    )

    Test-ODKey($clientring)

    New-ItemProperty -Path $clientring -Name 'GPOSetUpdateRing' -Value $Ring -PropertyType String -Force
}

<#
.SYNOPSIS
This setting removes the previously specified ring.

.DESCRIPTION
This setting removes the previously specified ring.

.EXAMPLE
Remove-ODEnterpriseRing

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#GPOSetUpdateRing
#>

function Remove-ODEnterpriseRing {

    Remove-ItemProperty -Path $clientring -Name 'GPOSetUpdateRing' -Force
}

#endregion

#region KFMSilentOptIn

<#
.SYNOPSIS
Use this setting to redirect your users' Documents, Pictures, and Desktop folders to OneDrive without any user interaction.

.DESCRIPTION
Use this setting to redirect your users' Documents, Pictures, and Desktop folders to OneDrive without any user interaction. This setting is available in the OneDrive sync client build 18.111.0603.0004 or later. Before sync client build 18.171.0823.0001, this setting redirected only empty known folders to OneDrive. Now, it redirects known folders that contain content and moves the content to OneDrive.

If you enable this setting and provide your tenant ID, you can choose whether to display a notification to users after their folders have been redirected.

If you disable or do not configure this setting, your users' known folders will not be silently redirected to OneDrive.

.EXAMPLE
Enable-ODKFMSilentOptIn -TenantId 'AAAA-BBBB-CCCC-DDDD' -Notification 1

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMOptInNoWizard
#>

function Enable-ODKFMSilentOptIn {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId,
        [Parameter(Mandatory=$true,
        HelpMessage = "Set a value of 1 to enable notification of successful redirection. Set to 0 to disable notification.")]
        [int]$Notification
    )

    Test-ODKey($kfmsilentoptin)

    New-ItemProperty -Path $kfmsilentoptin -Name 'KFMSilentOptIn' -Value $TenantId -PropertyType String -Force
    New-ItemProperty -Path $kfmsilentoptin -Name 'KFMSilentOptInWithNotification' -Value $Notification -PropertyType String -Force
}

<#
.SYNOPSIS
This setting removes known folder move silent opt-in.

.DESCRIPTION
This setting removes known folder move silent opt-in for the given tenant id.

.EXAMPLE
Disable-ODKFMSilentOptIn -TenantId 'AAAA-BBBB-CCCC-DDDD'

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#KFMOptInNoWizard
#>

function Disable-ODKFMSilentOptIn {
    param (
        [Parameter(Mandatory=$true,
        HelpMessage = "Enter a Tenant ID in the format of AAAA-BBBB-CCCC-DDDD")]
        [string]$TenantId
    )

    Test-ODKey($kfmsilentoptin)

    New-ItemProperty -Path $kfmsilentoptin -Name 'KFMSilentOptIn' -Value $TenantId -PropertyType String -Force
}
#endregion

#region SilentSignIn

<#
.SYNOPSIS
If you enable this setting, users who are signed in on a PC that's joined to Azure AD can set up the sync client without entering their account credentials.

.DESCRIPTION
If you enable this setting, users who are signed in on a PC that's joined to Azure AD can set up the sync client without entering their account credentials. Users will still be shown OneDrive Setup so they can select folders to sync and change the location of their OneDrive folder. If a user is using the previous OneDrive for Business sync client (Groove.exe), the new sync client will attempt to take over syncing the user's OneDrive from the previous client and preserve the user's sync settings. This setting is frequently used together with Set the maximum size of a user's OneDrive that can download automatically on PCs that don't have Files On-Demand, and with Set the default location for the OneDrive folder.

.EXAMPLE
Enable-ODSilentSignIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#SilentAccountConfig
#>

function Enable-ODSilentSignIn {

    Test-ODKey($silentsignin)

    New-ItemProperty -Path $silentsignin -Name 'SilentAccountConfig' -Value 1 -PropertyType Dword -Force
}

<#
.SYNOPSIS
If you disable this setting, users who are signed in on a PC that's joined to Azure AD will be prompted for credentials when signing into OneDrive.

.DESCRIPTION
If you disable this setting, users who are signed in on a PC that's joined to Azure AD will be prompted for credentials when signing into OneDrive.

.EXAMPLE
Disable-ODSilentSignIn

.NOTES
SEE ALSO: https://docs.microsoft.com/en-us/onedrive/use-group-policy#SilentAccountConfig
#>

function Disable-ODSilentSignIn {

    Test-ODKey($silentsignin)

    New-ItemProperty -Path $silentsignin -Name 'SilentAccountConfig' -Value 0 -PropertyType Dword -Force
}
#endregion

#region HelperFunctions
function Test-ODKey {
    param (
        [parameter(Mandatory=$true)]
        [string]$key
    )
    
    if(-Not (Test-Path($key))) {
        New-Item $key -Force
    }
}

#endregion