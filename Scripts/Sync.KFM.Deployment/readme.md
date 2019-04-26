# Windows Known Folder Move (KFM) deployment #

## Summary ##

The script will create a txt file that shows 4 things:

- Know Folder Move (KFM) eligibility (for whatever device it was run on)
- Payload details (number of items and size of content within known folders) 
- KFM status (have the known folders been moved to OneDrive)
- KFM GPO state (what GPOs have been set)

The execution of the script can be done via Intune or other management tools that can execute a PowerShell script across Windows 10 devices.  A TenantID as well as an output path is required.  This level of detail will provide a better deployment of KFM.

> More details around the Known Folder Move capability is available from the [official OneDrive documentation](https://docs.microsoft.com/en-us/onedrive/redirect-known-folders).
 
### Applies to ###

- OneDrive

### Prerequisites ###

- As the script reads registry values, you will need to be an administrator in the devices where it's executed.

### Solution ###

Solution | Author(s)
---------|----------
KFM Deployment script | Carter Green (Microsoft)

### Version history ###

Version  | Date | Comments
---------| -----| --------
1.0  | April 24th 2019 | Initial release

### Disclaimer ###

**THIS SCRIPT IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.**

----------

# Execution

Output
~~~
True | Device_is_KFM_GPO_eligible
20 | Total_items_not_in_OneDrive
3480768‬ | Total_size_bytes_not_in_OneDrive

False | Desktop_is_in_OneDrive
5 | Desktop_items
7573 | Desktop_size_bytes

False | Documents_is_in_OneDrive
13 | Documents_items
3472353 | Documents_size_bytes

False | Pictures_is_in_OneDrive 
2 | Pictures_items
842 | Pictures_size_bytes

True | KFM_Opt_In_Wizard_Set
False | KFM_Silent_Opt_In_Set
False | KFM_Silent_With_Notification_Set
False | KFM_Block_Opt_In_Set
False | KFM_Block_Opt_Out_Set 

19.064.0402.0001 | OneDrive Sync client version
~~~

<img src="https://telemetry.sharepointpnp.com/onedrive-admin-scripts/scripts/Sync.KFM.Deployment" /> 
