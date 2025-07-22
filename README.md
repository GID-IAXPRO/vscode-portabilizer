# VS Code Portabilizer

A collection of tools to automate creating and managing VS Code portable installations across different platforms.

## Project Structure

```
vscode-portabilizer/
├── linux/                      # Linux-specific tools
│   ├── vscode-portabilizer     # Main bash script for Linux
│   ├── vscode-portabilizer-cli.sh # Interactive CLI wrapper
│   └── README.md               # Linux-specific documentation
├── windows/                     # Windows-specific tools
│   ├── vscode-portabilizer.ps1 # Main PowerShell script for Windows
│   ├── vscode-portabilizer-cli.ps1 # Interactive CLI wrapper
│   ├── vscode-portabilizer-cli.bat # Batch wrapper for execution policy bypass
│   └── README.md               # Windows-specific documentation
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
   
   Create a new portable VS Code installation:
   ```bash
   ./vscode-portabilizer create /path/to/destination
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
   
   Create a new portable VS Code installation:
   ```powershell
   .\vscode-portabilizer.ps1 create C:\Path\To\Destination
   ```

   Or upgrade an existing portable installation:
   ```powershell
   .\vscode-portabilizer.ps1 upgrade C:\Path\To\Existing\Portable
   ```

## Features

- **Automated downloads**: Fetches the latest VS Code releases
- **Data migration**: Preserves your settings and extensions
- **Platform-specific handling**: Follows official portable mode requirements
- **Upgrade support**: Updates VS Code while keeping your data
- **Error handling**: Comprehensive error checking and user feedback
- **Interactive CLI**: User-friendly interface for easier operation

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
