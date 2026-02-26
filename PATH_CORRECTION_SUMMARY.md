# 路径更正总结

## 🔧 重要更正

OpenClaw 的配置目录是 `.openclaw`，不是 `.kiro`！

## ✅ 已更新的内容

### 1. 文档更新（10个文件）

已将所有文档中的 `.kiro` 路径更正为 `.openclaw`：

- ✅ DEPLOYMENT_ARCHITECTURE.md
- ✅ FILE_LOCATIONS.md
- ✅ WINDOWS_GUIDE.md
- ✅ WINDOWS_SUMMARY.md
- ✅ WINDOWS_CHECKLIST.md
- ✅ QUICK_START_WINDOWS.md
- ✅ README.md
- ✅ PROJECT_STRUCTURE.md
- ✅ DEPLOYMENT.md
- ✅ ARCHITECTURE.md

### 2. 测试脚本更新（2个文件）

- ✅ test-windows.ps1
- ✅ test-windows.cmd

### 3. 新增文档

- ✅ CORRECT_PATHS.md - 正确路径说明
- ✅ PATH_CORRECTION_SUMMARY.md - 本文档

## 📁 正确的路径

### OpenClaw 配置目录

```
C:\Users\你的用户名\.openclaw\
├── settings\
│   └── mcp.json               ← MCP 配置文件
└── skills\
    └── playwright-browser.md  ← Skill 定义文件
```

### 项目目录

```
D:\Projects\playwright-browser-skill\
├── dist\
│   └── mcp-server.js          ← MCP 服务器
├── .kiro\                      ← 项目内部目录（保持不变）
│   └── skills\
│       └── playwright-browser.md  ← Skill 模板
└── ...
```

## 🔄 正确的部署命令

### 复制 Skill 文件

```cmd
REM 确保目标目录存在
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"

REM 从项目目录复制到 OpenClaw 配置目录
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

### 创建 MCP 配置

文件位置：`%USERPROFILE%\.openclaw\settings\mcp.json`

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

## ⚠️ 重要说明

### 项目内的 `.kiro` 目录

项目内部的 `.kiro` 目录**保持不变**：

```
项目目录\.kiro\skills\playwright-browser.md
```

这是项目的一部分，用作 Skill 文件的模板。

### OpenClaw 的 `.openclaw` 目录

OpenClaw 的配置目录是 `.openclaw`：

```
%USERPROFILE%\.openclaw\settings\mcp.json
%USERPROFILE%\.openclaw\skills\playwright-browser.md
```

这是 OpenClaw 读取配置的地方。

## 📊 路径对照表

| 用途 | 路径 | 说明 |
|------|------|------|
| 项目 Skill 模板 | `.kiro\skills\playwright-browser.md` | 项目内部，保持不变 |
| OpenClaw MCP 配置 | `%USERPROFILE%\.openclaw\settings\mcp.json` | OpenClaw 配置目录 |
| OpenClaw Skill 文件 | `%USERPROFILE%\.openclaw\skills\playwright-browser.md` | 从项目复制到这里 |
| MCP 服务器 | `项目目录\dist\mcp-server.js` | 保留在项目目录 |

## ✅ 验证更新

### 运行测试脚本

```powershell
.\test-windows.ps1
```

脚本现在会显示正确的路径：

```
MCP 配置示例（复制到 .openclaw\settings\mcp.json）：
...
下一步：
1. 复制上面的 MCP 配置到 .openclaw\settings\mcp.json
2. 复制 .kiro\skills\playwright-browser.md 到 %USERPROFILE%\.openclaw\skills\
```

### 检查文档

所有文档现在都使用正确的 `.openclaw` 路径。

## 🎉 总结

**关键点**：

1. **项目内部**：`.kiro\` 目录（保持不变）
2. **OpenClaw 配置**：`.openclaw\` 目录（已更正）

**正确的复制命令**：

```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\
```

**正确的配置路径**：

```
%USERPROFILE%\.openclaw\settings\mcp.json
```

---

**更新完成！** 所有文档和脚本现在都使用正确的 `.openclaw` 路径。感谢指正！🎊
