This script remotely installs an application provided from a source location to multiple machines provides in the servers.txt file

Change variables.ps1 according to Source and Destination as wished.

$sourceFolder = "$parentDir\source\[APPLICATION_FOLDER]"

$installationFile = "$parentDir\source\[APPLICATION_FOLDER\setup.exe]"

$destinationFolder = "C:\temp"

$computers = Get-Content "$parentDir\servers.txt"