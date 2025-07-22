# VS Code Portabilizer CLI - Interactive command-line interface for Windows
# This script provides a user-friendly CLI wrapper for the vscode-portabilizer.ps1 tool

param()

$ErrorActionPreference = "Stop"

# Get script directory and portabilizer path
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Portabilizer = Join-Path $ScriptDir "vscode-portabilizer.ps1"

# Clear screen and show header
Clear-Host
Write-Host "VS Code Portabilizer - Interactive CLI (Windows)" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

# Check if the portabilizer exists
if (-not (Test-Path $Portabilizer)) {
    Write-Host "Error: vscode-portabilizer.ps1 not found at: $Portabilizer" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -eq "Restricted") {
    Write-Host "Warning: PowerShell execution policy is set to 'Restricted'." -ForegroundColor Yellow
    Write-Host "You may need to change it to run this script. You can run:" -ForegroundColor Yellow
    Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Do you want to continue anyway? (y/N)"
    if ($continue -notmatch "^[Yy]") {
        exit 1
    }
}

# Function to get and validate folder path
function Get-ValidPath {
    param(
        [string]$Prompt,
        [bool]$MustExist = $false
    )
    
    do {
        $path = Read-Host $Prompt
        if ([string]::IsNullOrWhiteSpace($path)) {
            Write-Host "Error: Path cannot be empty" -ForegroundColor Red
            continue
        }
        
        # Convert to absolute path
        try {
            $path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
        }
        catch {
            Write-Host "Error: Invalid path format" -ForegroundColor Red
            continue
        }
        
        if ($MustExist -and -not (Test-Path $path)) {
            Write-Host "Error: Path does not exist: $path" -ForegroundColor Red
            continue
        }
        
        return $path
    } while ($true)
}

# Show menu
function Show-Menu {
    Write-Host "Available commands:" -ForegroundColor Green
    Write-Host "1. Create a new portable VS Code installation" -ForegroundColor White
    Write-Host "2. Upgrade an existing portable installation" -ForegroundColor White
    Write-Host "3. Show help" -ForegroundColor White
    Write-Host "4. Exit" -ForegroundColor White
    Write-Host ""
}

# Main menu loop
do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-4)"
    Write-Host ""
    
    switch ($choice) {
        "1" {
            Write-Host "Creating a new portable VS Code installation..." -ForegroundColor Green
            Write-Host ""
            $destFolder = Get-ValidPath "Enter destination folder (e.g., C:\Tools\VSCode-Portable)"
            
            if (Test-Path $destFolder) {
                Write-Host "Warning: Destination folder already exists: $destFolder" -ForegroundColor Yellow
                $overwrite = Read-Host "Do you want to continue? This may overwrite existing files (y/N)"
                if ($overwrite -notmatch "^[Yy]") {
                    Write-Host "Operation cancelled." -ForegroundColor Yellow
                    continue
                }
            }
            
            Write-Host ""
            Write-Host "Creating portable VS Code at: $destFolder" -ForegroundColor Cyan
            
            try {
                & $Portabilizer create $destFolder
                Write-Host ""
                Write-Host "Success! Portable VS Code has been created." -ForegroundColor Green
            }
            catch {
                Write-Host ""
                Write-Host "Error occurred during creation: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        
        "2" {
            Write-Host "Upgrading an existing portable VS Code installation..." -ForegroundColor Green
            Write-Host ""
            $portableFolder = Get-ValidPath "Enter existing portable folder path" -MustExist $true
            
            # Verify it's a valid portable installation
            $dataFolder = Join-Path $portableFolder "data"
            if (-not (Test-Path $dataFolder)) {
                Write-Host "Error: This doesn't appear to be a valid portable VS Code installation." -ForegroundColor Red
                Write-Host "No 'data' folder found in: $portableFolder" -ForegroundColor Red
                continue
            }
            
            Write-Host ""
            Write-Host "Upgrading portable VS Code at: $portableFolder" -ForegroundColor Cyan
            
            try {
                & $Portabilizer upgrade $portableFolder
                Write-Host ""
                Write-Host "Success! Portable VS Code has been upgraded." -ForegroundColor Green
            }
            catch {
                Write-Host ""
                Write-Host "Error occurred during upgrade: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        
        "3" {
            & $Portabilizer help
        }
        
        "4" {
            Write-Host "Goodbye!" -ForegroundColor Green
            exit 0
        }
        
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 4." -ForegroundColor Red
        }
    }
    
    if ($choice -in @("1", "2", "3")) {
        Write-Host ""
        Write-Host "Press Enter to return to the main menu..." -ForegroundColor Gray
        Read-Host
        Clear-Host
        Write-Host "VS Code Portabilizer - Interactive CLI (Windows)" -ForegroundColor Cyan
        Write-Host "=================================================" -ForegroundColor Cyan
        Write-Host ""
    }
    
} while ($choice -ne "4")
