@echo off
REM VS Code Portabilizer CLI - Batch wrapper for PowerShell script
REM This batch file calls the PowerShell CLI with appropriate execution policy

setlocal

REM Get the directory where this batch file is located
set SCRIPT_DIR=%~dp0

REM Check if PowerShell is available
powershell -Command "Get-Host" >nul 2>&1
if errorlevel 1 (
    echo Error: PowerShell is not available or not in PATH
    echo Please ensure PowerShell 5.1 or later is installed
    pause
    exit /b 1
)

REM Run the PowerShell CLI script with execution policy bypass
echo Starting VS Code Portabilizer...
echo.
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%vscode-portabilizer-cli.ps1"

REM Check if the PowerShell script executed successfully
if errorlevel 1 (
    echo.
    echo An error occurred while running the PowerShell script.
    echo You may need to check your PowerShell execution policy.
    echo.
    echo To set the execution policy, run this command in PowerShell as Administrator:
    echo Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    echo.
    pause
)

endlocal
