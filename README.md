# VS Code Portabilizer

A collection of tools to automate creating and managing VS Code portable installations across different platforms.

## Project Structure

```
vscode-portabilizer/
├── linux/                      # Linux-specific tools
│   ├── vscode-portabilizer     # Main bash script for Linux
│   ├── vscode-portabilizer-cli.sh # Interactive CLI wrapper
│   └── README.md               # Linux-specific documentation
└── README.md                   # This file
```

## Platform Support

Currently supported platforms:

- **Linux** (`./linux/`) - Complete implementation with create and upgrade functionality

## Planned Platform Support

Future platform support (not yet implemented):

- **Windows** - PowerShell/batch scripts for Windows portable installations
- **macOS** - Shell scripts for macOS portable installations

## Quick Start (Linux)

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

## Features

- **Automated downloads**: Fetches the latest VS Code releases
- **Data migration**: Preserves your settings and extensions
- **Platform-specific handling**: Follows official portable mode requirements
- **Upgrade support**: Updates VS Code while keeping your data
- **Error handling**: Comprehensive error checking and user feedback
- **Interactive CLI**: User-friendly interface for easier operation

## Tools Overview

### Core Script (`vscode-portabilizer`)
The main bash script that handles all the core functionality:
- Downloads VS Code archives
- Migrates user data and extensions
- Sets up portable directory structure
- Handles platform-specific requirements

### Interactive CLI (`vscode-portabilizer-cli.sh`)
A user-friendly wrapper that provides:
- Menu-driven interface
- Input validation and prompting
- Guided workflow for beginners
- Error handling with clear messages

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
