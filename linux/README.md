# VS Code Portabilizer for Linux

A bash tool to automate creating and upgrading VS Code portable installations on Linux systems.

## Features

- **Create portable VS Code**: Downloads the latest VS Code and migrates your existing configuration
- **Upgrade portable installations**: Updates VS Code while preserving your data and extensions
- **Linux-specific handling**: Automatically sets the required sandbox permissions
- **Data migration**: Copies your user settings and extensions from the system installation

## Requirements

- Linux x64 system
- `curl` or `wget` for downloading
- `tar` for extracting archives
- `sudo` access for setting sandbox permissions

## Installation

1. Make the script executable:
   ```bash
   chmod +x vscode-portabilizer
   ```

2. Optionally, make the CLI interface executable:
   ```bash
   chmod +x vscode-portabilizer-cli.sh
   ```

3. Optionally, add the main script to your PATH:
   ```bash
   sudo cp vscode-portabilizer /usr/local/bin/
   ```

## Usage

### Using the main script directly

#### Create a new portable VS Code installation

```bash
./vscode-portabilizer create /path/to/destination
```

This will:
- Download the latest VS Code for Linux x64
- Extract it to the specified destination
- Create a `data` folder with your migrated settings and extensions
- Set the required sandbox permissions

Example:
```bash
./vscode-portabilizer create /opt/vscode-portable
```

#### Upgrade an existing portable installation

```bash
./vscode-portabilizer upgrade /path/to/existing/portable
```

This will:
- Backup your current `data` folder
- Download the latest VS Code
- Replace the VS Code binaries while preserving your data
- Restore your settings and extensions

Example:
```bash
./vscode-portabilizer upgrade /opt/vscode-portable
```

#### Get help

```bash
./vscode-portabilizer --help
```

### Using the interactive CLI

For a more user-friendly experience, use the interactive CLI:

```bash
./vscode-portabilizer-cli.sh
```

This will present you with a menu to:
1. Create a new portable VS Code installation
2. Upgrade an existing portable installation  
3. Show help information

The CLI will prompt you for the required paths and guide you through the process.

## What gets migrated?

When creating a new portable installation, the tool migrates:

- **User settings**: From `~/.config/Code` → `data/user-data`
- **Extensions**: From `~/.vscode/extensions` → `data/extensions`
- **Workspace settings**: All your VS Code configuration

## Directory structure

After creating a portable installation:

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

## Running portable VS Code

After creation or upgrade, run VS Code with:

```bash
/path/to/portable/code
```

## Troubleshooting

### Sandbox permissions error

If VS Code fails to start with sandbox-related errors, manually set permissions:

```bash
sudo chown root /path/to/portable/chrome-sandbox
sudo chmod 4755 /path/to/portable/chrome-sandbox
```

### Download failures

- Ensure you have internet connectivity
- Check if `curl` or `wget` is installed
- Verify the download URL is accessible

### Missing user data

If your system VS Code installation is in a different location, you may need to manually copy:

- Settings: Usually in `~/.config/Code`
- Extensions: Usually in `~/.vscode/extensions`

## Based on official documentation

This tool follows the official VS Code portable mode documentation:
https://code.visualstudio.com/docs/editor/portable

## License

This tool is provided as-is. Use at your own risk.
