# VS Code Portabilizer

A collection of tools to automate creating and managing VS Code portable installations across different platforms.

## Project Structure

```
vscode-portabilizer/
├── linux/                      # Linux-specific tools
│   ├── vscode-portabilizer     # Main bash script for Linux
│   └── vscode-portabilizer-cli.sh # Interactive CLI wrapper
├── windows/                     # Windows-specific tools
│   ├── vscode-portabilizer.ps1 # Main PowerShell script for Windows
│   ├── vscode-portabilizer-cli.ps1 # Interactive CLI wrapper
│   └── vscode-portabilizer-cli.bat # Batch wrapper for execution policy bypass
└── README.md                   # This file
```

## Platform Support

Currently supported platforms:

- **Linux** (`./linux/`) - Complete implementation with create and upgrade functionality
- **Windows** (`./windows/`) - Complete implementation with create and upgrade functionality

## Planned Platform Support

Future platform support (not yet implemented):

- **macOS** - Shell scripts for macOS portable installations

## Quick Start

### Linux

1. Navigate to the Linux directory:
   ```bash
   cd linux/
   ```

2. **Option A: Use the interactive CLI (recommended for beginners)**
   ```bash
   ./vscode-portabilizer-cli.sh
   ```

3. **Option B: Use the main script directly**
   
   Create portable VS Code (auto-migrate if system installation exists):
   ```bash
   ./vscode-portabilizer create /path/to/destination
   ```

   Create fresh portable VS Code (no migration):
   ```bash
   ./vscode-portabilizer create --no-migrate /path/to/destination
   ```

   Or upgrade an existing portable installation:
   ```bash
   ./vscode-portabilizer upgrade /path/to/existing/portable
   ```

### Windows

1. Navigate to the Windows directory:
   ```powershell
   cd windows\
   ```

2. **Option A: Use the interactive CLI (recommended for beginners)**
   ```powershell
   .\vscode-portabilizer-cli.ps1
   ```

3. **Option B: Use the main script directly**
   
   Create portable VS Code (auto-migrate if system installation exists):
   ```powershell
   .\vscode-portabilizer.ps1 create C:\Path\To\Destination
   ```

   Create fresh portable VS Code (no migration):
   ```powershell
   .\vscode-portabilizer.ps1 create -NoMigrate C:\Path\To\Destination
   ```

   Or upgrade an existing portable installation:
   ```powershell
   .\vscode-portabilizer.ps1 upgrade C:\Path\To\Existing\Portable
   ```

## Features

- **Automated downloads**: Fetches the latest VS Code releases
- **Smart migration**: Automatically migrates existing VS Code settings and extensions when found
- **Fresh installations**: Create clean portable installations without migration using flags
- **Platform-specific handling**: Follows official portable mode requirements for each OS
- **Upgrade support**: Updates VS Code while preserving your data
- **Error handling**: Comprehensive error checking and user feedback
- **Interactive CLI**: User-friendly interface for easier operation

## Requirements

### Linux
- Linux x64 system
- `curl` or `wget` for downloading
- `tar` for extracting archives
- `sudo` access for setting sandbox permissions

### Windows
- Windows 10 or Windows 11
- PowerShell 5.1 or later (included with Windows 10/11)
- Internet connection for downloading VS Code
- Sufficient disk space for VS Code and extensions

## Installation

### Linux

1. Navigate to the Linux directory and make scripts executable:
   ```bash
   cd linux/
   chmod +x vscode-portabilizer
   chmod +x vscode-portabilizer-cli.sh
   ```

2. Optionally, add the main script to your PATH:
   ```bash
   sudo cp vscode-portabilizer /usr/local/bin/
   ```

### Windows

1. Download the scripts to a folder of your choice

2. Set PowerShell execution policy (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
   
   **Alternative**: Use the batch wrapper (`vscode-portabilizer-cli.bat`) which bypasses execution policy restrictions.

3. Optionally, add the script directory to your PATH for easier access

## What Gets Migrated?

When creating a portable installation with migration, the tool copies:

### Linux
- **User settings**: From `~/.config/Code` → `data/user-data`
- **Extensions**: From `~/.vscode/extensions` → `data/extensions`

### Windows  
- **User settings**: From `%APPDATA%\Code` → `data\user-data`
- **Extensions**: From `%USERPROFILE%\.vscode\extensions` → `data\extensions`

## Directory Structure

After creation, your portable VS Code will have this structure:

### Linux
```
/path/to/portable/
├── code                    # VS Code executable
├── bin/
├── resources/
├── chrome-sandbox          # Sandbox helper (with proper permissions)
├── data/                   # Portable data folder
│   ├── user-data/         # Your VS Code settings
│   ├── extensions/        # Your installed extensions
│   └── tmp/               # Portable temp directory
└── ... (other VS Code files)
```

### Windows
```
C:\Path\To\Portable\
├── Code.exe               # VS Code executable
├── bin/
├── resources/
├── data/                  # Portable data folder
│   ├── user-data/        # Your VS Code settings
│   ├── extensions/       # Your installed extensions
│   └── tmp/              # Portable temp directory
└── ... (other VS Code files)
```

## Running Portable VS Code

After creation or upgrade:

### Linux
```bash
/path/to/portable/code
```

### Windows
```cmd
C:\Path\To\Portable\Code.exe
```

## Troubleshooting

### Linux Issues

**Sandbox permissions error**
If VS Code fails to start with sandbox-related errors:
```bash
sudo chown root /path/to/portable/chrome-sandbox
sudo chmod 4755 /path/to/portable/chrome-sandbox
```

**Download failures**
- Ensure you have internet connectivity
- Check if `curl` or `wget` is installed
- Verify the download URL is accessible

### Windows Issues

**PowerShell execution policy errors**
1. **Recommended**: Set policy for current user:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

2. **Alternative**: Use the batch wrapper:
   ```cmd
   vscode-portabilizer-cli.bat
   ```

3. **Temporary**: Bypass policy for single execution:
   ```powershell
   PowerShell.exe -ExecutionPolicy Bypass -File .\vscode-portabilizer.ps1 create C:\Tools\VSCode
   ```

**Access denied errors**
- Ensure you have write permissions to the destination folder
- Try running PowerShell as Administrator if needed

**Download/ZIP extraction errors**
- Check your internet connection
- Verify your firewall/antivirus isn't blocking downloads
- Ensure sufficient disk space

### Common Issues

**Missing user data**
If your system VS Code installation is in a different location, the tool will create a fresh installation automatically.

**Corporate network restrictions**
Some corporate networks may block direct downloads. In this case:
1. Download VS Code manually from the official website
2. Use the fresh installation mode
3. Manually copy settings if needed

## Tools Overview

### Core Scripts
Platform-specific main scripts that handle all the core functionality:

**Linux** (`vscode-portabilizer`)
- Downloads VS Code TAR.GZ archives
- Migrates user data and extensions
- Sets up portable directory structure
- Handles Linux-specific sandbox permissions

**Windows** (`vscode-portabilizer.ps1`)
- Downloads VS Code ZIP archives
- Migrates user data and extensions
- Sets up portable directory structure
- Handles Windows-specific requirements

### Interactive CLIs
User-friendly wrappers that provide:

**Linux** (`vscode-portabilizer-cli.sh`)
- Menu-driven interface for bash
- Input validation and prompting
- Guided workflow for beginners

**Windows** (`vscode-portabilizer-cli.ps1`)
- Menu-driven interface for PowerShell
- Input validation and prompting
- PowerShell execution policy handling
- Guided workflow for beginners

## Documentation

Each platform directory contains its own detailed README with platform-specific instructions and requirements.

## Contributing

When adding support for new platforms:

1. Create a new directory for the platform
2. Follow the official VS Code portable mode documentation
3. Include comprehensive error handling and user feedback
4. Add platform-specific README documentation
5. Test thoroughly before submitting

## License

This project is provided as-is. Use at your own risk.

## References

- [VS Code Portable Mode Documentation](https://code.visualstudio.com/docs/editor/portable)
- [VS Code Downloads](https://code.visualstudio.com/download)
