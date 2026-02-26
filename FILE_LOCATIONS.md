# 文件位置快速参考 📍

## 🎯 一句话总结

**项目文件在项目目录，配置文件在 OpenClaw 配置目录（`%USERPROFILE%.openclaw\`）**

## 📁 两个重要目录

### 1️⃣ 项目目录（你选择的位置）

例如：`D:\Projects\playwright-browser-skill\`

```
D:\Projects\playwright-browser-skill\
├── dist\
│   └── mcp-server.js          ← MCP 服务器（保留在这里）
├── src\
├── node_modules\
├── .kiro\
│   └── skills\
│       └── playwright-browser.md  ← Skill 源文件（需要复制）
└── package.json
```

**用途**：开发、构建、运行 MCP 服务器

### 2️⃣ OpenClaw 配置目录（固定位置）

位置：`C:\Users\你的用户名.openclaw\`

```
C:\Users\你的用户名.openclaw\
├── settings\
│   └── mcp.json               ← MCP 配置（在这里编辑）
└── skills\
    └── playwright-browser.md  ← Skill 文件（复制到这里）
```

**用途**：OpenClaw 读取配置和 Skill 定义

## 🔄 需要做什么？

### ✅ 保留在项目目录

- 所有源代码（`src/`）
- 构建输出（`dist/`）
- 依赖包（`node_modules/`）
- 文档文件（`*.md`）
- 配置文件（`package.json`, `tsconfig.json`）

### 📋 复制到 OpenClaw 配置目录

#### 1. MCP 配置文件

**创建或编辑**：`%USERPROFILE%.openclaw\settings\mcp.json`

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["D:\\Projects\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false
    }
  }
}
```

**注意**：`args` 中的路径指向**项目目录**的 `dist/mcp-server.js`

#### 2. Skill 定义文件

**复制命令**：

```cmd
copy D:\Projects\playwright-browser-skill.openclaw\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

**源文件**：`项目目录.openclaw\skills\playwright-browser.md`  
**目标位置**：`%USERPROFILE%.openclaw\skills\playwright-browser.md`

## 🎨 可视化流程

```
┌─────────────────────────────────────────┐
│  1. 在项目目录构建                       │
│     npm run build                       │
│     ↓                                   │
│     生成 dist/mcp-server.js             │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  2. 配置 OpenClaw                       │
│     编辑 %USERPROFILE%.openclaw\           │
│          settings\mcp.json              │
│     ↓                                   │
│     指向项目目录的 mcp-server.js        │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  3. 复制 Skill 文件                     │
│     从项目目录.openclaw\skills\             │
│     到 %USERPROFILE%.openclaw\skills\      │
└─────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  4. 重启 OpenClaw                       │
│     OpenClaw 读取配置并启动 MCP 服务器  │
└─────────────────────────────────────────┘
```

## 📝 快速命令

### 检查项目目录

```cmd
REM 进入项目目录
cd D:\Projects\playwright-browser-skill

REM 检查 MCP 服务器是否存在
dir dist\mcp-server.js

REM 检查 Skill 源文件
dir .kiro\skills\playwright-browser.md
```

### 检查 OpenClaw 配置目录

```cmd
REM 检查 MCP 配置
type %USERPROFILE%.openclaw\settings\mcp.json

REM 检查 Skill 文件是否已复制
dir %USERPROFILE%.openclaw\skills\playwright-browser.md
```

### 一键复制 Skill 文件

```cmd
REM 确保目标目录存在
if not exist "%USERPROFILE%.openclaw\skills" mkdir "%USERPROFILE%.openclaw\skills"

REM 从项目目录复制（替换为你的实际路径）
copy D:\Projects\playwright-browser-skill.openclaw\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

## ❓ 常见问题

### Q1: 为什么要分两个目录？

**A**: 
- **项目目录**：包含完整的开发环境，可以独立开发和测试
- **OpenClaw 配置目录**：只包含 OpenClaw 需要的配置，保持简洁

### Q2: MCP 服务器为什么不复制到 OpenClaw 目录？

**A**: MCP 服务器需要访问项目的依赖（`node_modules`），所以必须保留在项目目录。OpenClaw 通过 `mcp.json` 中的路径找到它。

### Q3: 如果移动了项目目录怎么办？

**A**: 需要更新 `%USERPROFILE%.openclaw\settings\mcp.json` 中的路径，指向新的项目位置。

### Q4: Skill 文件需要每次都复制吗？

**A**: 只需要复制一次。除非你修改了 Skill 文件，否则不需要重新复制。

### Q5: 可以把项目目录放在 C 盘吗？

**A**: 可以，项目目录可以放在任何位置。只要在 `mcp.json` 中使用正确的绝对路径即可。

## ✅ 验证清单

部署完成后，检查以下内容：

- [ ] 项目目录存在：`D:\Projects\playwright-browser-skill\`
- [ ] MCP 服务器存在：`项目目录\dist\mcp-server.js`
- [ ] MCP 配置存在：`%USERPROFILE%.openclaw\settings\mcp.json`
- [ ] MCP 配置中的路径正确（指向项目目录）
- [ ] Skill 文件已复制：`%USERPROFILE%.openclaw\skills\playwright-browser.md`
- [ ] OpenClaw 已重启

## 🎉 总结

记住这个简单的规则：

| 文件类型 | 位置 | 操作 |
|---------|------|------|
| 项目代码和构建输出 | 项目目录 | 保留 |
| MCP 配置（mcp.json） | `%USERPROFILE%.openclaw\settings\` | 创建/编辑 |
| Skill 定义（.md） | `%USERPROFILE%.openclaw\skills\` | 复制 |

**就这么简单！** 🚀

---

**需要更多帮助？** 查看 [DEPLOYMENT_ARCHITECTURE.md](./DEPLOYMENT_ARCHITECTURE.md) 获取详细的架构说明。
