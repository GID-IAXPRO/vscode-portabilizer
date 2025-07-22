# VS Code Portabilizer for Windows

A PowerShell tool to automate creating and upgrading VS Code portable installations on Windows systems.

## Features

- **Create portable VS Code**: Downloads the latest VS Code ZIP and migrates your existing configuration
- **Upgrade portable installations**: Updates VS Code while preserving your data and extensions
- **Windows-specific handling**: Follows Windows portable mode requirements exactly
- **Data migration**: Copies your user settings and extensions from the system installation
- **PowerShell native**: Uses modern PowerShell features for reliable operation

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or later (included with Windows 10/11)
- Internet connection for downloading VS Code
- Sufficient disk space for VS Code and your extensions

## Installation

1. **Download the scripts** to a folder of your choice

2. **Set PowerShell execution policy** (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
   This allows local scripts to run while still requiring remote scripts to be signed.

   **Alternative**: Use the batch wrapper (`vscode-portabilizer-cli.bat`) which bypasses execution policy restrictions.

3. **Optional**: Add the script directory to your PATH for easier access

## Usage

### Using the main script directly

#### Create a new portable VS Code installation

```powershell
.\vscode-portabilizer.ps1 create C:\Tools\VSCode-Portable
```

This will:
- Download the latest VS Code ZIP for Windows x64
- Extract it to the specified destination
- Create a `data` folder with your migrated settings and extensions
- Set up the portable directory structure according to VS Code documentation

Example:
```powershell
.\vscode-portabilizer.ps1 create "C:\MyApps\VSCode-Portable"
```

#### Upgrade an existing portable installation

```powershell
.\vscode-portabilizer.ps1 upgrade C:\Tools\VSCode-Portable
```

This will:
- Backup your current `data` folder
- Download the latest VS Code
- Replace the VS Code binaries while preserving your data
- Restore your settings and extensions

Example:
```powershell
.\vscode-portabilizer.ps1 upgrade "C:\MyApps\VSCode-Portable"
```

#### Get help

```powershell
.\vscode-portabilizer.ps1 help
```

### Using the interactive CLI

For a more user-friendly experience, use the interactive CLI:

```powershell
.\vscode-portabilizer-cli.ps1
```

**Alternative**: If you have PowerShell execution policy restrictions, you can use the batch wrapper:

```cmd
vscode-portabilizer-cli.bat
```

The CLI will present you with a menu to:
1. Create a new portable VS Code installation
2. Upgrade an existing portable installation  
3. Show help information
4. Exit

The CLI will:
- Check PowerShell execution policy
- Prompt you for the required paths with validation
- Guide you through the process step by step
- Handle errors gracefully with clear messages

## What gets migrated?

When creating a new portable installation, the tool migrates:

- **User settings**: From `%APPDATA%\Code` → `data\user-data`
- **Extensions**: From `%USERPROFILE%\.vscode\extensions` → `data\extensions`
- **Temporary files**: Creates `data\tmp` for portable temp directory

## Directory Structure

After creation, your portable VS Code will look like this:

```
VSCode-Portable/
├── Code.exe                 # Main VS Code executable
├── bin/                     # VS Code binaries
├── resources/               # VS Code resources
├── data/                    # Portable data folder
│   ├── user-data/          # Your settings, keybindings, etc.
│   ├── extensions/         # Your installed extensions
│   └── tmp/                # Temporary files (optional)
└── ... (other VS Code files)
```

## PowerShell Execution Policy

If you encounter execution policy errors, you have several options:

1. **Recommended**: Set policy for current user only:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Alternative**: Bypass policy for a single execution:
   ```powershell
   PowerShell.exe -ExecutionPolicy Bypass -File .\vscode-portabilizer.ps1 create C:\Tools\VSCode-Portable
   ```

3. **Temporary**: Unblock the downloaded files:
   ```powershell
   Unblock-File .\vscode-portabilizer.ps1
   Unblock-File .\vscode-portabilizer-cli.ps1
   ```

## Troubleshooting

### Common Issues

1. **"Execution policy" errors**
   - Follow the PowerShell Execution Policy section above

2. **"Access denied" errors**
   - Make sure you have write permissions to the destination folder
   - Try running PowerShell as Administrator if needed

3. **Download failures**
   - Check your internet connection
   - Verify that your firewall/antivirus isn't blocking the download
   - Some corporate networks may block direct downloads

4. **ZIP extraction errors**
   - Ensure you have enough disk space
   - Check that the destination folder isn't in use by another application

### Getting Help

1. Run the help command:
   ```powershell
   .\vscode-portabilizer.ps1 help
   ```

2. Check the VS Code portable mode documentation:
   https://code.visualstudio.com/docs/editor/portable

3. Verify your PowerShell version:
   ```powershell
   $PSVersionTable.PSVersion
   ```

## Comparison with Linux Version

The Windows version follows the same philosophy as the Linux version:

| Feature | Linux | Windows |
|---------|-------|---------|
| Core Script | `vscode-portabilizer` (bash) | `vscode-portabilizer.ps1` (PowerShell) |
| Interactive CLI | `vscode-portabilizer-cli.sh` (bash) | `vscode-portabilizer-cli.ps1` (PowerShell) |
| Download Source | TAR.GZ archive | ZIP archive |
| User Data Source | `~/.config/Code` | `%APPDATA%\Code` |
| Extensions Source | `~/.vscode/extensions` | `%USERPROFILE%\.vscode\extensions` |
| Special Requirements | Sandbox permissions | Execution policy |

## Security Notes

- The scripts download VS Code directly from Microsoft's official servers
- No external dependencies are installed
- Your existing VS Code installation is not modified
- All operations are performed with your current user privileges
- The PowerShell execution policy change is scoped to the current user only

## Limitations

- Only works with the VS Code ZIP distribution (not the installer versions)
- Automatic updates are not supported in portable mode
- Some VS Code features may require additional configuration in portable mode
- Extensions that require system-level installation may not work properly

## Contributing

When contributing to the Windows implementation:

1. Follow PowerShell best practices and coding standards
2. Test on both Windows 10 and Windows 11
3. Ensure compatibility with PowerShell 5.1 and later
4. Maintain feature parity with the Linux version where possible
5. Include comprehensive error handling and user feedback
