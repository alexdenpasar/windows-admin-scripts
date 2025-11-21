# Parameters
$LogRetentionDays = 7
$CurrentServer = $env:COMPUTERNAME
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = "$ScriptPath\ExchangeCleanup_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"

#Loggining
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $LogEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [$Level] $Message"
    Write-Host $LogEntry
    Add-Content -Path $LogFile -Value $LogEntry
}

Write-Log "=== Starting Exchange Log Cleanup on Server $CurrentServer ==="

# We get a list of databases located on the current server
$Databases = Get-MailboxDatabase -Server $CurrentServer | Select-Object -ExpandProperty Name

if ($Databases.Count -eq 0) {
    Write-Log "There are no Exchange databases on server $CurrentServer." "WARNING"
    exit
}

Write-Log "Databases found on server $CurrentServer : $($Databases -join ', ')"

foreach ($DB in $Databases) {
    Write-Log "`nProcessing database: $DB"

    # We get the path to the database file
    $DBPath = (Get-MailboxDatabase -Identity $DB).EdbFilePath
    $LogPath = (Get-MailboxDatabase -Identity $DB).LogFolderPath

    if (-not (Test-Path $DBPath)) {
        Write-Log "Database file not found: $DBPath. Skipping..." "WARNING"
        continue
    }

    # Dismount the database
    Write-Log "Dismount the database: $DB"
    Dismount-Database -Identity $DB -Confirm:$false
    Start-Sleep -Seconds 5

    # Check database status
    $DBStatus = (Get-MailboxDatabaseCopyStatus -Identity $DB).Status
    if ($DBStatus -ne "Dismounted") {
        Write-Log "Error! Failed to disable $DB. Current status: $DBStatus" "ERROR"
        continue
    }

    Write-Log "$DB successfully disabled. Checking status..."

    # Checking the status of the database via eseutil
    $EseutilOutput = eseutil /mh $DBPath 2>&1
    $CleanShutdown = $EseutilOutput -match "State:\s+Clean Shutdown"

    if (-not $CleanShutdown) {
        Write-Log "$DB is in Dirty Shutdown state! Do not delete logs!" "ERROR"
    } else {
        Write-Log "$DB is in Clean Shutdown state. Removing old logs..."

        if (Test-Path $LogPath) {
            $LogCount = (Get-ChildItem -Path $LogPath -Filter "*.log" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$LogRetentionDays) }).Count
            Get-ChildItem -Path $LogPath -Filter "*.log" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$LogRetentionDays) } | Remove-Item -Force
            Write-Log "Removed $LogCount logs in $LogPath"
        } else {
            Write-Log "Log folder not found: $LogPath" "WARNING"
        }
    }

    # Mount the database
    Write-Log "Start the database: $DB"
    Mount-Database -Identity $DB
    Start-Sleep -Seconds 5

    # Check status after mounting
    $DBStatus = (Get-MailboxDatabaseCopyStatus -Identity $DB).Status
    if ($DBStatus -eq "Mounted") {
        Write-Log "The $DB database has been started successfully."
    } else {
        Write-Log "Error! $DB failed to start. Verification required!" "ERROR"
    }
}

Write-Log "=== Log cleaning completed ==="
