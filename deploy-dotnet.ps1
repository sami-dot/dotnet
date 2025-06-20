param (
    [string]$version
)

# === CONFIGURATION ===
$repoUrl = "http://10.1.96.4:8098/repository/static-repo"
$appName = "SimpleIISApp"
$zipFile = "$appName-$version.zip"
$destinationZip = "C:\deployments\$zipFile"
$extractPath = "C:\inetpub\wwwroot\$appName"
$backupPath = "C:\backups\$appName-$((Get-Date).ToString("yyyyMMdd-HHmmss"))"

# === STEP 1: DOWNLOAD FROM NEXUS ===
Write-Host "📥 Downloading $zipFile from Nexus..."
Invoke-WebRequest -Uri "$repoUrl/$zipFile" -OutFile $destinationZip

# === STEP 2: BACKUP EXISTING SITE (OPTIONAL) ===
if (Test-Path $extractPath) {
    Write-Host "📦 Backing up current version to $backupPath..."
    New-Item -ItemType Directory -Force -Path $backupPath | Out-Null
    Copy-Item -Path "$extractPath\*" -Destination $backupPath -Recurse
    Remove-Item -Recurse -Force "$extractPath\*"
} else {
    New-Item -ItemType Directory -Force -Path $extractPath | Out-Null
}

# === STEP 3: EXTRACT ZIP ===
Write-Host "📂 Extracting to $extractPath..."
Expand-Archive -Path $destinationZip -DestinationPath $extractPath -Force

# === DONE ===
Write-Host "✅ Deployment complete!"
