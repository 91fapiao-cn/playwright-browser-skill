# Playwright Browser Skill for OpenClaw

一个功能强大的浏览器自动化技能，基于 Playwright 构建，通过 MCP 协议为 OpenClaw 提供 88+ 完整的浏览器操作能力。

[![Windows](https://img.shields.io/badge/Windows-支持-blue.svg)](WINDOWS_GUIDE.md)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org/)
[![Playwright](https://img.shields.io/badge/Playwright-1.40%2B-orange.svg)](https://playwright.dev/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

中文文档 | [English](README_EN.md)

## ✨ 特性

- 🌐 **完整的浏览器控制** - 支持 Chromium、Firefox、WebKit
- 📱 **设备模拟** - 模拟 iPhone、Android 等移动设备
- 🎯 **智能选择器** - CSS、ARIA、文本、标签等多种选择方式
- 📸 **截图和录制** - 页面截图、元素截图、PDF生成、视频录制
- 🌍 **网络控制** - 请求拦截、响应模拟、离线模式
- 🔍 **内容提取** - 文本、HTML、链接、属性等
- ⚡ **性能监控** - 页面性能指标、控制台日志
- 🎨 **高级功能** - Cookie管理、LocalStorage、地理位置、时间控制

## 📦 安装

### 前置要求

- Node.js 18 或更高版本
- npm 或 yarn
- Windows 10/11, macOS, 或 Linux

### 快速开始

```bash
# 克隆仓库
git clone https://github.com/91fapiao-cn/playwright-browser-skill.git
cd playwright-browser-skill

# 安装依赖
npm install

# 安装浏览器驱动
npm run install-browsers

# 构建项目
npm run build
```

## 🚀 使用方法

### 一键自动部署（推荐）

我们提供了跨平台的自动部署脚本，可以自动检测 OpenClaw 路径并完成所有配置：

#### Windows (PowerShell) - 推荐

```powershell
# 完整部署（自动构建 + 部署）
.\auto-deploy.ps1

# 跳过构建（如果已构建）
.\auto-deploy.ps1 -SkipBuild

# 指定自定义路径
.\auto-deploy.ps1 -OpenClawPath "C:\custom\path\.openclaw"
```

#### Windows (CMD)

```cmd
REM 完整部署
auto-deploy.cmd

REM 跳过构建
auto-deploy.cmd --skip-build

REM 指定自定义路径
auto-deploy.cmd --openclaw-path "C:\custom\path\.openclaw"
```

#### Mac/Linux

```bash
# 添加执行权限（首次使用）
chmod +x auto-deploy.sh

# 完整部署
./auto-deploy.sh

# 跳过构建
./auto-deploy.sh --skip-build

# 指定自定义路径
./auto-deploy.sh --openclaw-path "/custom/path/.openclaw"
```

**自动部署功能：**
- ✅ 自动检测 OpenClaw/Kiro 配置路径
- ✅ 自动构建项目（可选跳过）
- ✅ 自动部署 Skill 文件
- ✅ 自动配置 MCP 服务器
- ✅ 自动备份现有配置
- ✅ 支持自定义安装路径

📖 [查看详细部署文档](AUTO_DEPLOY_README.md)

### 手动部署

如果需要手动部署，请参考以下步骤：

#### 1. 部署 Skill 文件

```bash
# Windows
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\

# macOS/Linux
cp .kiro/skills/playwright-browser.md ~/.openclaw/skills/playwright-browser/
```

#### 2. 配置 MCP 服务器

在 `~/.openclaw/settings/mcp.json` 中添加：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["<项目路径>/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

#### 3. 重启 OpenClaw

重启 OpenClaw 以加载新的技能。

## 📚 工具列表

### 浏览器管理 (8个)
- `browser_launch` - 启动浏览器
- `browser_close` - 关闭浏览器
- `browser_new_page` - 创建新页面
- `browser_switch_page` - 切换页面
- 更多...

### 页面导航 (4个)
- `browser_goto` - 导航到URL
- `browser_go_back` - 返回上一页
- `browser_go_forward` - 前进
- `browser_reload` - 刷新页面

### 元素交互 (12个)
- `browser_click` - 点击元素
- `browser_fill` - 填写表单
- `browser_type` - 输入文本
- `browser_select` - 选择下拉框
- 更多...

### 内容提取 (11个)
- `browser_get_text` - 获取文本
- `browser_get_html` - 获取HTML
- `browser_get_links` - 获取链接
- 更多...

[查看完整工具列表](.kiro/skills/playwright-browser.md)

## 💡 使用示例

### 无头模式说明

浏览器支持两种运行模式：

**有界面模式（headless: false）** - 推荐用于调试和开发
```javascript
browser_launch({ "headless": false })  // 显示浏览器窗口
```

**无头模式（headless: true）** - 推荐用于生产环境和自动化
```javascript
browser_launch({ "headless": true })   // 后台运行，不显示窗口
// 或者省略参数，默认为无头模式
browser_launch()
```

**无头模式优势：**
- ⚡ 更快的执行速度
- 💾 更低的资源占用
- 🔒 适合服务器环境
- 🤖 适合批量自动化任务

### 基础网页访问

```javascript
// 1. 启动浏览器（有界面模式，便于观察）
browser_launch({ "headless": false })

// 2. 访问网页
browser_goto({ "url": "https://example.com" })

// 3. 获取标题
browser_get_title()

// 4. 截图
browser_screenshot({ "path": "screenshot.png", "fullPage": true })

// 5. 关闭浏览器
browser_close()
```

### 无头模式自动化示例

```javascript
// 无头模式运行，适合自动化任务
browser_launch({ "headless": true })
browser_goto({ "url": "https://example.com" })
browser_get_title()
browser_screenshot({ "path": "screenshot.png" })
browser_close()
```

### 表单填写

```javascript
// 使用有界面模式便于调试
browser_launch({ "headless": false })
browser_goto({ "url": "https://example.com/login" })
browser_fill({ "selector": "#username", "value": "user@example.com" })
browser_fill({ "selector": "#password", "value": "password123" })
browser_click({ "selector": "button[type='submit']" })
browser_wait_for_selector({ "selector": ".dashboard" })
browser_close()
```

### 数据抓取

```javascript
// 数据抓取推荐使用无头模式，速度更快
browser_launch({ "headless": true })
browser_goto({ "url": "https://example.com/products" })
browser_count({ "selector": ".product-item" })
browser_get_links()
browser_evaluate({ 
  "script": "Array.from(document.querySelectorAll('.price')).map(e => e.textContent)" 
})
browser_close()
```

[查看更多示例](.kiro/skills/playwright-browser.md#使用示例)

## 🧪 测试

```bash
# 运行所有测试
npm test

# 运行基础测试
npm run test:basic

# 运行高级测试
npm run test:advanced

# 运行交互测试
npm run test:interaction

# 运行MCP服务器测试
npm run test:mcp
```

## 📖 文档

- [配置指南](CONFIGURATION_GUIDE.md) - 无头模式、浏览器选项等详细配置说明
- [自动部署指南](AUTO_DEPLOY_README.md) - 跨平台自动部署详细说明 | [English](AUTO_DEPLOY_README_EN.md)
- [完整工具文档](.kiro/skills/playwright-browser.md) - 所有88个工具的详细说明
- [Windows 使用指南](WINDOWS_GUIDE.md) - Windows 平台特定说明
- [快速开始指南](QUICK_START_WINDOWS.md) - 快速上手教程
- [API 文档](API.md) - API 参考
- [架构说明](ARCHITECTURE.md) - 项目架构

## 🔧 开发

### 项目结构

```
playwright-browser-skill/
├── src/
│   ├── index.ts              # 核心功能实现
│   ├── mcp-server.ts         # MCP 服务器
│   └── tools-registry.ts     # 工具注册表
├── .kiro/
│   ├── skills/
│   │   └── playwright-browser.md  # 技能定义文件
│   └── settings/
│       └── mcp.json          # MCP 配置示例
├── test/                     # 测试文件
├── examples/                 # 示例代码
└── docs/                     # 文档
```

### 构建

```bash
# 开发模式（监听文件变化）
npm run dev

# 生产构建
npm run build
```

## 🌍 平台支持

| 平台 | 状态 | 说明 |
|------|------|------|
| Windows 10/11 | ✅ 完全支持 | 已测试 |
| macOS | ✅ 完全支持 | 理论支持 |
| Linux | ✅ 完全支持 | 理论支持 |

## 🤝 贡献

欢迎贡献！请查看 [贡献指南](CONTRIBUTING.md)。

## 📝 更新日志

### v2.1.0 (2024)
- 🚀 新增跨平台自动部署脚本
- 🔍 自动检测 OpenClaw/Kiro 配置路径
- 💾 自动备份现有配置
- 📦 支持自定义安装路径
- 📚 完整的自动部署文档

### v2.0.0 (2024)
- ✨ 新增 88 个完整的浏览器操作工具
- 📚 完整的中文文档
- 🪟 Windows 平台完整支持
- 🎯 智能选择器支持
- 📸 截图和录制功能
- 🌍 网络控制和模拟

### v1.0.0
- 🎉 初始版本

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [Playwright](https://playwright.dev/) - 强大的浏览器自动化框架
- [OpenClaw](https://openclaw.ai/) - AI 助手平台
- [Model Context Protocol](https://modelcontextprotocol.io/) - MCP 协议

## 📞 支持

- 📧 Email: 91fapiao@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/91fapiao-cn/playwright-browser-skill/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/91fapiao-cn/playwright-browser-skill/discussions)

## ⭐ Star History

如果这个项目对你有帮助，请给它一个 Star！

---

**Made with ❤️ for OpenClaw Community**
