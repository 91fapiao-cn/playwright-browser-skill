# Windows 部署指南

本指南专门针对在 Windows 系统上部署和使用 Playwright Browser Skill for OpenClaw。

## 📋 系统要求

- Windows 10 或更高版本
- Node.js 18.x 或更高版本
- npm 或 yarn 包管理器
- 至少 2GB 可用磁盘空间（用于浏览器二进制文件）

## 🚀 快速开始

### 1. 安装 Node.js

如果尚未安装 Node.js，请从官网下载并安装：
- 访问 https://nodejs.org/
- 下载 LTS 版本（推荐）
- 运行安装程序，按照提示完成安装

验证安装：
```cmd
node --version
npm --version
```

### 2. 克隆或下载项目

```cmd
cd D:\your-projects
git clone <repository-url>
cd playwright-browser-skill
```

或者直接解压下载的 ZIP 文件到目标目录。

### 3. 安装依赖

```cmd
npm install
```

### 4. 安装浏览器二进制文件

Playwright 会自动下载适用于 Windows 的浏览器：

```cmd
npx playwright install
```

这将下载：
- Chromium（约 150MB）
- Firefox（约 80MB）
- WebKit（约 50MB）

如果只需要特定浏览器：
```cmd
npx playwright install chromium
```

### 5. 构建项目

```cmd
npm run build
```

## 🔧 配置 OpenClaw

### 配置文件位置说明

OpenClaw 的配置文件位于用户目录下：

```
C:\Users\你的用户名.openclaw\
├── settings\
│   └── mcp.json          ← MCP 服务器配置
└── skills\
    └── playwright-browser.md  ← Skill 定义文件
```

**重要**：配置文件在 OpenClaw 的配置目录，而不是项目目录！

### 方法 1：使用绝对路径（推荐）

创建或编辑 `%USERPROFILE%.openclaw\settings\mcp.json`：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["D:\\your-projects\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

**注意**：
- 使用双反斜杠 `\\` 或单正斜杠 `/`
- 路径必须是完整的绝对路径
- 不要使用相对路径如 `./` 或 `../`

### 方法 2：使用环境变量

设置环境变量：
```cmd
setx PLAYWRIGHT_SKILL_PATH "D:\your-projects\playwright-browser-skill"
```

然后在 `mcp.json` 中使用：
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["%PLAYWRIGHT_SKILL_PATH%\\dist\\mcp-server.js"],
      "disabled": false
    }
  }
}
```

### 复制 Skill 定义文件

将项目中的 Skill 定义文件复制到 OpenClaw 配置目录：

```cmd
REM 确保目标目录存在
if not exist "%USERPROFILE%.openclaw\skills" mkdir "%USERPROFILE%.openclaw\skills"

REM 复制 Skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

验证复制成功：
```cmd
dir %USERPROFILE%.openclaw\skills\playwright-browser.md
```

或者手动复制文件：
- **源文件**：`项目目录.openclaw\skills\playwright-browser.md`
- **目标位置**：`C:\Users\你的用户名.openclaw\skills\playwright-browser.md`

## 🧪 测试安装

### 运行基础测试

```cmd
npm run test:basic
```

预期输出：
```
🧪 开始基础功能测试...
✅ 浏览器启动成功
✅ 页面导航成功
✅ 页面标题: Example Domain
...
🎉 所有基础功能测试通过！
```

### 运行 MCP 服务器测试

```cmd
npm run test:mcp
```

### 手动测试 MCP 服务器

```cmd
node dist\mcp-server.js
```

应该看到：
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

按 `Ctrl+C` 停止服务器。

## 💡 在 OpenClaw 中使用

启动 OpenClaw 后，可以直接使用自然语言：

```
启动浏览器，访问 example.com，获取页面标题并截图
```

或者：

```
打开浏览器，访问 github.com，搜索 "playwright"，
获取第一个搜索结果的标题
```

## 🐛 常见问题

### 问题 1：找不到模块错误

**错误信息**：
```
Error: Cannot find module 'D:\...\dist\mcp-server.js'
```

**解决方案**：
1. 确认已运行 `npm run build`
2. 检查路径是否正确（使用 `\\` 或 `/`）
3. 使用绝对路径而非相对路径

### 问题 2：浏览器启动失败

**错误信息**：
```
browserType.launch: Executable doesn't exist
```

**解决方案**：
```cmd
npx playwright install chromium
```

### 问题 3：权限错误

**错误信息**：
```
EACCES: permission denied
```

**解决方案**：
1. 以管理员身份运行命令提示符
2. 或者更改项目目录的权限

### 问题 4：端口被占用

**错误信息**：
```
Error: listen EADDRINUSE: address already in use
```

**解决方案**：
1. 关闭其他占用端口的程序
2. 或者在配置中指定不同的端口

### 问题 5：TypeScript 编译错误

**错误信息**：
```
'tsc' is not recognized as an internal or external command
```

**解决方案**：
```cmd
npm install
npm run build
```

## 📁 Windows 特定路径说明

### 项目路径示例（你的项目位置）

```
D:\Projects\playwright-browser-skill\
├── dist\
│   ├── mcp-server.js      ← MCP 服务器（在这里）
│   └── index.js
├── src\
├── test\
├── .kiro\
│   └── skills\
│       └── playwright-browser.md  ← 源 Skill 文件（需要复制）
└── package.json
```

### OpenClaw 配置路径（固定位置）

```
C:\Users\你的用户名.openclaw\
├── settings\
│   └── mcp.json           ← MCP 配置文件（在这里编辑）
└── skills\
    └── playwright-browser.md  ← Skill 文件（复制到这里）
```

**关键点**：
- MCP 配置文件在：`%USERPROFILE%.openclaw\settings\mcp.json`
- Skill 文件需要复制到：`%USERPROFILE%.openclaw\skills\`
- MCP 服务器保留在项目目录：`D:\Projects\playwright-browser-skill\dist\mcp-server.js`

### 截图和文件输出路径

默认情况下，截图和 PDF 会保存到项目根目录：

```
D:\Projects\playwright-browser-skill\
├── screenshot.png
├── test.pdf
└── videos\
    └── recording.webm
```

可以在调用时指定完整路径：

```typescript
await browser.screenshot({ 
  path: 'D:\\output\\screenshot.png' 
});
```

## 🔒 防火墙和安全设置

### Windows Defender

首次运行时，Windows Defender 可能会提示：

1. 点击"允许访问"
2. 或者添加例外规则：
   - 打开 Windows 安全中心
   - 病毒和威胁防护 → 管理设置
   - 添加排除项 → 文件夹
   - 选择项目目录

### 网络访问

Playwright 需要网络访问来：
- 下载浏览器二进制文件
- 访问网页
- 下载资源

确保防火墙允许 Node.js 和浏览器进程访问网络。

## 🎯 性能优化

### 1. 使用 SSD

将项目和浏览器二进制文件放在 SSD 上可以显著提升启动速度。

### 2. 关闭不必要的浏览器

如果只使用 Chromium：

```cmd
npx playwright install chromium
```

### 3. 使用无头模式

在配置中启用无头模式以提高性能：

```json
{
  "browserType": "chromium",
  "headless": true
}
```

### 4. 调整超时设置

对于慢速网络，增加超时时间：

```typescript
await browser.goto('https://example.com', { 
  timeout: 60000 
});
```

## 🔄 更新和维护

### 更新依赖

```cmd
npm update
```

### 更新浏览器

```cmd
npx playwright install --force
```

### 清理构建

```cmd
rmdir /s /q dist
npm run build
```

## 📊 系统资源使用

### 磁盘空间

- 项目文件：约 50MB
- 浏览器二进制文件：约 300MB（全部三个浏览器）
- Node modules：约 100MB

### 内存使用

- 无头模式：约 200-300MB
- 有头模式：约 400-600MB
- 多页面：每个页面额外 50-100MB

### CPU 使用

- 空闲时：< 5%
- 页面加载：20-40%
- JavaScript 密集操作：40-80%

## 🛠️ 开发模式

### 监听文件变化

```cmd
npm run dev
```

这将启动 TypeScript 编译器的监听模式，自动重新编译修改的文件。

### 调试模式

启动浏览器时使用非无头模式：

```typescript
await browser.launch({ 
  headless: false,
  slowMo: 100  // 减慢操作速度以便观察
});
```

## 📝 环境变量

可以设置以下环境变量：

```cmd
# 设置浏览器下载路径
setx PLAYWRIGHT_BROWSERS_PATH "D:\Browsers"

# 跳过浏览器下载（如果已安装）
setx PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD "1"

# 设置代理
setx HTTP_PROXY "http://proxy.example.com:8080"
setx HTTPS_PROXY "http://proxy.example.com:8080"
```

## 🔗 相关资源

- [Playwright 官方文档](https://playwright.dev/)
- [Node.js 官网](https://nodejs.org/)
- [OpenClaw 文档](https://openclaw.ai/)
- [MCP 协议规范](https://modelcontextprotocol.io/)

## 📞 获取帮助

如果遇到问题：

1. 查看本指南的"常见问题"部分
2. 检查项目的 GitHub Issues
3. 查看 Playwright 官方文档
4. 在社区论坛提问

## ✅ 验证清单

安装完成后，请确认：

- [ ] Node.js 已安装（`node --version`）
- [ ] 依赖已安装（`npm install`）
- [ ] 浏览器已下载（`npx playwright install`）
- [ ] 项目已构建（`npm run build`）
- [ ] 基础测试通过（`npm run test:basic`）
- [ ] MCP 配置正确（检查 `mcp.json`）
- [ ] Skill 文件已复制（检查 `~/.openclaw/skills/`）
- [ ] OpenClaw 可以识别 skill

## 🎉 完成

恭喜！你已经成功在 Windows 上部署了 Playwright Browser Skill。现在可以在 OpenClaw 中使用强大的浏览器自动化功能了！
