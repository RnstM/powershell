<#
        ____   _   __ _____ ______
       / __ \ / | / // ___//_  __/
      / /_/ //  |/ / \__ \  / /   
     / _, _// /|  / ___/ / / /    
    /_/ |_|/_/ |_/ /____/ /_/                                   
                               
    Script Name:    check_settings.ps1
    Created By:     RNST
    Created Date:   2024-07-09
    Description:    This script echoes the variables.
    Version:        1.0
    Notes:          Initial version.
#>


# Determine the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Load variables from external file in the same directory as the script
. "$scriptDir\vars\variables.ps1"

# Example of how to use the loaded variables
Write-Host "ScriptDir: $scriptDir"
Write-Host "Source: $sourceFolder"
Write-Host "Destination Folder: $destinationFolder"
Write-Host "Computers: $computers"