# Determine the parent directory of the script directory
$parentDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

# Pad naar de folder waar het installatie bestand staat
$sourceFolder = "$parentDir\source\Adobe Reader"

# Pad naar het installatie bestand
$installationFile = "$parentDir\source\Adobe Reader\install_with_regkey.bat"

# Locatie waar de installatie tijdelijk naar toe wordt gekopieerd op de server zodat het vanaf die locatie gestart kan worden,
# deze locatie wordt verwijderd op het einde van het script.
$destinationFolder = "C:\temp"

# Lijst van servers waar het script een connectie mee maakt en de software installeert.
$computers = Get-Content "$parentDir\servers.txt"
