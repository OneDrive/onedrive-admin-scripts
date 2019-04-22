Known Folder Move is getting popular among our enterprise users and we have heard a lot of feedback with regards to keeping admins aware of what their deployment.  We have created a sample PowerShell script for you to know more about your deployment. 

The script will create a txt file that shows 3 things:
KFM eligibility (for device)
Known Folder status (Number of items, Size capacity, Move status to OneDrive)
KFM GPO state (what GPOs have been set)

This script is set up to be run on a single device but you can modify it for to be run across your workplace.  You will need to provide your TenantID as well as an output path.  With this level of detail you should have a better sense of where your deployment of KFM is and how devices within your workplace are not technically eligible for KFM.  We are continuing to do our best to increase Technical Eligibility and you should continue to see announcements from us enabling KFM for more devices.
