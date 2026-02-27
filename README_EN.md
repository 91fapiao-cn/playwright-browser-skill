# Playwright Browser Skill for OpenClaw

A powerful browser automation skill built on Playwright, providing 88+ complete browser operation capabilities for OpenClaw through the MCP protocol.

[![Windows](https://img.shields.io/badge/Windows-Supported-blue.svg)](WINDOWS_GUIDE.md)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org/)
[![Playwright](https://img.shields.io/badge/Playwright-1.40%2B-orange.svg)](https://playwright.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

[中文文档](README.md) | English

## ✨ Features

- 🌐 **Complete Browser Control** - Support for Chromium, Firefox, WebKit
- 📱 **Device Emulation** - Simulate iPhone, Android and other mobile devices
- 🎯 **Smart Selectors** - CSS, ARIA, text, tag and multiple selection methods
- 📸 **Screenshot & Recording** - Page screenshots, element screenshots, PDF generation, video recording
- 🌍 **Network Control** - Request interception, response mocking, offline mode
- 🔍 **Content Extraction** - Text, HTML, links, attributes, etc.
- ⚡ **Performance Monitoring** - Page performance metrics, console logs
- 🎨 **Advanced Features** - Cookie management, LocalStorage, geolocation, time control

## 📦 Installation

### Prerequisites

- Node.js 18 or higher
- npm or yarn
- Windows 10/11, macOS, or Linux

### Quick Start

```bash
# Clone repository
git clone https://github.com/91fapiao-cn/playwright-browser-skill.git
cd playwright-browser-skill

# Install dependencies
npm install

# Install browser drivers
npm run install-browsers

# Build project
npm run build
```

## 🚀 Usage

### One-Click Auto Deploy (Recommended)

We provide cross-platform auto-deploy scripts that automatically detect OpenClaw paths and complete all configurations:

#### Windows (PowerShell) - Recommended

```powershell
# Full deployment (auto-build + deploy)
.\auto-deploy.ps1

# Skip build (if already built)
.\auto-deploy.ps1 -SkipBuild

# Specify custom path
.\auto-deploy.ps1 -OpenClawPath "C:\custom\path\.openclaw"
```

#### Windows (CMD)

```cmd
REM Full deployment
auto-deploy.cmd

REM Skip build
auto-deploy.cmd --skip-build

REM Specify custom path
auto-deploy.cmd --openclaw-path "C:\custom\path\.openclaw"
```

#### Mac/Linux

```bash
# Add execute permission (first time)
chmod +x auto-deploy.sh

# Full deployment
./auto-deploy.sh

# Skip build
./auto-deploy.sh --skip-build

# Specify custom path
./auto-deploy.sh --openclaw-path "/custom/path/.openclaw"
```

**Auto-Deploy Features:**
- ✅ Auto-detect OpenClaw/Kiro configuration paths
- ✅ Auto-build project (optional skip)
- ✅ Auto-deploy Skill files
- ✅ Auto-configure MCP servers
- ✅ Auto-backup existing configurations
- ✅ Support custom installation paths

📖 [View Detailed Deployment Documentation](AUTO_DEPLOY_README_EN.md)

### Manual Deployment

If manual deployment is needed, follow these steps:

#### 1. Deploy Skill File

```bash
# Windows
copy skill-package\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\

# macOS/Linux
cp skill-package/skills/playwright-browser.md ~/.openclaw/skills/playwright-browser/
```

#### 2. Configure MCP Server

Add to `~/.openclaw/settings/mcp.json`:

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["<project-path>/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

#### 3. Restart OpenClaw

Restart OpenClaw to load the new skill.

## 📚 Tool List

### Browser Management (8 tools)
- `browser_launch` - Launch browser
- `browser_close` - Close browser
- `browser_new_page` - Create new page
- `browser_switch_page` - Switch page
- More...

### Page Navigation (4 tools)
- `browser_goto` - Navigate to URL
- `browser_go_back` - Go back
- `browser_go_forward` - Go forward
- `browser_reload` - Reload page

### Element Interaction (12 tools)
- `browser_click` - Click element
- `browser_fill` - Fill form
- `browser_type` - Type text
- `browser_select` - Select dropdown
- More...

### Content Extraction (11 tools)
- `browser_get_text` - Get text
- `browser_get_html` - Get HTML
- `browser_get_links` - Get links
- More...

[View Complete Tool List](skill-package/skills/playwright-browser.md)

## 💡 Usage Examples

### Headless Mode Explanation

The browser supports two running modes:

**Headed Mode (headless: false)** - Recommended for debugging and development
```javascript
browser_launch({ "headless": false })  // Show browser window
```

**Headless Mode (headless: true)** - Recommended for production and automation
```javascript
browser_launch({ "headless": true })   // Run in background, no window
// Or omit parameter, defaults to headless mode
browser_launch()
```

**Headless Mode Advantages:**
- ⚡ Faster execution speed
- 💾 Lower resource usage
- 🔒 Suitable for server environments
- 🤖 Ideal for batch automation tasks

### Basic Web Access

```javascript
// 1. Launch browser (headed mode for observation)
browser_launch({ "headless": false })

// 2. Visit webpage
browser_goto({ "url": "https://example.com" })

// 3. Get title
browser_get_title()

// 4. Screenshot
browser_screenshot({ "path": "screenshot.png", "fullPage": true })

// 5. Close browser
browser_close()
```

### Headless Mode Automation Example

```javascript
// Run in headless mode, suitable for automation tasks
browser_launch({ "headless": true })
browser_goto({ "url": "https://example.com" })
browser_get_title()
browser_screenshot({ "path": "screenshot.png" })
browser_close()
```

### Form Filling

```javascript
// Use headed mode for easier debugging
browser_launch({ "headless": false })
browser_goto({ "url": "https://example.com/login" })
browser_fill({ "selector": "#username", "value": "user@example.com" })
browser_fill({ "selector": "#password", "value": "password123" })
browser_click({ "selector": "button[type='submit']" })
browser_wait_for_selector({ "selector": ".dashboard" })
browser_close()
```

### Data Scraping

```javascript
// Headless mode recommended for data scraping, faster performance
browser_launch({ "headless": true })
browser_goto({ "url": "https://example.com/products" })
browser_count({ "selector": ".product-item" })
browser_get_links()
browser_evaluate({ 
  "script": "Array.from(document.querySelectorAll('.price')).map(e => e.textContent)" 
})
browser_close()
```

[View More Examples](skill-package/skills/playwright-browser.md#usage-examples)

## 🧪 Testing

```bash
# Run all tests
npm test

# Run basic tests
npm run test:basic

# Run advanced tests
npm run test:advanced

# Run interaction tests
npm run test:interaction

# Run MCP server tests
npm run test:mcp
```

## 📖 Documentation

- [Configuration Guide](CONFIGURATION_GUIDE.md) - Detailed configuration for headless mode, browser options, etc.
- [Auto-Deploy Guide](AUTO_DEPLOY_README_EN.md) - Cross-platform auto-deploy detailed instructions
- [Complete Tool Documentation](skill-package/skills/playwright-browser.md) - Detailed description of all 88 tools
- [Windows Usage Guide](WINDOWS_GUIDE.md) - Windows platform specific instructions
- [Quick Start Guide](QUICK_START_WINDOWS.md) - Quick start tutorial
- [API Documentation](API.md) - API reference
- [Architecture Description](ARCHITECTURE.md) - Project architecture

## 🔧 Development

### Project Structure

```
playwright-browser-skill/
├── src/
│   ├── index.ts              # Core functionality
│   ├── mcp-server.ts         # MCP server
│   └── tools-registry.ts     # Tools registry
├── skill-package/
│   ├── skills/
│   │   └── playwright-browser.md  # Skill definition file
│   └── settings/
│       └── mcp.json          # MCP configuration example
├── test/                     # Test files
├── examples/                 # Example code
└── docs/                     # Documentation
```

### Build

```bash
# Development mode (watch file changes)
npm run dev

# Production build
npm run build
```

## 🌍 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Windows 10/11 | ✅ Fully Supported | Tested |
| macOS | ✅ Fully Supported | Theoretical support |
| Linux | ✅ Fully Supported | Theoretical support |

## 🤝 Contributing

Contributions welcome! Please see [Contributing Guide](CONTRIBUTING.md).

## 📝 Changelog

### v2.1.0 (2024)
- 🚀 Added cross-platform auto-deploy scripts
- 🔍 Auto-detect OpenClaw/Kiro configuration paths
- 💾 Auto-backup existing configurations
- 📦 Support custom installation paths
- 📚 Complete auto-deploy documentation

### v2.0.0 (2024)
- ✨ Added 88 complete browser operation tools
- 📚 Complete Chinese documentation
- 🪟 Full Windows platform support
- 🎯 Smart selector support
- 📸 Screenshot and recording features
- 🌍 Network control and simulation

### v1.0.0
- 🎉 Initial release

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- [Playwright](https://playwright.dev/) - Powerful browser automation framework
- [OpenClaw](https://openclaw.ai/) - AI assistant platform
- [Model Context Protocol](https://modelcontextprotocol.io/) - MCP protocol

## 📞 Support

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/91fapiao-cn/playwright-browser-skill/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/91fapiao-cn/playwright-browser-skill/discussions)

## ⭐ Star History

If this project helps you, please give it a Star!

---

**Made with ❤️ for OpenClaw Community**
