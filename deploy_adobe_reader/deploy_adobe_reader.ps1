<#
     ____   _   __ _____ ______
    / __ \ / | / // ___//_  __/
   / /_/ //  |/ / \__ \  / /   
  / _, _// /|  / ___/ / / /    
 /_/ |_|/_/ |_/ /____/ /_/                                  

    Github:    https://github.com/RnstM/powershell/tree/main/deploy_adobe_reader
#>

# Determine the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Load variables from external file in the same directory as the script
. "$scriptDir\vars\variables.ps1"

Write-Host " ____   _   __ _____ ______"
Write-Host "/ __ \ / | / // ___//_  __/"
Write-Host "/ /_/ //  |/ / \__ \  / /   "
Write-Host "/ _, _// /|  / ___/ / / /    "
Write-Host "/_/ |_|/_/ |_/ /____/ /_/   "

# Function to log messages with timestamp
function Log-Message {
    param (
        [string]$ComputerName,
        [string]$Message,
        [string]$Status = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$ComputerName] [$timestamp] [$Status] $Message"
}

# Iterate through each remote computer and deploy the software
foreach ($ComputerName in $computers) {
    Log-Message -ComputerName $ComputerName -Message "Creating a new PowerShell session..."
    try {
        $Session = New-PSSession -ComputerName $ComputerName
        Log-Message -ComputerName $ComputerName -Message "PowerShell session created successfully."
        
        Log-Message -ComputerName $ComputerName -Message "Creating destination folder if it doesn't exist..."
        Invoke-Command -Session $Session -ScriptBlock {
            param($destinationFolder)
            if (!(Test-Path $destinationFolder)) {
                New-Item $destinationFolder -ItemType Directory | Out-Null
            }
        } -ArgumentList $destinationFolder
        Log-Message -ComputerName $ComputerName -Message "Destination folder is ready."
        
        Log-Message -ComputerName $ComputerName -Message "Copying the software installation folder..."
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath (Split-Path -Leaf $sourceFolder)
        Copy-Item -Path $sourceFolder -Destination $destinationPath -Recurse -ToSession $Session
        Log-Message -ComputerName $ComputerName -Message "Software installation folder copied successfully."
        
        Log-Message -ComputerName $ComputerName -Message "Running batch script to install registry key and software..."
        $batchFilePath = Join-Path -Path $destinationPath -ChildPath "install_with_regkey.bat"
        Invoke-Command -Session $Session -ScriptBlock {
            param($batchFilePath)
            Start-Process -FilePath $batchFilePath -Wait
        } -ArgumentList $batchFilePath
        Log-Message -ComputerName $ComputerName -Message "Batch script executed successfully."

        Log-Message -ComputerName $ComputerName -Message "Removing the installation folder..."
        Invoke-Command -Session $Session -ScriptBlock {
            param($destinationPath)
            Remove-Item -Path $destinationPath -Recurse -Force
        } -ArgumentList $destinationPath
        Log-Message -ComputerName $ComputerName -Message "Installation folder removed successfully."
        
        # Clean up user's temp folder on the remote server with elevated privileges
        $currentUser = $env:USERNAME
        $userTempFolder = "C:\Users\$currentUser\temp"
        Invoke-Command -Session $Session -ScriptBlock {
            param($userTempFolder)
            Start-Process -FilePath PowerShell.exe -ArgumentList "Remove-Item '$using:userTempFolder' -Recurse -Force" -Verb RunAs
            Write-Host "Attempted to remove $using:userTempFolder."
        } -ArgumentList $userTempFolder
    } catch {
        Log-Message -ComputerName $ComputerName -Message $_.Exception.Message -Status "Error"
    } finally {
        Log-Message -ComputerName $ComputerName -Message "Closing the PowerShell session..."
        Remove-PSSession -Session $Session
        Log-Message -ComputerName $ComputerName -Message "PowerShell session closed."
    }
}