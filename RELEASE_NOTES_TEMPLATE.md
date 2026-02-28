# Playwright Browser Skill v2.1.0

[中文](#中文) | [English](#english)

---

<a name="中文"></a>

## 🎉 重大更新

首次提供**独立发行版**！无需 npm install 和构建，开箱即用！

## ✨ 新特性

- 🚀 提供 Windows 独立发行版（开箱即用）
- 🍎 提供 Mac/Linux 独立发行版（开箱即用）
- 📦 包含完整依赖，无需 npm install
- ⚡ 一键自动部署脚本
- 📚 完整的中英文文档
- 🌍 跨平台自动部署支持

## 📥 下载

### Windows 用户（推荐）
下载 **`playwright-browser-skill-windows-v2.1.0.zip`**（9.41 MB）

**安装步骤：**
1. 解压 ZIP 文件到任意目录
2. 双击运行 `auto-deploy.cmd`（推荐）
   - 或者：打开命令提示符，运行 `auto-deploy.cmd`
   - 或者：如果熟悉 PowerShell，运行 `.\auto-deploy.ps1`
3. 重启 OpenClaw
4. 开始使用！

**💡 提示：** 推荐使用 `.cmd` 文件，因为大部分 Windows 电脑默认禁止运行 PowerShell 脚本。

### Mac/Linux 用户
下载 **`playwright-browser-skill-macos-linux-v2.1.0.tar.gz`**（8.41 MB）

**安装步骤：**
1. 解压文件：
   ```bash
   tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz
   cd playwright-browser-skill-macos-linux-v2.1.0
   ```
2. 运行部署脚本：
   ```bash
   chmod +x auto-deploy.sh
   ./auto-deploy.sh
   ```
3. 重启 OpenClaw
4. 开始使用！

## 📖 文档

- [完整文档 / Full Documentation](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/README.md)
- [快速安装指南 / Quick Install Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/QUICK_INSTALL.md)
- [发行版使用指南 / Release Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/RELEASE_GUIDE.md)
- [Windows 使用指南 / Windows Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/WINDOWS_GUIDE.md)
- [Mac/Linux 使用指南 / Mac/Linux Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/MAC_LINUX_GUIDE.md)
- [配置指南 / Configuration Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/CONFIGURATION_GUIDE.md)

## 🎯 功能特性

- 🌐 **完整的浏览器控制** - 支持 Chromium、Firefox、WebKit
- 📱 **设备模拟** - 模拟 iPhone、Android 等移动设备
- 🎯 **智能选择器** - CSS、ARIA、文本、标签等多种选择方式
- 📸 **截图和录制** - 页面截图、元素截图、PDF生成、视频录制
- 🌍 **网络控制** - 请求拦截、响应模拟、离线模式
- 🔍 **内容提取** - 文本、HTML、链接、属性等
- ⚡ **性能监控** - 页面性能指标、控制台日志
- 🎨 **高级功能** - Cookie管理、LocalStorage、地理位置、时间控制

## 📊 工具统计

- **101 个浏览器操作工具**
- 8 个浏览器管理工具
- 4 个页面导航工具
- 12 个元素交互工具
- 11 个内容提取工具
- 更多高级功能...

## 🆚 发行版 vs 源码安装

| 特性 | 发行版 | 源码安装 |
|------|--------|---------|
| 安装时间 | 1-2 分钟 | 5-10 分钟 |
| 需要 npm install | ❌ 否 | ✅ 是 |
| 需要构建 | ❌ 否 | ✅ 是 |
| 下载大小 | ~9 MB | ~500 KB |
| 适用人群 | 所有用户 | 开发者 |

## 🔧 系统要求

### Windows
- Windows 10/11
- Node.js 18 或更高版本

### Mac/Linux
- macOS 10.15+ 或 Linux（Ubuntu 20.04+, Debian 11+, Fedora 35+）
- Node.js 18 或更高版本

## 📝 更新日志

### v2.1.0 (2026-02-28)
- 🚀 新增跨平台自动部署脚本
- 🔍 自动检测 OpenClaw 配置路径
- 💾 自动备份现有配置
- 📦 支持自定义安装路径
- 📚 完整的自动部署文档
- 🎁 首次提供独立发行版（Windows + Mac/Linux）
- 🖱️ Windows 优先使用 CMD 脚本（避免 PowerShell 执行策略问题）

### v2.0.0
- ✨ 新增 88 个完整的浏览器操作工具
- 📚 完整的中文文档
- 🪟 Windows 平台完整支持

## 🙏 致谢

感谢所有使用和支持本项目的用户！

## 📞 支持

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: https://github.com/91fapiao-cn/playwright-browser-skill/issues
- 💬 Discussions: https://github.com/91fapiao-cn/playwright-browser-skill/discussions

---

<a name="english"></a>

## 🎉 Major Update

First **standalone release** available! No npm install or build required, ready to use out of the box!

## ✨ New Features

- 🚀 Windows standalone release (ready to use)
- 🍎 Mac/Linux standalone release (ready to use)
- 📦 Includes complete dependencies, no npm install needed
- ⚡ One-click auto-deploy scripts
- 📚 Complete bilingual documentation
- 🌍 Cross-platform auto-deploy support

## 📥 Download

### Windows Users (Recommended)
Download **`playwright-browser-skill-windows-v2.1.0.zip`** (9.41 MB)

**Installation Steps:**
1. Extract ZIP file to any directory
2. Double-click `auto-deploy-en.cmd` (recommended)
   - Or: Open Command Prompt and run `auto-deploy-en.cmd`
   - Or: If familiar with PowerShell, run `.\auto-deploy-en.ps1`
3. Restart OpenClaw
4. Start using!

**💡 Tip:** Recommended to use `.cmd` file, as most Windows computers block PowerShell scripts by default.

### Mac/Linux Users
Download **`playwright-browser-skill-macos-linux-v2.1.0.tar.gz`** (8.41 MB)

**Installation Steps:**
1. Extract file:
   ```bash
   tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz
   cd playwright-browser-skill-macos-linux-v2.1.0
   ```
2. Run deployment script:
   ```bash
   chmod +x auto-deploy-en.sh
   ./auto-deploy-en.sh
   ```
3. Restart OpenClaw
4. Start using!

## 📖 Documentation

- [Full Documentation](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/README_EN.md)
- [Quick Install Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/QUICK_INSTALL.md)
- [Release Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/RELEASE_GUIDE.md)
- [Windows Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/WINDOWS_GUIDE.md)
- [Mac/Linux Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/MAC_LINUX_GUIDE.md)
- [Configuration Guide](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/CONFIGURATION_GUIDE.md)

## 🎯 Features

- 🌐 **Complete Browser Control** - Support for Chromium, Firefox, WebKit
- 📱 **Device Emulation** - Simulate iPhone, Android and other mobile devices
- 🎯 **Smart Selectors** - CSS, ARIA, text, tag and multiple selection methods
- 📸 **Screenshot & Recording** - Page screenshots, element screenshots, PDF generation, video recording
- 🌍 **Network Control** - Request interception, response mocking, offline mode
- 🔍 **Content Extraction** - Text, HTML, links, attributes, etc.
- ⚡ **Performance Monitoring** - Page performance metrics, console logs
- 🎨 **Advanced Features** - Cookie management, LocalStorage, geolocation, time control

## 📊 Tool Statistics

- **101 browser operation tools**
- 8 browser management tools
- 4 page navigation tools
- 12 element interaction tools
- 11 content extraction tools
- More advanced features...

## 🆚 Release vs Source Installation

| Feature | Release | Source Install |
|---------|---------|----------------|
| Install time | 1-2 minutes | 5-10 minutes |
| Requires npm install | ❌ No | ✅ Yes |
| Requires build | ❌ No | ✅ Yes |
| Download size | ~9 MB | ~500 KB |
| Target audience | All users | Developers |

## 🔧 System Requirements

### Windows
- Windows 10/11
- Node.js 18 or higher

### Mac/Linux
- macOS 10.15+ or Linux (Ubuntu 20.04+, Debian 11+, Fedora 35+)
- Node.js 18 or higher

## 📝 Changelog

### v2.1.0 (2026-02-28)
- 🚀 Added cross-platform auto-deploy scripts
- 🔍 Auto-detect OpenClaw configuration paths
- 💾 Auto-backup existing configurations
- 📦 Support custom installation paths
- 📚 Complete auto-deploy documentation
- 🎁 First standalone release (Windows + Mac/Linux)
- 🖱️ Windows prioritizes CMD scripts (avoid PowerShell execution policy issues)

### v2.0.0
- ✨ Added 88 complete browser operation tools
- 📚 Complete Chinese documentation
- 🪟 Full Windows platform support

## 🙏 Acknowledgments

Thanks to all users who use and support this project!

## 📞 Support

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: https://github.com/91fapiao-cn/playwright-browser-skill/issues
- 💬 Discussions: https://github.com/91fapiao-cn/playwright-browser-skill/discussions

---

**Made with ❤️ for OpenClaw Community**
