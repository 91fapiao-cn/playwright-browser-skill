# 正确的路径说明 ✅

## 🎯 重要澄清

OpenClaw 的配置目录是 `.openclaw`，不是 `.kiro`！

## 📁 正确的目录结构

### 1️⃣ 项目目录（你的项目位置）

例如：`D:\Projects\playwright-browser-skill\`

```
D:\Projects\playwright-browser-skill\
├── dist\
│   └── mcp-server.js          ← MCP 服务器（保留在这里）
├── src\
├── node_modules\
├── .kiro\                      ← 项目内部目录（保持不变）
│   └── skills\
│       └── playwright-browser.md  ← Skill 模板文件（需要复制）
└── package.json
```

**注意**：项目内的 `.kiro` 目录是项目的一部分，保持不变。

### 2️⃣ OpenClaw 配置目录（固定位置）

位置：`C:\Users\你的用户名\.openclaw\`

```
C:\Users\你的用户名\.openclaw\
├── settings\
│   └── mcp.json               ← MCP 配置（在这里编辑）
└── skills\
    └── playwright-browser.md  ← Skill 文件（复制到这里）
```

**这是关键**：OpenClaw 的配置目录是 `.openclaw`！

## 🔄 正确的部署步骤

### 步骤 1：构建项目

在项目目录：

```cmd
npm install
npx playwright install
npm run build
```

### 步骤 2：配置 OpenClaw MCP

创建或编辑：`%USERPROFILE%\.openclaw\settings\mcp.json`

完整路径：`C:\Users\你的用户名\.openclaw\settings\mcp.json`

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

### 步骤 3：复制 Skill 文件

从项目目录复制到 OpenClaw 配置目录：

```cmd
REM 确保目标目录存在
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"

REM 复制 Skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

**注意**：
- **源文件**：项目目录的 `.kiro\skills\playwright-browser.md`（项目内部）
- **目标位置**：`%USERPROFILE%\.openclaw\skills\playwright-browser.md`（OpenClaw 配置）

### 步骤 4：重启 OpenClaw

## 📊 路径对照表

| 用途 | 错误路径 ❌ | 正确路径 ✅ |
|------|-----------|-----------|
| MCP 配置 | `%USERPROFILE%\.kiro\settings\mcp.json` | `%USERPROFILE%\.openclaw\settings\mcp.json` |
| Skill 目录 | `%USERPROFILE%\.kiro\skills\` | `%USERPROFILE%\.openclaw\skills\` |
| Skill 文件 | `%USERPROFILE%\.kiro\skills\playwright-browser.md` | `%USERPROFILE%\.openclaw\skills\playwright-browser.md` |
| 项目 Skill 模板 | `.kiro\skills\playwright-browser.md` | `.kiro\skills\playwright-browser.md`（保持不变） |

## ✅ 验证命令

### 检查 OpenClaw 配置目录

```cmd
REM 检查 MCP 配置
type %USERPROFILE%\.openclaw\settings\mcp.json

REM 检查 Skill 文件
dir %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

### 检查项目目录

```cmd
REM 进入项目目录
cd D:\Projects\playwright-browser-skill

REM 检查 MCP 服务器
dir dist\mcp-server.js

REM 检查 Skill 模板
dir .kiro\skills\playwright-browser.md
```

## 🎨 可视化流程

```
┌─────────────────────────────────────────┐
│  项目目录                                │
│  D:\Projects\playwright-browser-skill\  │
│  ├── dist\mcp-server.js                 │
│  └── .kiro\skills\                      │
│      └── playwright-browser.md          │
│          (Skill 模板)                   │
└──────────────┬──────────────────────────┘
               │
               │ 复制 Skill 文件
               ▼
┌─────────────────────────────────────────┐
│  OpenClaw 配置目录                       │
│  C:\Users\你的用户名\.openclaw\          │
│  ├── settings\mcp.json                  │
│  │   (配置指向项目的 mcp-server.js)     │
│  └── skills\                            │
│      └── playwright-browser.md          │
│          (复制到这里)                   │
└─────────────────────────────────────────┘
```

## 🐛 常见错误

### 错误 1：使用了 .kiro 而不是 .openclaw

❌ 错误：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.kiro\skills\
```

✅ 正确：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

### 错误 2：MCP 配置路径错误

❌ 错误：
```
C:\Users\你的用户名\.kiro\settings\mcp.json
```

✅ 正确：
```
C:\Users\你的用户名\.openclaw\settings\mcp.json
```

## 📝 快速参考

### 一键复制命令（正确版本）

```cmd
REM 确保 OpenClaw 配置目录存在
if not exist "%USERPROFILE%\.openclaw\settings" mkdir "%USERPROFILE%\.openclaw\settings"
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"

REM 从项目目录复制 Skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\

REM 验证复制成功
dir %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

### 创建 MCP 配置（正确版本）

```cmd
REM 创建配置文件（需要手动编辑内容）
notepad %USERPROFILE%\.openclaw\settings\mcp.json
```

然后粘贴配置内容。

## 🎉 总结

**记住**：

1. **项目内部**：`.kiro\` 目录（保持不变）
2. **OpenClaw 配置**：`.openclaw\` 目录（这是关键！）

**正确的复制命令**：

```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

**正确的配置路径**：

```
%USERPROFILE%\.openclaw\settings\mcp.json
```

---

**感谢指正！** 现在所有文档都已更新为正确的 `.openclaw` 路径。🎊
