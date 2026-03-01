# 发行版打包指南

本文档说明如何为 Playwright Browser Skill 创建独立的发行版包。

[English Version](#english-version)

## 中文版本

### 概述

发行版包是完全独立的、开箱即用的安装包，包含：
- ✅ 编译后的代码 (dist/)
- ✅ 完整的依赖包 (node_modules/)
- ✅ 技能文档和配置
- ✅ 自动部署脚本
- ✅ 完整的使用文档

用户下载后无需运行 `npm install`，直接运行部署脚本即可使用。

### 打包前准备

1. 确保项目已构建：
```bash
npm install
npm run build
```

2. 确保所有测试通过：
```bash
npm test
```

3. 更新版本号（如需要）：
```bash
# 编辑 package.json 中的 version 字段
```

### Windows 平台打包

使用 PowerShell 运行：

```powershell
# 使用默认版本号（从 package.json 读取）
.\build-release.ps1

# 或指定版本号
.\build-release.ps1 -Version "2.1.0"
```

**输出：**
- 目录：`releases/playwright-browser-skill-windows-v2.1.0/`
- ZIP：`releases/playwright-browser-skill-windows-v2.1.0.zip`（可选）

**包大小：** 约 45-50 MB（未压缩），约 15-20 MB（ZIP 压缩）

### Mac/Linux 平台打包

使用 Bash 运行：

```bash
# 添加执行权限
chmod +x build-release.sh

# 使用默认版本号
./build-release.sh

# 或指定版本号
./build-release.sh 2.1.0
```

**输出：**
- 目录：`releases/playwright-browser-skill-macos-linux-v2.1.0/`
- tar.gz：`releases/playwright-browser-skill-macos-linux-v2.1.0.tar.gz`（可选）

**包大小：** 约 45-50 MB（未压缩），约 15-20 MB（tar.gz 压缩）

### 发行版包结构

```
playwright-browser-skill-windows-v2.1.0/
├── dist/                          # 编译后的代码
│   ├── mcp-server.js             # MCP 服务器入口
│   ├── index.js                  # 核心功能
│   ├── tools-registry.js         # 工具注册表
│   └── tool-handlers.js          # 工具处理器
├── node_modules/                  # 完整依赖（约 43 MB）
│   ├── playwright/
│   ├── @modelcontextprotocol/
│   └── ...
├── skill-package/                 # 技能包
│   ├── skills/
│   │   └── SKILL.md # 技能文档（101个工具）
│   └── settings/
│       └── mcp.json              # MCP 配置示例
├── auto-deploy.ps1               # 自动部署脚本（中文）
├── auto-deploy-en.ps1            # 自动部署脚本（英文）
├── auto-deploy.cmd               # CMD 部署脚本（中文）
├── auto-deploy-en.cmd            # CMD 部署脚本（英文）
├── README.md                     # 项目说明（中文）
├── README_EN.md                  # 项目说明（英文）
├── INSTALL.md                    # 安装说明
├── LICENSE                       # 许可证
├── WINDOWS_GUIDE.md              # Windows 使用指南
├── CONFIGURATION_GUIDE.md        # 配置指南
├── AUTO_DEPLOY_README.md         # 自动部署说明
└── package.json                  # 简化的包配置
```

### 发布流程

1. **创建发行版包**
```bash
# Windows
.\build-release.ps1 -Version "2.1.0"

# Mac/Linux
./build-release.sh 2.1.0
```

2. **测试发行版包**
```bash
# 解压到临时目录
# 运行自动部署脚本
# 验证功能是否正常
```

3. **上传到 GitHub Releases**
```bash
# 创建新的 Release
# 上传 ZIP/tar.gz 文件
# 添加发布说明
```

4. **更新文档**
```bash
# 更新 README.md 中的下载链接
# 更新版本号说明
```

### 用户安装流程

#### Windows 用户

1. 下载 `playwright-browser-skill-windows-v2.1.0.zip`
2. 解压到任意目录
3. 打开 PowerShell，进入解压目录
4. 运行：`.\auto-deploy.ps1`
5. 重启 OpenClaw
6. 开始使用！

#### Mac/Linux 用户

1. 下载 `playwright-browser-skill-macos-linux-v2.1.0.tar.gz`
2. 解压：`tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz`
3. 进入目录：`cd playwright-browser-skill-macos-linux-v2.1.0`
4. 运行：`chmod +x auto-deploy.sh && ./auto-deploy.sh`
5. 重启 OpenClaw
6. 开始使用！

### 优势

相比源码安装，发行版包有以下优势：

| 特性 | 源码安装 | 发行版包 |
|------|---------|---------|
| 需要 npm install | ✅ 是 | ❌ 否 |
| 需要构建 | ✅ 是 | ❌ 否 |
| 安装时间 | 5-10 分钟 | 1-2 分钟 |
| 网络要求 | 需要下载依赖 | 仅下载包 |
| 技术门槛 | 需要了解 Node.js | 无需技术背景 |
| 适用人群 | 开发者 | 所有用户 |

### 注意事项

1. **Node.js 版本**
   - 发行版包仍需要 Node.js 18+ 运行环境
   - 用户需要预先安装 Node.js

2. **平台兼容性**
   - Windows 包仅适用于 Windows 10/11
   - Mac/Linux 包适用于 macOS 10.15+ 和主流 Linux 发行版

3. **更新机制**
   - 用户需要手动下载新版本
   - 自动部署脚本会备份旧配置

4. **包大小**
   - 未压缩约 45-50 MB
   - 压缩后约 15-20 MB
   - 主要是 node_modules 和 Playwright 浏览器驱动

---

## English Version

### Overview

Release packages are fully independent, ready-to-use installation packages that include:
- ✅ Compiled code (dist/)
- ✅ Complete dependencies (node_modules/)
- ✅ Skill documentation and configuration
- ✅ Auto-deploy scripts
- ✅ Complete documentation

Users can use it directly after downloading without running `npm install`.

### Pre-build Preparation

1. Ensure project is built:
```bash
npm install
npm run build
```

2. Ensure all tests pass:
```bash
npm test
```

3. Update version number (if needed):
```bash
# Edit version field in package.json
```

### Windows Platform Build

Run with PowerShell:

```powershell
# Use default version (from package.json)
.\build-release.ps1

# Or specify version
.\build-release.ps1 -Version "2.1.0"
```

**Output:**
- Directory: `releases/playwright-browser-skill-windows-v2.1.0/`
- ZIP: `releases/playwright-browser-skill-windows-v2.1.0.zip` (optional)

**Package Size:** ~45-50 MB (uncompressed), ~15-20 MB (ZIP compressed)

### Mac/Linux Platform Build

Run with Bash:

```bash
# Add execute permission
chmod +x build-release.sh

# Use default version
./build-release.sh

# Or specify version
./build-release.sh 2.1.0
```

**Output:**
- Directory: `releases/playwright-browser-skill-macos-linux-v2.1.0/`
- tar.gz: `releases/playwright-browser-skill-macos-linux-v2.1.0.tar.gz` (optional)

**Package Size:** ~45-50 MB (uncompressed), ~15-20 MB (tar.gz compressed)

### User Installation Process

#### Windows Users

1. Download `playwright-browser-skill-windows-v2.1.0.zip`
2. Extract to any directory
3. Open PowerShell, navigate to extracted directory
4. Run: `.\auto-deploy.ps1`
5. Restart OpenClaw
6. Start using!

#### Mac/Linux Users

1. Download `playwright-browser-skill-macos-linux-v2.1.0.tar.gz`
2. Extract: `tar -xzf playwright-browser-skill-macos-linux-v2.1.0.tar.gz`
3. Navigate: `cd playwright-browser-skill-macos-linux-v2.1.0`
4. Run: `chmod +x auto-deploy.sh && ./auto-deploy.sh`
5. Restart OpenClaw
6. Start using!

### Advantages

Compared to source installation, release packages have the following advantages:

| Feature | Source Install | Release Package |
|---------|---------------|-----------------|
| Requires npm install | ✅ Yes | ❌ No |
| Requires build | ✅ Yes | ❌ No |
| Install time | 5-10 minutes | 1-2 minutes |
| Network requirement | Download dependencies | Download package only |
| Technical barrier | Node.js knowledge | No technical background |
| Target audience | Developers | All users |

### Notes

1. **Node.js Version**
   - Release package still requires Node.js 18+ runtime
   - Users need to pre-install Node.js

2. **Platform Compatibility**
   - Windows package only for Windows 10/11
   - Mac/Linux package for macOS 10.15+ and mainstream Linux distributions

3. **Update Mechanism**
   - Users need to manually download new versions
   - Auto-deploy script backs up old configuration

4. **Package Size**
   - ~45-50 MB uncompressed
   - ~15-20 MB compressed
   - Mainly node_modules and Playwright browser drivers

---

## 相关文档 / Related Documentation

- [README.md](README.md) - 项目主文档 / Main documentation
- [AUTO_DEPLOY_README.md](AUTO_DEPLOY_README.md) - 自动部署说明 / Auto-deploy guide
- [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md) - Windows 使用指南 / Windows guide
- [MAC_LINUX_GUIDE.md](MAC_LINUX_GUIDE.md) - Mac/Linux 使用指南 / Mac/Linux guide
