# 正确的 Skill 目录结构（已确认）

## ✅ 确认的结构

OpenClaw 使用**每个 skill 一个文件夹**的结构：

```
C:\Users\你的用户名\.openclaw\
└── skills\
    └── playwright-browser\          ← Skill 文件夹
        └── playwright-browser.md    ← Skill 定义文件
```

## 📝 正确的部署命令

### Windows CMD

```cmd
REM 创建 skill 文件夹
if not exist "%USERPROFILE%\.openclaw\skills\playwright-browser" mkdir "%USERPROFILE%\.openclaw\skills\playwright-browser"

REM 复制 skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md

REM 验证
dir %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

### Windows PowerShell

```powershell
# 创建 skill 文件夹
if (-not (Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.openclaw\skills\playwright-browser" -Force
}

# 复制 skill 文件
Copy-Item .kiro\skills\playwright-browser.md "$env:USERPROFILE\.openclaw\skills\playwright-browser\playwright-browser.md"

# 验证
Get-Item "$env:USERPROFILE\.openclaw\skills\playwright-browser\playwright-browser.md"
```

## 🎯 完整的目录结构

```
项目目录 (D:\Projects\playwright-browser-skill\)
├── dist\
│   └── mcp-server.js                    ← MCP 服务器
├── .kiro\
│   └── skills\
│       └── playwright-browser.md        ← Skill 模板（源文件）
└── ...

OpenClaw 配置目录 (C:\Users\你的用户名\.openclaw\)
├── settings\
│   └── mcp.json                         ← MCP 配置
└── skills\
    └── playwright-browser\              ← Skill 文件夹
        └── playwright-browser.md        ← Skill 文件（复制到这里）
```

## 🔄 部署流程

### 1. 构建项目

```cmd
cd D:\Projects\playwright-browser-skill
npm install
npx playwright install
npm run build
```

### 2. 配置 MCP

创建 `%USERPROFILE%\.openclaw\settings\mcp.json`：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["D:\\Projects\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

### 3. 部署 Skill

```cmd
REM 确保目录存在
if not exist "%USERPROFILE%\.openclaw\skills\playwright-browser" mkdir "%USERPROFILE%\.openclaw\skills\playwright-browser"

REM 复制 skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

### 4. 重启 OpenClaw

## ✅ 验证部署

### 检查文件结构

```cmd
REM 检查 skill 文件夹
dir %USERPROFILE%\.openclaw\skills\

REM 应该看到 playwright-browser 文件夹

REM 检查 skill 文件
dir %USERPROFILE%\.openclaw\skills\playwright-browser\

REM 应该看到 playwright-browser.md 文件
```

### 检查文件内容

```cmd
type %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

应该看到 skill 定义的内容，包括 frontmatter。

## 📊 路径对照表

| 用途 | 路径 |
|------|------|
| 项目 Skill 模板 | `项目目录\.kiro\skills\playwright-browser.md` |
| OpenClaw Skill 文件夹 | `%USERPROFILE%\.openclaw\skills\playwright-browser\` |
| OpenClaw Skill 文件 | `%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md` |
| MCP 配置 | `%USERPROFILE%\.openclaw\settings\mcp.json` |
| MCP 服务器 | `项目目录\dist\mcp-server.js` |

## 🎨 可视化

```
┌─────────────────────────────────────────┐
│  项目目录                                │
│  .kiro\skills\                          │
│  └── playwright-browser.md              │
│      (Skill 模板)                       │
└──────────────┬──────────────────────────┘
               │
               │ 复制
               ▼
┌─────────────────────────────────────────┐
│  OpenClaw 配置目录                       │
│  %USERPROFILE%\.openclaw\skills\        │
│  └── playwright-browser\                │
│      └── playwright-browser.md          │
│          (Skill 文件)                   │
└─────────────────────────────────────────┘
```

## 🐛 常见错误

### 错误 1：直接复制到 skills 目录

❌ 错误：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

✅ 正确：
```cmd
mkdir %USERPROFILE%\.openclaw\skills\playwright-browser
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

### 错误 2：文件名不对

❌ 错误：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\skill.md
```

✅ 正确：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

文件名应该与 skill name 一致。

## 📝 一键部署脚本

### CMD 版本

```cmd
@echo off
echo 部署 Playwright Browser Skill...

REM 创建 skill 文件夹
if not exist "%USERPROFILE%\.openclaw\skills\playwright-browser" (
    echo 创建 skill 文件夹...
    mkdir "%USERPROFILE%\.openclaw\skills\playwright-browser"
)

REM 复制 skill 文件
echo 复制 skill 文件...
copy .kiro\skills\playwright-browser.md "%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md"

REM 验证
if exist "%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md" (
    echo ✓ Skill 文件部署成功！
    echo 位置: %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
) else (
    echo × Skill 文件部署失败！
)

pause
```

### PowerShell 版本

```powershell
Write-Host "部署 Playwright Browser Skill..." -ForegroundColor Cyan

# 创建 skill 文件夹
$skillDir = "$env:USERPROFILE\.openclaw\skills\playwright-browser"
if (-not (Test-Path $skillDir)) {
    Write-Host "创建 skill 文件夹..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
}

# 复制 skill 文件
Write-Host "复制 skill 文件..." -ForegroundColor Yellow
Copy-Item .kiro\skills\playwright-browser.md "$skillDir\playwright-browser.md"

# 验证
if (Test-Path "$skillDir\playwright-browser.md") {
    Write-Host "✓ Skill 文件部署成功！" -ForegroundColor Green
    Write-Host "位置: $skillDir\playwright-browser.md" -ForegroundColor White
} else {
    Write-Host "× Skill 文件部署失败！" -ForegroundColor Red
}

pause
```

## 🎉 总结

**正确的 Skill 部署结构**：

```
%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

**关键点**：
1. 每个 skill 有自己的文件夹
2. 文件夹名称与 skill name 一致
3. Skill 文件名也与 skill name 一致

---

**此结构已确认有效！** ✅
