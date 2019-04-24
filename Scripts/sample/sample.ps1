<#
.Synopsis
This script will do magical things when executed

Goals
    ·   Ensure that you can automate cool stuff


.EXAMPLE

            -------------------------- EXAMPLE 01 --------------------------
            Get-MagicalThingsInQueue

#>

function Get-MagicalThingsInQueue {
    
    #Commenting the code inline
    $today = get-date

    #Here's' the actual execution
    Write-Host ("Today is {0} and you have {1} magical things in queue." –f $today, (get-random))
}


