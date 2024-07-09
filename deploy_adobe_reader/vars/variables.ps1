# Determine the parent directory of the script directory
$parentDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Determine the current user's username
$currentUser = $env:USERNAME

# Pad naar het installatie bestand van de applicatie.
$sourceFolder = "$parentDir\source\Adobe Reader"

# Locatie waar de installatie tijdelijk naar toe wordt gekopieerd op de server zodat het vanaf die locatie gestart kan worden,
# deze locatie wordt verwijderd op het einde van het script.
$destinationFolder = "C:\Users\$currentUser\temp"

# Lijst van servers waar het script een connectie mee maakt en de software installeert.
$computers = Get-Content "$parentDir\servers.txt"
