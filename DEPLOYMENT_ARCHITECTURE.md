# 部署架构说明

## 📁 文件部署架构

### 完整部署结构

```
┌─────────────────────────────────────────────────────────────┐
│                    Windows 文件系统                          │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  项目目录（例如：D:\Projects\playwright-browser-skill\）      │
├─────────────────────────────────────────────────────────────┤
│  ├── src/                    ← 源代码                        │
│  │   ├── index.ts                                           │
│  │   ├── mcp-server.ts                                      │
│  │   ├── tool-handlers.ts                                   │
│  │   └── tools-registry.ts                                  │
│  │                                                           │
│  ├── dist/                   ← 构建输出（npm run build）     │
│  │   ├── mcp-server.js       ← MCP 服务器（被 OpenClaw 调用）│
│  │   ├── index.js                                           │
│  │   ├── tool-handlers.js                                   │
│  │   └── tools-registry.js                                  │
│  │                                                           │
│  ├── test/                   ← 测试文件                      │
│  │   ├── basic-test.ts                                      │
│  │   └── ...                                                │
│  │                                                           │
│  ├── .kiro/                  ← 项目级配置（模板）            │
│  │   └── skills/                                            │
│  │       └── playwright-browser.md  ← Skill 定义（源文件）   │
│  │                                                           │
│  ├── node_modules/           ← 依赖包                        │
│  ├── package.json            ← 项目配置                      │
│  ├── tsconfig.json           ← TypeScript 配置               │
│  ├── test-windows.ps1        ← Windows 测试脚本              │
│  ├── test-windows.cmd        ← Windows 测试脚本              │
│  └── *.md                    ← 文档文件                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ 复制 Skill 文件
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  OpenClaw 配置目录（C:\Users\你的用户名.openclaw\）              │
├─────────────────────────────────────────────────────────────┤
│  ├── settings/               ← OpenClaw 设置                 │
│  │   └── mcp.json            ← MCP 服务器配置（手动创建/编辑）│
│  │                                                           │
│  └── skills/                 ← OpenClaw Skills               │
│      └── playwright-browser.md  ← Skill 定义（复制到这里）   │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 部署流程

### 步骤 1：项目设置

在项目目录（如 `D:\Projects\playwright-browser-skill\`）：

```cmd
# 1. 安装依赖
npm install

# 2. 下载浏览器
npx playwright install

# 3. 构建项目
npm run build
```

**结果**：生成 `dist/` 目录，包含 `mcp-server.js`

### 步骤 2：配置 OpenClaw

#### 2.1 创建 MCP 配置

在 `%USERPROFILE%.openclaw\settings\mcp.json` 创建或编辑：

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

**关键点**：
- `args` 指向**项目目录**的 `dist/mcp-server.js`
- 使用完整的绝对路径
- 使用双反斜杠 `\\` 或单正斜杠 `/`

#### 2.2 复制 Skill 文件

```cmd
# 确保目标目录存在
if not exist "%USERPROFILE%.openclaw\skills" mkdir "%USERPROFILE%.openclaw\skills"

# 从项目目录复制到 OpenClaw 配置目录
copy D:\Projects\playwright-browser-skill.openclaw\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

### 步骤 3：重启 OpenClaw

关闭并重新启动 OpenClaw，使配置生效。

## 📊 文件关系图

```
┌──────────────────┐
│   OpenClaw IDE   │
└────────┬─────────┘
         │
         │ 读取配置
         ▼
┌──────────────────────────────────┐
│  %USERPROFILE%.openclaw\            │
│  ├── settings/mcp.json           │  ← 配置 MCP 服务器路径
│  └── skills/playwright-browser.md│  ← 定义 Skill 能力
└──────────┬───────────────────────┘
           │
           │ 启动 MCP 服务器
           ▼
┌──────────────────────────────────┐
│  项目目录\dist\mcp-server.js      │  ← MCP 服务器进程
└──────────┬───────────────────────┘
           │
           │ 调用 Playwright API
           ▼
┌──────────────────────────────────┐
│  Playwright Browser              │  ← 浏览器自动化
└──────────────────────────────────┘
```

## 🎯 关键理解

### 1. 项目目录 vs OpenClaw 配置目录

| 目录 | 用途 | 内容 |
|------|------|------|
| **项目目录** | 开发和运行 | 源代码、构建输出、依赖、文档 |
| **OpenClaw 配置目录** | OpenClaw 配置 | MCP 配置、Skill 定义 |

### 2. 为什么要分开？

- **项目目录**：包含完整的代码和依赖，可以独立开发和测试
- **OpenClaw 配置目录**：只包含 OpenClaw 需要的配置文件，保持简洁

### 3. MCP 服务器的位置

MCP 服务器（`mcp-server.js`）**保留在项目目录**：
- OpenClaw 通过 `mcp.json` 中的路径找到它
- 服务器运行时可以访问项目的所有依赖（`node_modules`）

### 4. Skill 文件的位置

Skill 文件需要**复制到 OpenClaw 配置目录**：
- OpenClaw 从 `%USERPROFILE%.openclaw\skills\` 读取 Skill 定义
- 这样 OpenClaw 知道有哪些 Skill 可用

## 📝 配置文件详解

### mcp.json 配置

```json
{
  "mcpServers": {
    "playwright-browser": {           // ← Skill 名称
      "command": "node",               // ← 运行命令
      "args": [                        // ← 命令参数
        "D:\\Projects\\playwright-browser-skill\\dist\\mcp-server.js"
        // ↑ 指向项目目录的 MCP 服务器
      ],
      "disabled": false,               // ← 是否启用
      "autoApprove": [                 // ← 自动批准的工具
        "browser_launch",
        "browser_goto",
        "browser_close"
      ]
    }
  }
}
```

**位置**：`C:\Users\你的用户名.openclaw\settings\mcp.json`

### playwright-browser.md (Skill 定义)

这个文件定义了 Skill 的元数据和描述：

```markdown
---
name: playwright-browser-skill
description: OpenClaw 技能，用于浏览器自动化...
---

# Playwright 浏览器自动化技能
...
```

**源位置**：`项目目录.openclaw\skills\playwright-browser.md`  
**目标位置**：`C:\Users\你的用户名.openclaw\skills\playwright-browser.md`

## 🔍 验证部署

### 检查项目目录

```cmd
cd D:\Projects\playwright-browser-skill

# 检查构建输出
dir dist\mcp-server.js

# 检查 Skill 源文件
dir .kiro\skills\playwright-browser.md
```

### 检查 OpenClaw 配置目录

```cmd
# 检查 MCP 配置
type %USERPROFILE%.openclaw\settings\mcp.json

# 检查 Skill 文件
dir %USERPROFILE%.openclaw\skills\playwright-browser.md
```

### 测试 MCP 服务器

```cmd
# 直接运行 MCP 服务器（应该启动无错误）
node D:\Projects\playwright-browser-skill\dist\mcp-server.js
```

按 `Ctrl+C` 停止。

## 🐛 常见错误

### 错误 1：找不到 mcp-server.js

**错误信息**：
```
Cannot find module 'D:\...\dist\mcp-server.js'
```

**原因**：
- `mcp.json` 中的路径不正确
- 或者项目没有构建（`npm run build`）

**解决**：
1. 确认项目已构建：`npm run build`
2. 检查 `mcp.json` 中的路径是否正确
3. 使用绝对路径

### 错误 2：OpenClaw 找不到 Skill

**原因**：
- Skill 文件没有复制到 `%USERPROFILE%.openclaw\skills\`

**解决**：
```cmd
copy 项目目录.openclaw\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

### 错误 3：MCP 服务器启动失败

**原因**：
- 依赖没有安装
- Node.js 版本不兼容

**解决**：
1. 在项目目录运行：`npm install`
2. 检查 Node.js 版本：`node --version`（需要 >= 18.0.0）

## 📋 部署检查清单

- [ ] 项目目录已创建
- [ ] 依赖已安装（`npm install`）
- [ ] 浏览器已下载（`npx playwright install`）
- [ ] 项目已构建（`npm run build`）
- [ ] `dist/mcp-server.js` 存在
- [ ] OpenClaw 配置目录存在（`%USERPROFILE%.openclaw\`）
- [ ] `mcp.json` 已创建并配置正确
- [ ] Skill 文件已复制到 `%USERPROFILE%.openclaw\skills\`
- [ ] OpenClaw 已重启
- [ ] 测试成功

## 🎉 总结

**记住这个简单的规则**：

1. **项目文件**（代码、构建输出）→ 保留在项目目录
2. **MCP 配置**（`mcp.json`）→ 放在 `%USERPROFILE%.openclaw\settings\`
3. **Skill 定义**（`playwright-browser.md`）→ 复制到 `%USERPROFILE%.openclaw\skills\`

这样 OpenClaw 就能找到配置，并通过配置找到 MCP 服务器，从而使用 Playwright 功能！
