# 发行版使用指南

本文档为用户提供发行版的下载和使用说明。

[English Version](#english-version)

---

## 中文版本

### 什么是发行版？

发行版是**开箱即用**的独立安装包，包含所有必需的文件和依赖。您无需安装 npm 依赖或构建项目，下载后直接运行部署脚本即可使用。

### 下载发行版

访问 [GitHub Releases](https://github.com/91fapiao-cn/playwright-browser-skill/releases) 页面下载最新版本：

#### Windows 用户
下载：`playwright-browser-skill-windows-v2.1.0.zip` (约 9 MB)

#### Mac/Linux 用户
下载：`playwright-browser-skill-macos-linux-v2.1.0.tar.gz` (约 9 MB)

### 安装步骤

#### Windows 安装

1. **解压文件**
   - 右键点击下载的 ZIP 文件
   - 选择"全部解压缩"
   - 解压到任意目录（例如：`D:\playwright-browser-skill\`）

2. **运行部署脚本（三种方式，任选其一）**

   **方式一：双击运行（最简单，推荐）**
   - 双击 `auto-deploy.cmd` 文件
   - 或双击 `auto-deploy-en.cmd`（英文版）
   
   **方式二：命令提示符**
   - 在解压目录中，按住 Shift 键，右键点击空白处
   - 选择"在此处打开命令窗口"或"在此处打开 PowerShell 窗口"
   - 运行命令：
   ```cmd
   auto-deploy.cmd
   ```
   
   **方式三：PowerShell（需要执行策略权限）**
   - 在解压目录中，按住 Shift 键，右键点击空白处
   - 选择"在此处打开 PowerShell 窗口"
   - 如果提示执行策略错误，先运行：
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
   - 然后运行：
   ```powershell
   .\auto-deploy.ps1
   ```

   **推荐使用方式一或方式二**，因为大部分 Windows 电脑默认禁止运行 PowerShell 脚本。

3. **重启 OpenClaw**
   - 完全关闭 OpenClaw
   - 重新启动 OpenClaw

4. **开始使用**
   - 在 OpenClaw 对话中输入：
   ```
   请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器
   ```

#### Mac/Linux 安装

1. **解压文件**
   ```bash
   tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz
   cd playwright-browser-skill-macos-linux-v2.1.0
   ```

2. **运行部署脚本**
   ```bash
   chmod +x auto-deploy.sh
   ./auto-deploy.sh
   ```
   
   或使用英文版本：
   ```bash
   chmod +x auto-deploy-en.sh
   ./auto-deploy-en.sh
   ```

3. **重启 OpenClaw**
   - 完全关闭 OpenClaw
   - 重新启动 OpenClaw

4. **开始使用**
   - 在 OpenClaw 对话中输入：
   ```
   请使用 Playwright Browser Skill 技能来访问互联网和控制浏览器
   ```

### 验证安装

安装完成后，可以通过以下方式验证：

1. **检查 MCP 服务器状态**
   - 在 OpenClaw 中打开 MCP 服务器面板
   - 确认 `playwright-browser` 显示为"已连接"状态

2. **测试基本功能**
   - 在对话中输入：
   ```
   启动浏览器并访问 example.com
   ```
   - 如果浏览器成功启动并访问网页，说明安装成功

### 常见问题

#### Q: 提示"无法加载文件，因为在此系统上禁止运行脚本"

**A:** 这是 PowerShell 执行策略限制。解决方法：

```powershell
# 临时允许执行脚本
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 然后重新运行部署脚本
.\auto-deploy.ps1
```

#### Q: 提示"找不到 Node.js"

**A:** 发行版仍需要 Node.js 运行环境。请先安装 Node.js 18 或更高版本：
- 访问 [Node.js 官网](https://nodejs.org/)
- 下载并安装 LTS 版本
- 重启终端后重新运行部署脚本

#### Q: Mac 提示"无法打开，因为无法验证开发者"

**A:** 这是 macOS 的安全限制。解决方法：

```bash
# 移除隔离属性
xattr -cr playwright-browser-skill-macos-linux-v2.1.0

# 然后重新运行部署脚本
./auto-deploy.sh
```

#### Q: 如何更新到新版本？

**A:** 
1. 下载新版本的发行版
2. 解压到新目录
3. 运行部署脚本（会自动备份旧配置）
4. 重启 OpenClaw

旧版本的文件可以安全删除。

#### Q: 如何卸载？

**A:** 删除以下目录即可：

**Windows:**
```
C:\Users\你的用户名\.openclaw\skills\playwright-browser\
```

**Mac/Linux:**
```
~/.openclaw/skills/playwright-browser/
```

然后从 `~/.openclaw/settings/mcp.json` 中删除 `playwright-browser` 配置。

### 发行版 vs 源码安装

| 特性 | 发行版 | 源码安装 |
|------|--------|---------|
| 安装时间 | 1-2 分钟 | 5-10 分钟 |
| 需要 npm install | ❌ 否 | ✅ 是 |
| 需要构建 | ❌ 否 | ✅ 是 |
| 下载大小 | ~9 MB | ~500 KB |
| 解压后大小 | ~43 MB | ~43 MB |
| 适用人群 | 所有用户 | 开发者 |
| 技术门槛 | 低 | 中等 |

### 包含内容

发行版包含以下内容：

```
playwright-browser-skill-windows-v2.1.0/
├── dist/                          # 编译后的代码
├── node_modules/                  # 完整依赖（43 MB）
├── skill-package/                 # 技能文档
├── auto-deploy.ps1               # 自动部署脚本（中文）
├── auto-deploy-en.ps1            # 自动部署脚本（英文）
├── README.md                     # 项目说明
├── INSTALL.md                    # 安装说明
└── 其他文档...
```

### 系统要求

- **Windows:** Windows 10/11
- **Mac:** macOS 10.15 或更高版本
- **Linux:** 主流发行版（Ubuntu 20.04+, Debian 11+, Fedora 35+）
- **Node.js:** 18.0.0 或更高版本

### 获取帮助

如果遇到问题：

1. 查看 [完整文档](README.md)
2. 查看 [常见问题](WINDOWS_GUIDE.md)
3. 提交 [Issue](https://github.com/91fapiao-cn/playwright-browser-skill/issues)
4. 发送邮件：91fapiao@gmail.com

---

## English Version

### What is a Release Package?

A release package is a **ready-to-use** standalone installation package that includes all necessary files and dependencies. You don't need to install npm dependencies or build the project - just download and run the deployment script.

### Download Release

Visit the [GitHub Releases](https://github.com/91fapiao-cn/playwright-browser-skill/releases) page to download the latest version:

#### Windows Users
Download: `playwright-browser-skill-windows-v2.1.0.zip` (~9 MB)

#### Mac/Linux Users
Download: `playwright-browser-skill-macos-linux-v2.1.0.tar.gz` (~9 MB)

### Installation Steps

#### Windows Installation

1. **Extract Files**
   - Right-click the downloaded ZIP file
   - Select "Extract All"
   - Extract to any directory (e.g., `D:\playwright-browser-skill\`)

2. **Run Deployment Script (Choose one method)**

   **Method 1: Double-click (Easiest, Recommended)**
   - Double-click `auto-deploy-en.cmd` file
   - Or double-click `auto-deploy.cmd` (Chinese version)
   
   **Method 2: Command Prompt**
   - In the extracted directory, hold Shift and right-click in empty space
   - Select "Open command window here" or "Open PowerShell window here"
   - Run command:
   ```cmd
   auto-deploy-en.cmd
   ```
   
   **Method 3: PowerShell (Requires execution policy permission)**
   - In the extracted directory, hold Shift and right-click in empty space
   - Select "Open PowerShell window here"
   - If you get execution policy error, first run:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```
   - Then run:
   ```powershell
   .\auto-deploy-en.ps1
   ```

   **Recommended: Use Method 1 or Method 2**, as most Windows computers block PowerShell scripts by default.

3. **Restart OpenClaw**
   - Completely close OpenClaw
   - Restart OpenClaw

4. **Start Using**
   - In OpenClaw chat, type:
   ```
   Please use Playwright Browser Skill to access the internet and control browsers
   ```

#### Mac/Linux Installation

1. **Extract Files**
   ```bash
   tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz
   cd playwright-browser-skill-macos-linux-v2.1.0
   ```

2. **Run Deployment Script**
   ```bash
   chmod +x auto-deploy-en.sh
   ./auto-deploy-en.sh
   ```

3. **Restart OpenClaw**
   - Completely close OpenClaw
   - Restart OpenClaw

4. **Start Using**
   - In OpenClaw chat, type:
   ```
   Please use Playwright Browser Skill to access the internet and control browsers
   ```

### Verify Installation

After installation, verify by:

1. **Check MCP Server Status**
   - Open MCP server panel in OpenClaw
   - Confirm `playwright-browser` shows as "Connected"

2. **Test Basic Functionality**
   - In chat, type:
   ```
   Launch browser and visit example.com
   ```
   - If browser launches and visits the page, installation is successful

### FAQ

#### Q: "Cannot load file because running scripts is disabled on this system"

**A:** This is a PowerShell execution policy restriction. Solution:

```powershell
# Temporarily allow script execution
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Then re-run deployment script
.\auto-deploy-en.ps1
```

#### Q: "Node.js not found"

**A:** Release package still requires Node.js runtime. Please install Node.js 18 or higher first:
- Visit [Node.js official website](https://nodejs.org/)
- Download and install LTS version
- Restart terminal and re-run deployment script

#### Q: Mac says "Cannot open because developer cannot be verified"

**A:** This is a macOS security restriction. Solution:

```bash
# Remove quarantine attribute
xattr -cr playwright-browser-skill-macos-linux-v2.1.0

# Then re-run deployment script
./auto-deploy-en.sh
```

#### Q: How to update to a new version?

**A:** 
1. Download new version release
2. Extract to new directory
3. Run deployment script (will auto-backup old config)
4. Restart OpenClaw

Old version files can be safely deleted.

#### Q: How to uninstall?

**A:** Delete the following directory:

**Windows:**
```
C:\Users\YourUsername\.openclaw\skills\playwright-browser\
```

**Mac/Linux:**
```
~/.openclaw/skills/playwright-browser/
```

Then remove `playwright-browser` configuration from `~/.openclaw/settings/mcp.json`.

### Release vs Source Installation

| Feature | Release | Source Install |
|---------|---------|----------------|
| Install time | 1-2 minutes | 5-10 minutes |
| Requires npm install | ❌ No | ✅ Yes |
| Requires build | ❌ No | ✅ Yes |
| Download size | ~9 MB | ~500 KB |
| Extracted size | ~43 MB | ~43 MB |
| Target audience | All users | Developers |
| Technical barrier | Low | Medium |

### Package Contents

Release package includes:

```
playwright-browser-skill-windows-v2.1.0/
├── dist/                          # Compiled code
├── node_modules/                  # Complete dependencies (43 MB)
├── skill-package/                 # Skill documentation
├── auto-deploy-en.ps1            # Auto-deploy script (English)
├── auto-deploy.ps1               # Auto-deploy script (Chinese)
├── README.md                     # Project documentation
├── INSTALL.md                    # Installation guide
└── Other docs...
```

### System Requirements

- **Windows:** Windows 10/11
- **Mac:** macOS 10.15 or higher
- **Linux:** Mainstream distributions (Ubuntu 20.04+, Debian 11+, Fedora 35+)
- **Node.js:** 18.0.0 or higher

### Get Help

If you encounter issues:

1. Check [Complete Documentation](README_EN.md)
2. Check [FAQ](WINDOWS_GUIDE.md)
3. Submit an [Issue](https://github.com/91fapiao-cn/playwright-browser-skill/issues)
4. Email: 91fapiao@gmail.com

---

**Made with ❤️ for OpenClaw Community**
