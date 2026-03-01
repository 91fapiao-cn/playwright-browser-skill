# mcp.json 路径修复 - 最终解决方案

**日期**: 2026-03-01  
**问题**: OpenClaw 报告 "MCP 未注册"  
**根本原因**: mcp.json 中的路径错误  
**状态**: ✅ 已修复

---

## 🔍 问题根源

### 错误的 mcp.json 配置

之前的 mcp.json 包含两个配置，路径都是错误的：

```json
{
  "mcpServers": {
    "playwright-browser-skill": {
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      ...
    },
    "playwright-browser": {
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"],
      ...
    }
  }
}
```

**问题**:
1. `playwright-browser-skill` 配置的路径虽然正确，但名称与 SKILL.md 不匹配
2. `playwright-browser` 配置的路径错误（指向 `playwright-browser` 目录，但实际是 `playwright-browser-skill`）
3. 两个配置同时存在，造成混乱

### 为什么 SKILL.md 的 mcp 配置没有生效

OpenClaw 可能：
1. 不支持 SKILL.md 中的 `mcp` 配置（版本问题）
2. 优先使用 mcp.json 的配置
3. SKILL.md 的配置被 mcp.json 覆盖

---

## ✅ 解决方案

### 修复后的 mcp.json

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "env": {},
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

**修复内容**:
1. ✅ 只保留一个配置：`playwright-browser`
2. ✅ 使用正确的路径：`playwright-browser-skill\dist\mcp-server.js`
3. ✅ 名称与 SKILL.md 匹配：`playwright-browser`
4. ✅ 包含 autoApprove 配置

---

## 🧪 验证结果

### 手动测试 MCP 服务器

```powershell
cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
node dist\mcp-server.js
```

**输出**:
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

✅ MCP 服务器可以正常启动

---

## 📋 配置文件状态

### 1. mcp.json（主配置）✅

**位置**: `C:\Users\Administrator\.openclaw\settings\mcp.json`

**内容**:
- 服务器名称：`playwright-browser`
- 命令：`node`
- 路径：`C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`（绝对路径）
- 状态：`disabled: false`
- 自动批准：8 个常用工具

### 2. SKILL.md（辅助配置）✅

**位置**: `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md`

**内容**:
```yaml
---
name: playwright-browser
mcp:
  command: node
  args:
    - dist/mcp-server.js
---
```

**说明**: 
- 虽然格式正确，但 OpenClaw 可能不支持或被 mcp.json 覆盖
- 保留此配置以备将来使用

---

## 🚀 下一步操作

### 1. 重启 OpenClaw

**完全关闭**:
```powershell
Get-Process | Where-Object { $_.ProcessName -like "*openclaw*" } | Stop-Process -Force
```

**重新启动**:
- 从开始菜单或桌面快捷方式启动 OpenClaw
- 等待完全启动（Gateway 端口 18789 监听）

### 2. 验证 MCP 注册

在 OpenClaw 中检查：
- 打开 MCP 服务器列表/设置
- 查找 `playwright-browser`
- 确认状态为"已连接"或"运行中"
- 确认工具数量为 101 个

### 3. 测试技能功能

在 OpenClaw 对话中输入：
```
请使用 Playwright Browser Skill 启动浏览器并访问 example.com
```

---

## 🎯 关键要点

### 为什么之前失败

1. **路径错误**: mcp.json 中的路径指向不存在的目录
2. **名称混乱**: 两个配置（playwright-browser 和 playwright-browser-skill）
3. **配置冲突**: SKILL.md 和 mcp.json 的配置不一致

### 为什么现在应该成功

1. ✅ **路径正确**: 指向实际存在的 mcp-server.js
2. ✅ **名称统一**: 只有一个 `playwright-browser` 配置
3. ✅ **配置清晰**: mcp.json 使用绝对路径，明确无误
4. ✅ **服务器可启动**: 手动测试验证成功

---

## 📊 对比

### 修复前

```json
{
  "mcpServers": {
    "playwright-browser-skill": {
      "args": ["C:\\...\\playwright-browser-skill\\dist\\mcp-server.js"]
    },
    "playwright-browser": {
      "args": ["C:\\...\\playwright-browser\\dist\\mcp-server.js"]  // ❌ 路径错误
    }
  }
}
```

**问题**:
- `playwright-browser` 的路径错误（目录不存在）
- 两个配置造成混乱

### 修复后

```json
{
  "mcpServers": {
    "playwright-browser": {
      "args": ["C:\\...\\playwright-browser-skill\\dist\\mcp-server.js"]  // ✅ 路径正确
    }
  }
}
```

**改进**:
- 只有一个配置
- 路径正确
- 名称与 SKILL.md 匹配

---

## 🔧 故障排除

### 如果重启后仍然报错

#### 1. 检查 MCP 服务器进程

```powershell
Get-Process node | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server*") {
        Write-Host "MCP 服务器正在运行 (PID: $($_.Id))"
        Write-Host "命令: $cmdLine"
    }
}
```

#### 2. 查看 OpenClaw 日志

查找日志文件：
- `~/.openclaw/logs/`
- OpenClaw 安装目录
- 应用程序数据目录

搜索关键词：
- `playwright-browser`
- `MCP`
- `error`
- `failed`

#### 3. 手动启动 MCP 服务器

```powershell
cd "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
node dist\mcp-server.js
```

如果启动失败，检查错误信息。

#### 4. 验证文件完整性

```powershell
$skillDir = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
@("SKILL.md", "dist\mcp-server.js", "node_modules") | ForEach-Object {
    $path = Join-Path $skillDir $_
    if (Test-Path $path) {
        Write-Host "✅ $_"
    } else {
        Write-Host "❌ $_ 缺失"
    }
}
```

---

## 📝 备份信息

### 旧配置备份

备份文件位置：
```
C:\Users\Administrator\.openclaw\settings\mcp.json.backup.YYYYMMDDHHMMSS
```

如需恢复旧配置：
```powershell
$backup = "C:\Users\Administrator\.openclaw\settings\mcp.json.backup.YYYYMMDDHHMMSS"
$target = "C:\Users\Administrator\.openclaw\settings\mcp.json"
Copy-Item $backup $target -Force
```

---

## 🎉 总结

### 问题原因
- ❌ mcp.json 中的路径错误
- ❌ 配置名称混乱
- ❌ SKILL.md 配置未生效

### 解决方法
- ✅ 修复 mcp.json 路径
- ✅ 统一配置名称
- ✅ 使用绝对路径确保可靠性

### 当前状态
- ✅ mcp.json 配置正确
- ✅ MCP 服务器可以启动
- ✅ 路径和名称都正确
- ⏳ 等待重启 OpenClaw 验证

**下一步**: 重启 OpenClaw 并验证 MCP 注册成功！
