# OpenClaw MCP 技能配置完全指南

**创建时间：** 2026-03-01  
**目的：** 解答 OpenClaw 如何加载和使用 MCP 技能  
**状态：** ✅ 完整指南

---

## 🔍 发现的问题

### 当前配置状态

**1. openclaw.json 中的配置：**
```json
"skills": {
  "entries": {
    "playwright-browser": {
      "enabled": true,
      "config": {
        "command": "node",
        "args": [
          "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-backup-20260301-100248\\dist\\mcp-server.js"
        ],
        "type": "mcp"
      }
    }
  }
}
```

**问题：** ❌ 路径指向备份目录（`playwright-browser-backup-20260301-100248`），不是当前部署目录！

**2. mcp.json 中的配置：**
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
      ],
      "disabled": false,
      "autoApprove": [...]
    }
  }
}
```

**状态：** ✅ 路径正确，指向当前部署目录

---

## 📖 OpenClaw MCP 技能加载机制

### 1. OpenClaw 如何加载 MCP 技能？

OpenClaw 使用 **双配置系统**：

#### 配置 A：openclaw.json（主配置）
- **位置：** `~/.openclaw/openclaw.json`
- **作用：** OpenClaw 的主配置文件
- **技能配置：** `skills.entries` 部分
- **优先级：** 🔴 **最高优先级**

#### 配置 B：mcp.json（MCP 专用配置）
- **位置：** `~/.openclaw/settings/mcp.json`
- **作用：** MCP 服务器的专用配置
- **配置：** `mcpServers` 部分
- **优先级：** 🟡 **次要优先级**

### 2. 配置优先级规则

```
openclaw.json 中的 skills.entries
    ↓
如果存在且 enabled: true
    ↓
使用 openclaw.json 中的配置
    ↓
忽略 mcp.json 中的配置
```

**关键点：**
- ✅ 如果 `openclaw.json` 中有技能配置，OpenClaw 会使用它
- ❌ `mcp.json` 中的配置会被忽略
- ⚠️ 两个配置文件可能不同步！

---

## 🔧 正确的配置方式

### 方案 1：只使用 openclaw.json（推荐）

**优点：**
- 配置集中
- 不会混淆
- OpenClaw 原生支持

**配置步骤：**

1. **编辑 openclaw.json**
```json
{
  "skills": {
    "entries": {
      "playwright-browser": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": [
            "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
          ],
          "type": "mcp"
        }
      }
    }
  }
}
```

2. **重启 OpenClaw**

### 方案 2：只使用 mcp.json

**优点：**
- 专门管理 MCP 服务器
- 配置更灵活

**配置步骤：**

1. **从 openclaw.json 中删除技能配置**
```json
{
  "skills": {
    "entries": {}
  }
}
```

2. **确保 mcp.json 配置正确**
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
      ],
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

3. **重启 OpenClaw**

---

## 🐛 修复当前问题

### 问题：路径指向备份目录

**当前错误配置：**
```json
"args": [
  "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-backup-20260301-100248\\dist\\mcp-server.js"
]
```

**正确配置：**
```json
"args": [
  "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"
]
```

### 修复步骤

**方法 1：手动编辑（推荐）**

1. 打开 `C:\Users\Administrator\.openclaw\openclaw.json`
2. 找到 `skills.entries.playwright-browser.config.args`
3. 修改路径，删除 `-backup-20260301-100248`
4. 保存文件
5. 重启 OpenClaw

**方法 2：使用 PowerShell 自动修复**

```powershell
# 读取配置
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# 修复路径
$config.skills.entries.'playwright-browser'.config.args[0] = "C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js"

# 保存配置
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8

Write-Host "✅ 配置已修复！请重启 OpenClaw。"
```

---

## ✅ 如何验证 MCP 服务器已加载

### 方法 1：查看 OpenClaw 日志

**日志位置：**
```
C:\Users\Administrator\.openclaw\logs\
```

**查看最新日志：**
```powershell
Get-Content "$env:USERPROFILE\.openclaw\logs\openclaw.log" -Tail 50
```

**成功加载的标志：**
```
[MCP] Starting server: playwright-browser
[MCP] Server started: playwright-browser (PID: xxxxx)
[MCP] Registered 101 tools from playwright-browser
```

### 方法 2：查看进程

**检查 MCP 服务器进程：**
```powershell
Get-Process node | Where-Object {$_.CommandLine -like "*mcp-server.js*"}
```

**预期输出：**
```
ProcessId: 12345
CommandLine: node C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js
```

### 方法 3：在 OpenClaw 中测试

**测试对话：**
```
你：查看可用的技能
OpenClaw：[应该列出 playwright-browser]

你：playwright-browser 技能有哪些工具？
OpenClaw：[应该列出 101 个工具]
```

---

## 🎯 如何调用 MCP 工具

### OpenClaw 的工具调用机制

**重要：** 你不能直接调用 `browser_launch()`！

OpenClaw 使用 **自然语言理解** 来调用工具：

### 调用方式 1：自然语言（推荐）

**示例对话：**
```
你：使用 playwright-browser 技能访问 example.com

OpenClaw 会：
1. 理解你的意图
2. 自动调用 browser_launch()
3. 自动调用 browser_goto("https://example.com")
4. 自动调用 browser_get_title()
5. 返回结果
```

### 调用方式 2：明确指定工具

**示例对话：**
```
你：使用 playwright-browser 的 browser_launch 工具启动浏览器

OpenClaw 会：
1. 识别工具名称
2. 调用 browser_launch()
3. 返回结果
```

### 调用方式 3：提供参数

**示例对话：**
```
你：使用 playwright-browser 启动浏览器，参数：
{
  "browserType": "chromium",
  "headless": false
}

OpenClaw 会：
1. 解析参数
2. 调用 browser_launch({"browserType": "chromium", "headless": false})
3. 返回结果
```

---

## 📝 完整的使用流程

### 步骤 1：确保配置正确

**检查清单：**
- [ ] `openclaw.json` 中的路径正确
- [ ] 或 `mcp.json` 中的路径正确（如果不使用 openclaw.json）
- [ ] 路径指向当前部署目录，不是备份目录
- [ ] `SKILL.md` 文件存在于 `~/.openclaw/skills/playwright-browser-skill/`

### 步骤 2：重启 OpenClaw

**重启方法：**
1. 关闭 OpenClaw
2. 等待 5 秒
3. 重新启动 OpenClaw

### 步骤 3：验证加载

**在 OpenClaw 中输入：**
```
查看可用的技能
```

**预期响应：**
```
可用技能：
- playwright-browser: 浏览器自动化技能，支持101个工具
```

### 步骤 4：测试调用

**测试 1：简单调用**
```
你：使用 playwright-browser 访问 example.com
```

**测试 2：带参数调用**
```
你：使用 playwright-browser 启动浏览器并访问 https://www.google.com
```

**测试 3：复杂任务**
```
你：使用 playwright-browser 做以下事情：
1. 启动浏览器
2. 访问 github.com
3. 截图保存为 github.png
```

---

## 🔍 故障排查

### 问题 1：OpenClaw 找不到技能

**症状：**
```
你：使用 playwright-browser
OpenClaw：我没有找到这个技能
```

**原因：**
- ❌ `SKILL.md` 文件不存在
- ❌ 路径配置错误
- ❌ OpenClaw 未重启

**解决方案：**
1. 检查 `C:\Users\Administrator\.openclaw\skills\playwright-browser\SKILL.md` 是否存在
2. 检查 `openclaw.json` 中的路径
3. 重启 OpenClaw

### 问题 2：MCP 服务器未启动

**症状：**
```
你：使用 playwright-browser
OpenClaw：技能存在，但无法连接到 MCP 服务器
```

**原因：**
- ❌ `mcp-server.js` 文件不存在
- ❌ Node.js 未安装
- ❌ 依赖缺失（node_modules）

**解决方案：**
1. 检查 `C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js` 是否存在
2. 检查 `node_modules` 目录是否存在
3. 手动测试：`node C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js`

### 问题 3：工具调用失败

**症状：**
```
你：使用 playwright-browser 访问 example.com
OpenClaw：调用 browser_launch 失败
```

**原因：**
- ❌ Playwright 浏览器未安装
- ❌ 权限问题
- ❌ 端口被占用

**解决方案：**
1. 安装 Playwright 浏览器：
   ```powershell
   cd C:\Users\Administrator\.openclaw\skills\playwright-browser
   npx playwright install chromium
   ```
2. 检查防火墙设置
3. 检查端口占用

---

## 📊 配置文件对比

### openclaw.json vs mcp.json

| 特性 | openclaw.json | mcp.json |
|------|---------------|----------|
| 优先级 | 🔴 最高 | 🟡 次要 |
| 位置 | `~/.openclaw/` | `~/.openclaw/settings/` |
| 作用域 | 所有技能 | 仅 MCP 服务器 |
| 自动生成 | ✅ OpenClaw 自动管理 | ⚠️ 手动或脚本生成 |
| 推荐使用 | ✅ 推荐 | ⚠️ 可选 |

### 配置格式对比

**openclaw.json 格式：**
```json
{
  "skills": {
    "entries": {
      "技能名称": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": ["路径"],
          "type": "mcp"
        }
      }
    }
  }
}
```

**mcp.json 格式：**
```json
{
  "mcpServers": {
    "服务器名称": {
      "command": "node",
      "args": ["路径"],
      "disabled": false,
      "autoApprove": ["工具列表"]
    }
  }
}
```

---

## 🎯 最佳实践

### 1. 使用 openclaw.json（推荐）

**原因：**
- OpenClaw 原生支持
- 配置集中管理
- 自动同步

**步骤：**
1. 只在 `openclaw.json` 中配置技能
2. 删除或忽略 `mcp.json`
3. 让 OpenClaw 自动管理

### 2. 定期检查配置

**检查清单：**
- [ ] 路径是否正确
- [ ] 文件是否存在
- [ ] 配置是否同步

**检查命令：**
```powershell
# 检查 SKILL.md
Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser\SKILL.md"

# 检查 mcp-server.js
Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser\dist\mcp-server.js"

# 检查 node_modules
Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser\node_modules"
```

### 3. 使用自动部署脚本

**优点：**
- 自动配置
- 避免手动错误
- 保持一致性

**使用方法：**
```cmd
cd D:\newSkill
.\auto-deploy.cmd --skip-build
```

---

## 📚 参考资料

### OpenClaw 文档
- 官方文档：[OpenClaw Docs](https://docs.openclaw.ai)
- MCP 协议：[Model Context Protocol](https://modelcontextprotocol.io)

### 项目文档
- README.md - 项目介绍
- WINDOWS_GUIDE.md - Windows 部署指南
- AUTO_DEPLOY_README.md - 自动部署说明

---

## 🔄 快速修复命令

### 修复 openclaw.json 路径

```powershell
# 读取配置
$configPath = "$env:USERPROFILE\.openclaw\openclaw.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# 修复路径
$correctPath = "C:\Users\Administrator\.openclaw\skills\playwright-browser\dist\mcp-server.js"
$config.skills.entries.'playwright-browser'.config.args[0] = $correctPath

# 保存配置
$config | ConvertTo-Json -Depth 100 | Set-Content $configPath -Encoding UTF8

Write-Host "✅ 配置已修复！"
Write-Host "📝 新路径：$correctPath"
Write-Host "🔄 请重启 OpenClaw 以应用更改"
```

### 验证配置

```powershell
# 检查所有关键文件
$skillDir = "$env:USERPROFILE\.openclaw\skills\playwright-browser"

Write-Host "检查技能文件..."
Write-Host "SKILL.md: $(Test-Path "$skillDir\SKILL.md")"
Write-Host "mcp-server.js: $(Test-Path "$skillDir\dist\mcp-server.js")"
Write-Host "node_modules: $(Test-Path "$skillDir\node_modules")"
Write-Host "package.json: $(Test-Path "$skillDir\package.json")"

# 检查配置
$config = Get-Content "$env:USERPROFILE\.openclaw\openclaw.json" -Raw | ConvertFrom-Json
$configuredPath = $config.skills.entries.'playwright-browser'.config.args[0]

Write-Host "`n配置的路径："
Write-Host $configuredPath

Write-Host "`n路径是否存在："
Write-Host (Test-Path $configuredPath)
```

---

## 总结

### ✅ 关键要点

1. **OpenClaw 使用双配置系统**
   - `openclaw.json` 优先级最高
   - `mcp.json` 是备选配置

2. **当前问题：路径指向备份目录**
   - 需要修复 `openclaw.json` 中的路径
   - 删除 `-backup-20260301-100248` 部分

3. **工具调用方式：自然语言**
   - 不能直接调用 `browser_launch()`
   - 使用自然语言描述需求
   - OpenClaw 自动选择和调用工具

4. **验证方法：**
   - 查看日志
   - 检查进程
   - 在 OpenClaw 中测试

### 🎯 下一步

1. **修复配置路径**（使用上面的 PowerShell 命令）
2. **重启 OpenClaw**
3. **测试技能调用**
4. **查看日志确认加载成功**

---

**文档创建时间：** 2026-03-01  
**状态：** ✅ 完整指南，可直接使用

