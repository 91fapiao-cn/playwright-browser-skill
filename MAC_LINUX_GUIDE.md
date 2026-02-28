# Mac/Linux 部署指南

本指南专门针对 macOS 和 Linux 用户，提供详细的部署和使用说明。

[English Version](#english-version) | 中文版本

---

## 中文版本

### 系统要求

- macOS 10.15+ 或 Linux (Ubuntu 18.04+, Debian 10+, Fedora 30+, 等)
- Node.js 18.0.0 或更高版本
- npm 或 yarn
- Bash shell

### 快速开始

#### 1. 克隆项目

```bash
git clone https://github.com/91fapiao-cn/playwright-browser-skill.git
cd playwright-browser-skill
```

#### 2. 安装依赖

```bash
npm install
```

#### 3. 安装浏览器驱动

```bash
npm run install-browsers
```

这将安装 Chromium、Firefox 和 WebKit 浏览器。

#### 4. 一键部署

```bash
# 添加执行权限
chmod +x auto-deploy.sh

# 运行部署脚本（中文版）
./auto-deploy.sh

# 或使用英文版
chmod +x auto-deploy-en.sh
./auto-deploy-en.sh
```

### 部署选项

#### 基本部署

```bash
./auto-deploy.sh
```

这将：
1. 构建项目
2. 自动检测 OpenClaw 配置路径
3. 部署 Skill 文件
4. 配置 MCP 服务器
5. 备份现有配置

#### 跳过构建

如果已经构建过项目：

```bash
./auto-deploy.sh --skip-build
```

#### 指定自定义路径

```bash
./auto-deploy.sh --openclaw-path "/custom/path/.openclaw"
```

#### 查看帮助

```bash
./auto-deploy.sh --help
```

### 配置路径

脚本会自动检测以下路径：

1. `~/.openclaw` (OpenClaw 默认)
2. `~/.kiro` (Kiro 默认)
3. `~/Library/Application Support/openclaw` (macOS)
4. `~/Library/Application Support/kiro` (macOS)

如果未找到，将使用 `~/.openclaw` 作为默认路径。

### 手动部署

如果需要手动部署，请按以下步骤操作：

#### 1. 构建项目

```bash
npm run build
```

#### 2. 复制 Skill 文件

```bash
mkdir -p ~/.openclaw/skills/playwright-browser
cp skill-package/skills/playwright-browser.md ~/.openclaw/skills/playwright-browser/
```

#### 3. 配置 MCP 服务器

编辑 `~/.openclaw/settings/mcp.json`：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["/path/to/playwright-browser-skill/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close"
      ]
    }
  }
}
```

**注意：** 将 `/path/to/playwright-browser-skill` 替换为实际的项目路径。

#### 4. 重启 OpenClaw

```bash
# 如果使用 systemd
sudo systemctl restart openclaw

# 或手动重启应用
```

### 验证部署

#### 1. 检查文件

```bash
# 检查 Skill 文件
ls -la ~/.openclaw/skills/playwright-browser/playwright-browser.md

# 检查 MCP 配置
cat ~/.openclaw/settings/mcp.json

# 检查构建产物
ls -la dist/mcp-server.js
```

#### 2. 测试 MCP 服务器

```bash
# 测试服务器启动
node dist/mcp-server.js
```

应该看到类似输出：
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

按 `Ctrl+C` 停止测试。

#### 3. 在 OpenClaw 中测试

启动 OpenClaw，在聊天中输入：

```
启动浏览器并访问 example.com
```

或使用英文：

```
Launch browser and visit example.com
```

### 常见问题

#### 问题 1：权限被拒绝

**错误：**
```
bash: ./auto-deploy.sh: Permission denied
```

**解决方案：**
```bash
chmod +x auto-deploy.sh
./auto-deploy.sh
```

#### 问题 2：Node.js 版本过低

**错误：**
```
Error: Node.js version 18.0.0 or higher is required
```

**解决方案：**

使用 nvm 安装最新版本：

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重新加载 shell
source ~/.bashrc  # 或 ~/.zshrc

# 安装 Node.js 18+
nvm install 18
nvm use 18
```

或使用包管理器：

```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Fedora
sudo dnf install nodejs
```

#### 问题 3：浏览器安装失败

**错误：**
```
Failed to install browsers
```

**解决方案：**

```bash
# 手动安装浏览器
npx playwright install

# 或只安装 Chromium
npx playwright install chromium

# 安装系统依赖（Linux）
npx playwright install-deps
```

#### 问题 4：找不到 OpenClaw 配置目录

**解决方案：**

手动指定路径：

```bash
./auto-deploy.sh --openclaw-path "$HOME/.openclaw"
```

或创建目录：

```bash
mkdir -p ~/.openclaw/settings
mkdir -p ~/.openclaw/skills
```

#### 问题 5：MCP 服务器无法启动

**检查步骤：**

1. 验证 Node.js 版本：
```bash
node --version  # 应该 >= 18.0.0
```

2. 检查构建产物：
```bash
ls -la dist/mcp-server.js
```

3. 查看错误日志：
```bash
node dist/mcp-server.js 2>&1 | tee mcp-error.log
```

4. 检查依赖：
```bash
npm install
npm run build
```

### 无头模式配置

#### 开发环境（有界面）

```javascript
browser_launch({ 
  "headless": false,
  "slowMo": 50  // 减慢操作，便于观察
})
```

#### 生产环境（无头模式）

```javascript
browser_launch({ 
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--no-sandbox"
  ]
})
```

#### 服务器环境

在无图形界面的服务器上，必须使用无头模式：

```javascript
browser_launch({
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage"
  ]
})
```

### 性能优化

#### 1. 使用无头模式

```bash
# 在环境变量中设置
export PLAYWRIGHT_HEADLESS=true
```

#### 2. 限制浏览器资源

```javascript
browser_launch({
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--disable-extensions",
    "--disable-background-networking"
  ]
})
```

#### 3. 使用 SSD 存储

确保项目和浏览器缓存在 SSD 上，可以显著提升性能。

### 卸载

如果需要卸载：

```bash
# 1. 删除 Skill 文件
rm -rf ~/.openclaw/skills/playwright-browser

# 2. 从 MCP 配置中移除
# 编辑 ~/.openclaw/settings/mcp.json
# 删除 "playwright-browser" 部分

# 3. 删除项目文件
cd ..
rm -rf playwright-browser-skill

# 4. 卸载浏览器（可选）
npx playwright uninstall
```

### 更新

更新到最新版本：

```bash
# 1. 拉取最新代码
git pull origin main

# 2. 更新依赖
npm install

# 3. 重新构建
npm run build

# 4. 重新部署
./auto-deploy.sh --skip-build
```

---

## English Version

### System Requirements

- macOS 10.15+ or Linux (Ubuntu 18.04+, Debian 10+, Fedora 30+, etc.)
- Node.js 18.0.0 or higher
- npm or yarn
- Bash shell

### Quick Start

#### 1. Clone Project

```bash
git clone https://github.com/91fapiao-cn/playwright-browser-skill.git
cd playwright-browser-skill
```

#### 2. Install Dependencies

```bash
npm install
```

#### 3. Install Browser Drivers

```bash
npm run install-browsers
```

This will install Chromium, Firefox, and WebKit browsers.

#### 4. One-Click Deploy

```bash
# Add execute permission
chmod +x auto-deploy-en.sh

# Run deployment script (English version)
./auto-deploy-en.sh

# Or use Chinese version
chmod +x auto-deploy.sh
./auto-deploy.sh
```

### Deployment Options

#### Basic Deployment

```bash
./auto-deploy-en.sh
```

This will:
1. Build the project
2. Auto-detect OpenClaw configuration path
3. Deploy Skill file
4. Configure MCP server
5. Backup existing configuration

#### Skip Build

If project is already built:

```bash
./auto-deploy-en.sh --skip-build
```

#### Specify Custom Path

```bash
./auto-deploy-en.sh --openclaw-path "/custom/path/.openclaw"
```

#### Show Help

```bash
./auto-deploy-en.sh --help
```

### Configuration Paths

The script will auto-detect the following paths:

1. `~/.openclaw` (OpenClaw default)
2. `~/.kiro` (Kiro default)
3. `~/Library/Application Support/openclaw` (macOS)
4. `~/Library/Application Support/kiro` (macOS)

If not found, `~/.openclaw` will be used as the default path.

### Manual Deployment

If manual deployment is needed, follow these steps:

#### 1. Build Project

```bash
npm run build
```

#### 2. Copy Skill File

```bash
mkdir -p ~/.openclaw/skills/playwright-browser
cp skill-package/skills/playwright-browser.md ~/.openclaw/skills/playwright-browser/
```

#### 3. Configure MCP Server

Edit `~/.openclaw/settings/mcp.json`:

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["/path/to/playwright-browser-skill/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close"
      ]
    }
  }
}
```

**Note:** Replace `/path/to/playwright-browser-skill` with the actual project path.

#### 4. Restart OpenClaw

```bash
# If using systemd
sudo systemctl restart openclaw

# Or manually restart the application
```

### Verify Deployment

#### 1. Check Files

```bash
# Check Skill file
ls -la ~/.openclaw/skills/playwright-browser/playwright-browser.md

# Check MCP configuration
cat ~/.openclaw/settings/mcp.json

# Check build artifact
ls -la dist/mcp-server.js
```

#### 2. Test MCP Server

```bash
# Test server startup
node dist/mcp-server.js
```

You should see output similar to:
```
Playwright Browser MCP Server v2.1 started
Registered 101 tools, covering 100% browser automation scenarios
```

Press `Ctrl+C` to stop the test.

#### 3. Test in OpenClaw

Start OpenClaw and type in chat:

```
Launch browser and visit example.com
```

### Troubleshooting

#### Issue 1: Permission Denied

**Error:**
```
bash: ./auto-deploy-en.sh: Permission denied
```

**Solution:**
```bash
chmod +x auto-deploy-en.sh
./auto-deploy-en.sh
```

#### Issue 2: Node.js Version Too Low

**Error:**
```
Error: Node.js version 18.0.0 or higher is required
```

**Solution:**

Install latest version using nvm:

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.bashrc  # or ~/.zshrc

# Install Node.js 18+
nvm install 18
nvm use 18
```

Or use package manager:

```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Fedora
sudo dnf install nodejs
```

#### Issue 3: Browser Installation Failed

**Error:**
```
Failed to install browsers
```

**Solution:**

```bash
# Manually install browsers
npx playwright install

# Or install only Chromium
npx playwright install chromium

# Install system dependencies (Linux)
npx playwright install-deps
```

#### Issue 4: OpenClaw Config Directory Not Found

**Solution:**

Manually specify path:

```bash
./auto-deploy-en.sh --openclaw-path "$HOME/.openclaw"
```

Or create directory:

```bash
mkdir -p ~/.openclaw/settings
mkdir -p ~/.openclaw/skills
```

#### Issue 5: MCP Server Cannot Start

**Check Steps:**

1. Verify Node.js version:
```bash
node --version  # Should be >= 18.0.0
```

2. Check build artifact:
```bash
ls -la dist/mcp-server.js
```

3. View error logs:
```bash
node dist/mcp-server.js 2>&1 | tee mcp-error.log
```

4. Check dependencies:
```bash
npm install
npm run build
```

### Headless Mode Configuration

#### Development Environment (Headed)

```javascript
browser_launch({ 
  "headless": false,
  "slowMo": 50  // Slow down for observation
})
```

#### Production Environment (Headless)

```javascript
browser_launch({ 
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--no-sandbox"
  ]
})
```

#### Server Environment

On servers without GUI, headless mode is required:

```javascript
browser_launch({
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage"
  ]
})
```

### Performance Optimization

#### 1. Use Headless Mode

```bash
# Set in environment variable
export PLAYWRIGHT_HEADLESS=true
```

#### 2. Limit Browser Resources

```javascript
browser_launch({
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--disable-extensions",
    "--disable-background-networking"
  ]
})
```

#### 3. Use SSD Storage

Ensure project and browser cache are on SSD for significant performance improvement.

### Uninstall

To uninstall:

```bash
# 1. Remove Skill file
rm -rf ~/.openclaw/skills/playwright-browser

# 2. Remove from MCP configuration
# Edit ~/.openclaw/settings/mcp.json
# Delete "playwright-browser" section

# 3. Remove project files
cd ..
rm -rf playwright-browser-skill

# 4. Uninstall browsers (optional)
npx playwright uninstall
```

### Update

Update to latest version:

```bash
# 1. Pull latest code
git pull origin main

# 2. Update dependencies
npm install

# 3. Rebuild
npm run build

# 4. Redeploy
./auto-deploy-en.sh --skip-build
```

## 相关文档 / Related Documentation

- [配置指南 / Configuration Guide](CONFIGURATION_GUIDE.md)
- [自动部署指南 / Auto-Deploy Guide](AUTO_DEPLOY_README.md) | [English](AUTO_DEPLOY_README_EN.md)
- [Windows 指南 / Windows Guide](WINDOWS_GUIDE.md)
- [API 文档 / API Documentation](API.md)
- [架构说明 / Architecture](ARCHITECTURE.md)
