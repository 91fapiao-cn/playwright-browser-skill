# 自动部署脚本使用指南

本项目提供了三个自动部署脚本，可以自动检测 OpenClaw 配置路径并完成完整部署。

[English Version](AUTO_DEPLOY_README_EN.md)

## 脚本列表

| 脚本文件 | 平台 | 说明 |
|---------|------|------|
| `auto-deploy.ps1` | Windows (PowerShell) | 推荐用于 Windows，功能最完整 |
| `auto-deploy.cmd` | Windows (CMD) | Windows 批处理版本 |
| `auto-deploy.sh` | Mac/Linux | Unix 系统使用 |

## 功能特性

✅ 自动检测 OpenClaw 配置路径  
✅ 自动构建项目（可选跳过）  
✅ 自动创建必要的目录结构  
✅ 自动部署 Skill 文件  
✅ 自动配置 MCP 服务器  
✅ 备份现有配置（如果存在）  
✅ 支持自定义安装路径  

## 使用方法

### Windows (PowerShell) - 推荐

```powershell
# 默认部署（自动检测路径 + 构建项目）
.\auto-deploy.ps1

# 跳过构建（如果已经构建过）
.\auto-deploy.ps1 -SkipBuild

# 指定自定义 OpenClaw 路径
.\auto-deploy.ps1 -OpenClawPath "C:\custom\path\.openclaw"

# 组合使用
.\auto-deploy.ps1 -SkipBuild -OpenClawPath "D:\MyApps\.kiro"
```

### Windows (CMD)

```cmd
REM 默认部署
auto-deploy.cmd

REM 跳过构建
auto-deploy.cmd --skip-build

REM 指定自定义路径
auto-deploy.cmd --openclaw-path "C:\custom\path\.openclaw"

REM 查看帮助
auto-deploy.cmd --help
```

### Mac/Linux

```bash
# 添加执行权限（首次使用）
chmod +x auto-deploy.sh

# 默认部署
./auto-deploy.sh

# 跳过构建
./auto-deploy.sh --skip-build

# 指定自定义路径
./auto-deploy.sh --openclaw-path "/custom/path/.openclaw"

# 查看帮助
./auto-deploy.sh --help
```

## 自动检测路径

脚本会按以下顺序自动检测 OpenClaw 配置路径：

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

如果未找到现有配置，将使用默认路径：
- Windows: `%USERPROFILE%\.openclaw`
- Mac/Linux: `~/.openclaw`

## 部署流程

脚本会自动执行以下步骤：

1. **检查项目环境** - 确认在正确的项目目录
2. **构建项目** - 运行 `npm run build`（可选跳过）
3. **检测配置路径** - 自动查找或使用指定路径
4. **创建目录结构** - 创建必要的目录
5. **部署 Skill 文件** - 复制 skill 文件到目标位置
6. **配置 MCP 服务器** - 创建或更新 mcp.json

## 配置备份

如果检测到现有的 `mcp.json` 配置文件，脚本会：

1. 自动创建备份文件（带时间戳）
2. 合并新配置到现有配置（PowerShell 和 Shell 脚本）
3. 或提示手动合并（CMD 脚本）

备份文件格式：`mcp.json.backup.YYYYMMDD-HHMMSS`

## 部署后步骤

部署完成后，需要：

1. **重启 OpenClaw**
2. **验证 MCP 服务器状态**
   - 打开 MCP 服务器面板
   - 确认 `playwright-browser` 显示为已连接
3. **测试功能**
   - 在聊天中输入：`启动浏览器并访问 example.com`
   - 或使用其他浏览器相关命令

## 故障排查

### 问题：脚本提示"请在项目根目录运行"

**解决方案：**
```bash
# 确保在项目根目录（包含 .kiro 文件夹的目录）
cd /path/to/playwright-browser-mcp
```

### 问题：构建失败

**解决方案：**
```bash
# 先手动安装依赖
npm install

# 然后重新运行部署脚本
```

### 问题：找不到 OpenClaw 配置目录

**解决方案：**
```bash
# 使用 --openclaw-path 参数指定路径
./auto-deploy.sh --openclaw-path "/your/custom/path"
```

### 问题：PowerShell 执行策略限制

**解决方案：**
```powershell
# 临时允许执行脚本
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 然后运行脚本
.\auto-deploy.ps1
```

### 问题：Mac/Linux 权限不足

**解决方案：**
```bash
# 添加执行权限
chmod +x auto-deploy.sh

# 如果需要写入系统目录，使用 sudo
sudo ./auto-deploy.sh
```

## 手动验证部署

部署完成后，可以手动验证以下文件：

### Skill 文件
```
Windows: %USERPROFILE%\.openclaw\skills\playwright-browser-skill\SKILL.md
Mac/Linux: ~/.openclaw/skills/playwright-browser-skill/SKILL.md
```

### MCP 配置
```
Windows: %USERPROFILE%\.openclaw\settings\mcp.json
Mac/Linux: ~/.openclaw/settings/mcp.json
```

### MCP 服务器
```
项目目录/dist/mcp-server.js
```

## 与旧脚本的对比

| 功能 | 旧脚本 | 新脚本 (auto-deploy) |
|------|--------|---------------------|
| 自动检测路径 | ❌ | ✅ |
| 自动构建 | ❌ | ✅ |
| 配置合并 | ❌ | ✅ |
| 自动备份 | ❌ | ✅ |
| 跨平台支持 | 部分 | ✅ |
| 自定义路径 | ❌ | ✅ |
| 错误处理 | 基础 | 完善 |

## 高级用法

### 批量部署到多个环境

```bash
# 部署到开发环境
./auto-deploy.sh --openclaw-path ~/.openclaw-dev

# 部署到测试环境
./auto-deploy.sh --openclaw-path ~/.openclaw-test

# 部署到生产环境
./auto-deploy.sh --openclaw-path ~/.openclaw-prod
```

### CI/CD 集成

```yaml
# GitHub Actions 示例
- name: Deploy to OpenClaw
  run: |
    npm install
    ./auto-deploy.sh --skip-build
```

### 开发工作流

```bash
# 开发时快速重新部署（跳过构建）
npm run build && ./auto-deploy.sh --skip-build
```

## 相关文档

- [部署架构](DEPLOYMENT_ARCHITECTURE.md)
- [Windows 兼容性指南](WINDOWS_COMPATIBILITY.md)
- [项目 API 文档](API.md)

## 支持

如有问题，请查看：
1. 本文档的故障排查部分
2. 项目的其他文档文件
3. 提交 Issue 到项目仓库
