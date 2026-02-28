# Auto-Deploy Scripts Usage Guide

This project provides three auto-deploy scripts that automatically detect OpenClaw configuration paths and complete the full deployment.

## Script List

| Script File | Platform | Description |
|------------|----------|-------------|
| `auto-deploy.ps1` | Windows (PowerShell) | Recommended for Windows, most feature-complete |
| `auto-deploy.cmd` | Windows (CMD) | Windows batch version |
| `auto-deploy.sh` | Mac/Linux | For Unix systems |

## Features

✅ Auto-detect OpenClaw configuration paths  
✅ Auto-build project (optional skip)  
✅ Auto-create necessary directory structure  
✅ Auto-deploy Skill files  
✅ Auto-configure MCP servers  
✅ Backup existing configurations (if present)  
✅ Support custom installation paths  

## Usage

### Windows (PowerShell) - Recommended

```powershell
# Default deployment (auto-detect path + build project)
.\auto-deploy.ps1

# Skip build (if already built)
.\auto-deploy.ps1 -SkipBuild

# Specify custom OpenClaw path
.\auto-deploy.ps1 -OpenClawPath "C:\custom\path\.openclaw"

# Combined usage
.\auto-deploy.ps1 -SkipBuild -OpenClawPath "D:\MyApps\.kiro"
```

### Windows (CMD)

```cmd
REM Default deployment
auto-deploy.cmd

REM Skip build
auto-deploy.cmd --skip-build

REM Specify custom path
auto-deploy.cmd --openclaw-path "C:\custom\path\.openclaw"

REM Show help
auto-deploy.cmd --help
```

### Mac/Linux

```bash
# Add execute permission (first time only)
chmod +x auto-deploy.sh

# Default deployment
./auto-deploy.sh

# Skip build
./auto-deploy.sh --skip-build

# Specify custom path
./auto-deploy.sh --openclaw-path "/custom/path/.openclaw"

# Show help
./auto-deploy.sh --help
```

## Auto Path Detection

Scripts will automatically detect OpenClaw configuration paths in the following order:

### Windows
1. `%USERPROFILE%\.openclaw`
2. `%USERPROFILE%\.kiro`
3. `%APPDATA%\openclaw`
4. `%LOCALAPPDATA%\openclaw`

### Mac/Linux
1. `~/.openclaw`
2. `~/.kiro`
3. `~/Library/Application Support/openclaw` (Mac)
4. `~/Library/Application Support/kiro` (Mac)

If no existing configuration is found, the default path will be used:
- Windows: `%USERPROFILE%\.openclaw`
- Mac/Linux: `~/.openclaw`

## Deployment Process

The script automatically executes the following steps:

1. **Check Project Environment** - Verify correct project directory
2. **Build Project** - Run `npm run build` (optional skip)
3. **Detect Configuration Path** - Auto-find or use specified path
4. **Create Directory Structure** - Create necessary directories
5. **Deploy Skill Files** - Copy skill files to target location
6. **Configure MCP Server** - Create or update mcp.json

## Configuration Backup

If an existing `mcp.json` configuration file is detected, the script will:

1. Automatically create a backup file (with timestamp)
2. Merge new configuration into existing configuration (PowerShell and Shell scripts)
3. Or prompt for manual merge (CMD script)

Backup file format: `mcp.json.backup.YYYYMMDD-HHMMSS`

## Post-Deployment Steps

After deployment completes, you need to:

1. **Restart OpenClaw**
2. **Verify MCP Server Status**
   - Open MCP server panel
   - Confirm `playwright-browser` shows as connected
3. **Test Functionality**
   - In chat, type: `Launch browser and visit example.com`
   - Or use other browser-related commands

## Troubleshooting

### Issue: Script says "Please run in project root directory"

**Solution:**
```bash
# Make sure you're in the project root (directory containing .kiro folder)
cd /path/to/playwright-browser-mcp
```

### Issue: Build fails

**Solution:**
```bash
# Manually install dependencies first
npm install

# Then re-run deployment script
```

### Issue: Cannot find OpenClaw configuration directory

**Solution:**
```bash
# Use --openclaw-path parameter to specify path
./auto-deploy.sh --openclaw-path "/your/custom/path"
```

### Issue: PowerShell execution policy restriction

**Solution:**
```powershell
# Temporarily allow script execution
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Then run the script
.\auto-deploy.ps1
```

### Issue: Mac/Linux permission denied

**Solution:**
```bash
# Add execute permission
chmod +x auto-deploy.sh

# If system directory write access needed, use sudo
sudo ./auto-deploy.sh
```

## Manual Verification

After deployment, you can manually verify the following files:

### Skill File
```
Windows: %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
Mac/Linux: ~/.openclaw/skills/playwright-browser/playwright-browser.md
```

### MCP Configuration
```
Windows: %USERPROFILE%\.openclaw\settings\mcp.json
Mac/Linux: ~/.openclaw/settings/mcp.json
```

### MCP Server
```
project-directory/dist/mcp-server.js
```

## Comparison with Old Scripts

| Feature | Old Scripts | New Scripts (auto-deploy) |
|---------|-------------|---------------------------|
| Auto path detection | ❌ | ✅ |
| Auto build | ❌ | ✅ |
| Config merge | ❌ | ✅ |
| Auto backup | ❌ | ✅ |
| Cross-platform | Partial | ✅ |
| Custom path | ❌ | ✅ |
| Error handling | Basic | Comprehensive |

## Advanced Usage

### Batch Deploy to Multiple Environments

```bash
# Deploy to development environment
./auto-deploy.sh --openclaw-path ~/.openclaw-dev

# Deploy to test environment
./auto-deploy.sh --openclaw-path ~/.openclaw-test

# Deploy to production environment
./auto-deploy.sh --openclaw-path ~/.openclaw-prod
```

### CI/CD Integration

```yaml
# GitHub Actions example
- name: Deploy to OpenClaw
  run: |
    npm install
    ./auto-deploy.sh --skip-build
```

### Development Workflow

```bash
# Quick redeploy during development (skip build)
npm run build && ./auto-deploy.sh --skip-build
```

## Related Documentation

- [Deployment Architecture](DEPLOYMENT_ARCHITECTURE.md)
- [Windows Compatibility Guide](WINDOWS_COMPATIBILITY.md)
- [Project API Documentation](API.md)
- [中文版本](AUTO_DEPLOY_README.md)

## Support

If you have issues, please check:
1. Troubleshooting section in this document
2. Other project documentation files
3. Submit an Issue to the project repository
