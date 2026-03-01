# OpenClaw 工具列表中没有显示 MCP 工具 - 解决方案

## 🔍 问题描述

**症状：** OpenClaw 的工具列表中没有显示 `browser_launch` 等 MCP 工具

**诊断结果：**
- ✅ MCP 服务器正在运行 (PID: 17712)
- ✅ OpenClaw Gateway 正在运行 (PID: 27656, 端口 18789)
- ✅ mcp.json 配置正确
- ❌ OpenClaw 没有加载 MCP 工具到工具列表

---

## 🎯 根本原因

OpenClaw 的 MCP 集成方式可能与预期不同：

1. **OpenClaw 可能不会直接暴露 MCP 工具** - MCP 工具可能通过技能（Skill）间接调用
2. **需要通过自然语言触发** - AI 会根据 SKILL.md 的描述自动选择工具
3. **工具列表可能只显示内置工具** - MCP 工具不会出现在工具列表中

---

## ✅ 解决方案

### 方案 1：通过自然语言触发（推荐）

OpenClaw 的设计理念是 **AI 自动选择工具**，而不是用户手动选择。

#### 测试步骤：

1. **在 OpenClaw 中输入自然语言命令**
   ```
   帮我访问 example.com 并获取页面标题
   ```

2. **观察 OpenClaw 的响应**
   - 如果 OpenClaw 开始执行浏览器操作 → ✅ 成功
   - 如果 OpenClaw 说不知道怎么做 → 继续下一个方案

---

### 方案 2：明确提及技能名称

告诉 OpenClaw 使用特定的技能：

```
使用 playwright-browser 技能访问 example.com
```

或：

```
用浏览器自动化技能打开 baidu.com
```

---

### 方案 3：检查技能是否被识别

#### 步骤 1：查看 OpenClaw 技能列表

在 OpenClaw 中输入：
```
显示所有可用的技能
```

或：
```
列出所有技能
```

#### 步骤 2：确认 playwright-browser 是否在列表中

如果看到 `playwright-browser` 或 `浏览器自动化技能` → ✅ 技能已识别

如果没有看到 → 继续方案 4

---

### 方案 4：重启 OpenClaw Gateway

MCP 工具可能需要重启 Gateway 才能加载。

#### 步骤：

1. **停止 OpenClaw Gateway**
   ```powershell
   Get-Process -Id 27656 | Stop-Process -Force
   ```

2. **等待 5 秒**

3. **OpenClaw 会自动重启 Gateway**
   - 或者手动重启 OpenClaw

4. **测试**
   ```
   访问 example.com
   ```

---

### 方案 5：检查 OpenClaw 日志

查看 OpenClaw 是否有错误信息。

#### 步骤：

1. **查看 OpenClaw 输出**
   - 在 OpenClaw TUI 中查看日志
   - 或查看终端输出

2. **查找 MCP 相关错误**
   - 搜索 "MCP"
   - 搜索 "playwright-browser"
   - 搜索 "connection failed"

3. **根据错误信息调整**

---

### 方案 6：手动测试 MCP 连接

测试 OpenClaw Gateway 是否能连接到 MCP 服务器。

#### 步骤：

1. **创建测试脚本**
   ```powershell
   # 保存为 test-mcp-gateway.ps1
   
   Write-Host "测试 MCP Gateway 连接..." -ForegroundColor Cyan
   
   # 检查 Gateway 端口
   $gateway = netstat -ano | Select-String "LISTENING" | Select-String "18789"
   if ($gateway) {
       Write-Host "✅ Gateway 正在监听端口 18789" -ForegroundColor Green
   } else {
       Write-Host "❌ Gateway 未监听端口 18789" -ForegroundColor Red
       exit 1
   }
   
   # 检查 MCP 服务器
   $mcp = Get-Process node -ErrorAction SilentlyContinue | Where-Object {
       (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine -like '*mcp-server*'
   }
   if ($mcp) {
       Write-Host "✅ MCP 服务器正在运行 (PID: $($mcp.Id))" -ForegroundColor Green
   } else {
       Write-Host "❌ MCP 服务器未运行" -ForegroundColor Red
       exit 1
   }
   
   Write-Host "`n✅ 所有组件正常运行" -ForegroundColor Green
   Write-Host "如果 OpenClaw 仍然无法使用工具，请尝试重启 OpenClaw" -ForegroundColor Yellow
   ```

2. **运行测试**
   ```powershell
   .\test-mcp-gateway.ps1
   ```

---

### 方案 7：简化 SKILL.md（如果上述方案都失败）

可能 SKILL.md 太复杂，OpenClaw 无法解析。

#### 步骤：

1. **备份当前 SKILL.md**
   ```powershell
   Copy-Item "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md" `
             "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md.backup"
   ```

2. **创建简化版 SKILL.md**
   
   只保留：
   - Frontmatter（YAML 头部）
   - 简短的描述
   - AI 调用指南（前 50 行）
   - 10 个最常用的工具

3. **重启 OpenClaw**

---

## 🧪 测试命令

### 测试 1：最简单的命令

```
访问 example.com
```

**期望：** OpenClaw 启动浏览器并访问网站

---

### 测试 2：明确的任务

```
帮我用浏览器打开 baidu.com 并获取页面标题
```

**期望：** OpenClaw 执行完整的浏览器操作流程

---

### 测试 3：提及技能名称

```
使用 playwright-browser 技能访问 github.com
```

**期望：** OpenClaw 明确使用该技能

---

## 🔍 调试检查清单

- [ ] MCP 服务器正在运行（PID: 17712）
- [ ] OpenClaw Gateway 正在运行（PID: 27656）
- [ ] mcp.json 配置正确
- [ ] SKILL.md 存在且包含 AI 调用指南
- [ ] OpenClaw 已完全重启
- [ ] 尝试了自然语言命令
- [ ] 尝试了明确提及技能名称
- [ ] 查看了 OpenClaw 日志

---

## 💡 理解 OpenClaw 的工作方式

### OpenClaw 的 MCP 集成模型

OpenClaw 可能采用以下模型之一：

#### 模型 1：隐式工具调用（最可能）
```
用户 → OpenClaw AI → 读取 SKILL.md → 理解需求 → 调用 MCP 工具
```

在这个模型中：
- 用户不需要看到工具列表
- AI 根据 SKILL.md 的描述自动选择工具
- 工具调用对用户是透明的

#### 模型 2：显式工具调用
```
用户 → 选择工具 → OpenClaw → 调用 MCP 工具
```

在这个模型中：
- 用户可以看到工具列表
- 用户手动选择工具
- 需要工具出现在 UI 中

**如果 OpenClaw 使用模型 1**，那么工具不会出现在列表中是正常的！

---

## 🎯 推荐的使用方式

基于 OpenClaw 的设计理念，推荐使用方式：

### ✅ 正确的使用方式

```
"帮我访问 example.com 并获取页面标题"
"在百度搜索 OpenClaw"
"访问 github.com 并截图"
"从这个网页提取所有链接"
```

### ❌ 不推荐的使用方式

```
"调用 browser_launch 工具"
"使用 browser_goto 访问网站"
"执行 browser_click 操作"
```

---

## 📊 当前系统状态

```
✅ MCP 服务器: 运行中 (PID: 17712)
✅ OpenClaw Gateway: 运行中 (PID: 27656, 端口 18789)
✅ OpenClaw TUI: 运行中 (PID: 26304/8676)
✅ mcp.json: 配置正确
✅ SKILL.md: 已更新（包含 AI 调用指南）
✅ 自动启动: 已配置
```

---

## 🆘 如果所有方案都失败

### 可能的原因：

1. **OpenClaw 版本不支持 MCP**
   - 检查 OpenClaw 版本
   - 查看 OpenClaw 文档确认 MCP 支持

2. **MCP 协议版本不兼容**
   - OpenClaw 使用的 MCP 版本
   - playwright-browser-skill 使用的 MCP SDK 版本

3. **OpenClaw 的 MCP 实现有限制**
   - 可能只支持特定类型的 MCP 服务器
   - 可能需要特殊的配置格式

### 下一步：

1. **查看 OpenClaw 官方文档**
   - MCP 集成指南
   - 示例技能

2. **联系 OpenClaw 支持**
   - 询问 MCP 工具如何显示
   - 询问正确的使用方式

3. **查看 OpenClaw 源代码**
   - 了解 MCP 集成实现
   - 查看工具加载逻辑

---

## 📝 下一步行动

1. **首先尝试方案 1**：使用自然语言命令
   ```
   访问 example.com 并获取页面标题
   ```

2. **如果失败，尝试方案 2**：明确提及技能
   ```
   使用 playwright-browser 技能访问 example.com
   ```

3. **如果还是失败，尝试方案 4**：重启 Gateway

4. **查看 OpenClaw 日志**：寻找错误信息

5. **如果所有方案都失败**：查看 OpenClaw 文档或联系支持

---

**现在请尝试方案 1：在 OpenClaw 中输入 "访问 example.com 并获取页面标题"**
