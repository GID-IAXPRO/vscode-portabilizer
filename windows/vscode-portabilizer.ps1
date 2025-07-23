# vscode-portabilizer.ps1 - Tool to create and upgrade VS Code portable installations on Windows
# Based on: https://code.visualstudio.com/docs/editor/portable

param(
    [Parameter(Position=0)]
    [ValidateSet('create', 'upgrade', 'help', '--help', '-h')]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$Path,
    
    [switch]$NoMigrate
)

$ErrorActionPreference = "Stop"
$Version = "1.0.0"
$VSCodeDownloadUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"
$UserDataDir = "$env:APPDATA\Code"
$ExtensionsDir = "$env:USERPROFILE\.vscode\extensions"

# ANSI color codes for PowerShell
$Colors = @{
    Red = "`e[31m"
    Green = "`e[32m"
    Yellow = "`e[33m"
    Blue = "`e[34m"
    Reset = "`e[0m"
}

# Print colored output functions
function Write-Info {
    param([string]$Message)
    Write-Host "$($Colors.Blue)[INFO]$($Colors.Reset) $Message"
}

function Write-Success {
    param([string]$Message)
    Write-Host "$($Colors.Green)[SUCCESS]$($Colors.Reset) $Message"
}

function Write-Warning {
    param([string]$Message)
    Write-Host "$($Colors.Yellow)[WARNING]$($Colors.Reset) $Message"
}

function Write-Error {
    param([string]$Message)
    Write-Host "$($Colors.Red)[ERROR]$($Colors.Reset) $Message"
}

# Show usage information
function Show-Usage {
    @"
vscode-portabilizer v$Version
Tool to create and upgrade VS Code portable installations on Windows

Usage:
    .\vscode-portabilizer.ps1 create [-NoMigrate] <destination_folder>  - Create a new portable VS Code installation
    .\vscode-portabilizer.ps1 upgrade <portable_folder>                 - Upgrade an existing portable VS Code installation
    .\vscode-portabilizer.ps1 help                                     - Show this help message

Examples:
    .\vscode-portabilizer.ps1 create C:\Tools\VSCode-Portable           # Create with migration (if system installation exists)
    .\vscode-portabilizer.ps1 create -NoMigrate C:\Tools\VSCode-Fresh   # Create without migration (fresh installation)
    .\vscode-portabilizer.ps1 upgrade C:\Tools\VSCode-Portable

Requirements:
    - Windows 10 or Windows 11
    - PowerShell 5.1 or later
    - Internet connection for downloading VS Code
    - Administrator privileges may be required for some operations

Notes:
    - The create command migrates your current VS Code configuration by default if found
    - Use -NoMigrate to skip migration and create a fresh installation
    - If no system VS Code installation is found, a fresh installation is created automatically
    - The upgrade command preserves your data folder while updating VS Code
    - Only works with VS Code ZIP archives (portable mode)
"@
}

# Check PowerShell version and requirements
function Test-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Error "PowerShell 5.1 or later is required. Current version: $($PSVersionTable.PSVersion)"
        exit 1
    }
    
    Write-Success "Prerequisites check passed"
}

# Download and extract VS Code directly to destination
function Get-VSCodeAndExtract {
    param(
        [string]$Destination
    )
    
    Write-Info "Downloading VS Code from: $VSCodeDownloadUrl"
    
    # Download VS Code
    $tempArchive = [System.IO.Path]::GetTempFileName() + ".zip"
    try {
        # Disable progress for much faster downloads
        $ProgressPreference = 'SilentlyContinue'
        
        # Download without progress indication for better performance
        Invoke-WebRequest -Uri $VSCodeDownloadUrl -OutFile $tempArchive -UseBasicParsing
        
        Write-Success "Download completed"
        Write-Info "Extracting VS Code directly to: $Destination"
        
        # Extract directly to destination using .NET
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempArchive, $Destination)
        
        Write-Success "Extraction completed"
    }
    catch {
        Write-Error "Failed to download or extract VS Code: $($_.Exception.Message)"
        throw
    }
    finally {
        # Clean up temporary archive
        if (Test-Path $tempArchive) {
            Remove-Item -Path $tempArchive -Force
        }
    }
}

# Extract VS Code ZIP archive
function Expand-VSCode {
    param(
        [string]$ArchivePath,
        [string]$DestinationPath
    )
    
    Write-Info "Extracting VS Code to: $DestinationPath"
    
    try {
        # Use .NET System.IO.Compression.ZipFile for better performance
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ArchivePath, $DestinationPath)
        
        Write-Success "Extraction completed"
    }
    catch {
        Write-Error "Failed to extract VS Code archive: $($_.Exception.Message)"
        throw
    }
}

# Copy user data and extensions to portable data folder
function Copy-UserData {
    param(
        [string]$DataDir
    )
    
    Write-Info "Migrating user data and extensions..."
    
    # Create data directory structure
    New-Item -Path $DataDir -ItemType Directory -Force | Out-Null
    
    # Copy user data
    $userDataTarget = Join-Path $DataDir "user-data"
    if (Test-Path $UserDataDir) {
        Write-Info "Copying user data from: $UserDataDir"
        Copy-Item -Path $UserDataDir -Destination $userDataTarget -Recurse -Force
    } else {
        Write-Warning "User data directory not found: $UserDataDir"
        Write-Info "Creating empty user-data directory"
        New-Item -Path $userDataTarget -ItemType Directory -Force | Out-Null
    }
    
    # Copy extensions
    $extensionsTarget = Join-Path $DataDir "extensions"
    if (Test-Path $ExtensionsDir) {
        Write-Info "Copying extensions from: $ExtensionsDir"
        Copy-Item -Path $ExtensionsDir -Destination $extensionsTarget -Recurse -Force
    } else {
        Write-Warning "Extensions directory not found: $ExtensionsDir"
        Write-Info "Creating empty extensions directory"
        New-Item -Path $extensionsTarget -ItemType Directory -Force | Out-Null
    }
    
    # Create tmp directory for portable tmp
    $tmpDir = Join-Path $DataDir "tmp"
    New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null
    Write-Info "Created tmp directory for portable mode"
}

# Check if VS Code system installation exists
function Test-SystemInstallation {
    $hasData = $false
    $hasExtensions = $false
    
    if ((Test-Path $UserDataDir) -and (Get-ChildItem -Path $UserDataDir -ErrorAction SilentlyContinue)) {
        $hasData = $true
    }
    
    if ((Test-Path $ExtensionsDir) -and (Get-ChildItem -Path $ExtensionsDir -ErrorAction SilentlyContinue)) {
        $hasExtensions = $true
    }
    
    return ($hasData -or $hasExtensions)
}

# Create empty data directories for fresh portable installation
function New-EmptyPortableData {
    param(
        [string]$DataDir
    )
    
    Write-Info "Creating fresh portable data structure..."
    
    # Create data directory structure
    New-Item -Path $DataDir -ItemType Directory -Force | Out-Null
    
    # Create empty user-data directory
    $userDataTarget = Join-Path $DataDir "user-data"
    Write-Info "Creating empty user-data directory"
    New-Item -Path $userDataTarget -ItemType Directory -Force | Out-Null
    
    # Create empty extensions directory
    $extensionsTarget = Join-Path $DataDir "extensions"
    Write-Info "Creating empty extensions directory"
    New-Item -Path $extensionsTarget -ItemType Directory -Force | Out-Null
    
    # Create tmp directory for portable tmp
    $tmpDir = Join-Path $DataDir "tmp"
    New-Item -Path $tmpDir -ItemType Directory -Force | Out-Null
    Write-Info "Created tmp directory for portable mode"
}

# Install a fresh portable VS Code installation (no migration)
function Install-PortableVSCode {
    param(
        [string]$Destination
    )
    
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        Write-Error "Destination folder not specified"
        Show-Usage
        exit 1
    }
    
    # Convert to absolute path
    $Destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
    
    # Check if destination exists
    if (Test-Path $Destination) {
        Write-Error "Destination already exists: $Destination"
        exit 1
    }
    
    # Create destination directory
    New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    Write-Info "Created destination directory: $Destination"
    
    try {
        # Download and extract directly to destination
        Get-VSCodeAndExtract -Destination $Destination
        
        # Create empty data directory structure
        $dataDir = Join-Path $Destination "data"
        New-EmptyPortableData -DataDir $dataDir
        
        Write-Success "Fresh portable VS Code installed successfully at: $Destination"
        Write-Info "You can now run VS Code with: $Destination\Code.exe"
    }
    catch {
        # Clean up on failure
        if (Test-Path $Destination) {
            Remove-Item -Path $Destination -Recurse -Force
        }
        throw
    }
}

# Create a new portable VS Code installation
function New-PortableVSCode {
    param(
        [string]$Destination,
        [bool]$NoMigrate = $false
    )
    
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        Write-Error "Destination folder not specified"
        Show-Usage
        exit 1
    }
    
    # Convert to absolute path
    $Destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Destination)
    
    # Check if destination exists
    if (Test-Path $Destination) {
        Write-Error "Destination already exists: $Destination"
        exit 1
    }
    
    # Create destination directory
    New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    Write-Info "Created destination directory: $Destination"
    
    try {
        # Download and extract directly to destination
        Get-VSCodeAndExtract -Destination $Destination
        
        # Create data directory
        $dataDir = Join-Path $Destination "data"
        
        # Decide whether to migrate or create fresh
        if ($NoMigrate) {
            Write-Info "Skipping migration due to -NoMigrate flag"
            New-EmptyPortableData -DataDir $dataDir
            Write-Success "Fresh portable VS Code created successfully at: $Destination"
        } else {
            if (Test-SystemInstallation) {
                Write-Info "System VS Code installation found, migrating data..."
                Copy-UserData -DataDir $dataDir
                Write-Success "Portable VS Code created successfully at: $Destination"
                Write-Info "Your existing settings and extensions have been migrated"
            } else {
                Write-Warning "No VS Code system installation found"
                Write-Info "Creating fresh portable installation..."
                New-EmptyPortableData -DataDir $dataDir
                Write-Success "Fresh portable VS Code created successfully at: $Destination"
                Write-Info "You can configure VS Code from scratch"
            }
        }
        
        Write-Info "You can now run VS Code with: $Destination\Code.exe"
    }
    catch {
        # Clean up on failure
        if (Test-Path $Destination) {
            Remove-Item -Path $Destination -Recurse -Force
        }
        throw
    }
}

# Upgrade an existing portable VS Code installation
function Update-PortableVSCode {
    param(
        [string]$PortableFolder
    )
    
    if ([string]::IsNullOrWhiteSpace($PortableFolder)) {
        Write-Error "Portable folder not specified"
        Show-Usage
        exit 1
    }
    
    # Convert to absolute path
    $PortableFolder = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PortableFolder)
    
    if (-not (Test-Path $PortableFolder)) {
        Write-Error "Portable folder does not exist: $PortableFolder"
        exit 1
    }
    
    $dataFolder = Join-Path $PortableFolder "data"
    if (-not (Test-Path $dataFolder)) {
        Write-Error "Not a valid portable VS Code installation (data folder not found): $PortableFolder"
        exit 1
    }
    
    # Backup data directory
    $backupDir = Join-Path ([System.IO.Path]::GetTempPath()) ("vscode-backup-" + [System.Guid]::NewGuid().ToString())
    Write-Info "Backing up data directory to: $backupDir"
    Copy-Item -Path $dataFolder -Destination $backupDir -Recurse -Force
    
    try {
        # Remove old VS Code files (but keep data)
        Write-Info "Removing old VS Code files..."
        Get-ChildItem -Path $PortableFolder | Where-Object { $_.Name -ne "data" } | Remove-Item -Recurse -Force
        
        # Download and extract new VS Code directly to portable folder
        Get-VSCodeAndExtract -Destination $PortableFolder
        
        # Restore data directory
        Write-Info "Restoring data directory..."
        if (Test-Path $dataFolder) {
            Remove-Item -Path $dataFolder -Recurse -Force
        }
        Move-Item -Path $backupDir -Destination $dataFolder
        
        Write-Success "Portable VS Code upgraded successfully at: $PortableFolder"
        Write-Info "You can now run the updated VS Code with: $PortableFolder\Code.exe"
    }
    catch {
        # Restore backup if something went wrong
        Write-Warning "Upgrade failed, restoring backup..."
        if (Test-Path $backupDir) {
            if (Test-Path $dataFolder) {
                Remove-Item -Path $dataFolder -Recurse -Force
            }
            Move-Item -Path $backupDir -Destination $dataFolder
        }
        throw
    }
    finally {
        # Clean up backup if it still exists
        if (Test-Path $backupDir) {
            Remove-Item -Path $backupDir -Recurse -Force
        }
    }
}

# Main execution logic
function Main {
    Test-Prerequisites
    
    switch ($Command.ToLower()) {
        "create" {
            New-PortableVSCode -Destination $Path -NoMigrate $NoMigrate
        }
        "upgrade" {
            Update-PortableVSCode -PortableFolder $Path
        }
        { $_ -in @("help", "--help", "-h") } {
            Show-Usage
        }
        default {
            if ([string]::IsNullOrWhiteSpace($Command)) {
                Write-Error "No command specified"
            } else {
                Write-Error "Unknown command: $Command"
            }
            Show-Usage
            exit 1
        }
    }
}

# Run main function
Main
