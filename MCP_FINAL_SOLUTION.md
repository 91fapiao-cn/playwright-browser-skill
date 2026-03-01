# MCP 服务器最终解决方案

## 当前状态

✅ **已确认的事实：**
1. OpenClaw Gateway 正在运行（端口 18789）
2. MCP 服务器文件存在且可以手动启动
3. 配置文件（mcp.json 和 openclaw.json）都正确
4. MCP 服务器手动启动时显示：`已注册 101 个工具`

❌ **问题：**
- OpenClaw Gateway 不会自动启动 MCP 服务器
- 即使重启 Gateway 也不会自动启动

## 根本原因分析

OpenClaw 的 MCP 服务器管理机制可能与预期不同：

1. **可能性 1：需要通过 TUI 或 UI 手动连接**
   - OpenClaw 可能需要用户在界面中手动连接 MCP 服务器
   - 配置文件只是定义服务器，不会自动启动

2. **可能性 2：需要额外的配置**
   - 可能需要在 `openclaw.json` 中添加更多配置
   - 可能需要特定的启动参数

3. **可能性 3：版本兼容性问题**
   - 当前 OpenClaw 版本可能不支持自动启动 MCP
   - 需要更新到最新版本

## 推荐解决方案

### 方案 1：使用 OpenClaw TUI（推荐）

OpenClaw TUI 可能提供 MCP 管理界面：

```powershell
# 启动 TUI
openclaw tui
```

在 TUI 中查找：
- MCP Servers 选项
- Skills 管理选项
- 手动连接 playwright-browser 服务器

### 方案 2：手动启动 MCP 服务器作为后台服务

创建一个 Windows 服务或计划任务来自动启动 MCP 服务器：

#### 步骤 1：创建启动脚本

已创建：`test-mcp-manual-start.ps1`

#### 步骤 2：设置为开机自启动（可选）

```powershell
# 创建计划任务
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File C:\path\to\test-mcp-manual-start.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
Register-ScheduledTask -TaskName "OpenClaw MCP Server" -Action $action -Trigger $trigger -Principal $principal
```

#### 步骤 3：手动启动（每次使用前）

```powershell
# 在后台启动 MCP 服务器
Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File test-mcp-manual-start.ps1" -WindowStyle Hidden
```

### 方案 3：修改 OpenClaw 配置以支持自动启动

尝试在 `openclaw.json` 中添加更多配置：

```json
{
  "tools": {
    "mcp": {
      "enabled": true,
      "autoStart": true
    }
  },
  "skills": {
    "entries": {
      "playwright-browser-skill": {
        "enabled": true,
        "autoStart": true
      }
    }
  }
}
```

然后重启 Gateway：

```powershell
Get-Process | Where-Object {$_.ProcessName -like '*openclaw*'} | Stop-Process -Force
Start-Sleep -Seconds 5
openclaw gateway
```

### 方案 4：直接测试功能（最简单）

即使 MCP 服务器进程不可见，OpenClaw 可能通过其他方式加载了工具。

**直接在 OpenClaw 对话中测试：**

```
请列出所有可用的 MCP 工具
```

或者：

```
使用 Playwright Browser 打开 https://example.com 并获取页面标题
```

如果功能可用，说明 MCP 已经以某种方式加载了。

## 快速测试脚本

我已经创建了以下脚本来帮助你：

### 1. 检查状态
```powershell
.\check-gateway-and-mcp.ps1
```

### 2. 手动启动 MCP 服务器
```powershell
.\test-mcp-manual-start.ps1
```

### 3. 监控 Gateway 重启
```powershell
.\monitor-mcp-startup.ps1
```

## 当前最佳实践

基于测试结果，推荐以下工作流程：

### 每次使用前：

1. **启动 OpenClaw Gateway**
   ```powershell
   openclaw gateway
   ```

2. **手动启动 MCP 服务器**（在新的 PowerShell 窗口中）
   ```powershell
   cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
   node dist\mcp-server.js
   ```
   
   保持这个窗口打开。

3. **验证状态**
   ```powershell
   .\check-gateway-and-mcp.ps1
   ```

4. **在 OpenClaw 中使用**
   - 打开 OpenClaw TUI 或对话界面
   - 直接使用浏览器自动化命令

### 自动化启动（推荐）

创建一个启动脚本 `start-openclaw-with-mcp.ps1`：

```powershell
# 启动 Gateway
Start-Process -FilePath "openclaw" -ArgumentList "gateway" -WindowStyle Hidden

# 等待 Gateway 启动
Start-Sleep -Seconds 10

# 启动 MCP 服务器
Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -NoExit -Command `"cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill; node dist\mcp-server.js`"" -WindowStyle Minimized

Write-Host "OpenClaw Gateway 和 MCP 服务器已启动" -ForegroundColor Green
Write-Host "MCP 服务器窗口已最小化，请勿关闭" -ForegroundColor Yellow
```

然后每次只需运行：
```powershell
.\start-openclaw-with-mcp.ps1
```

## 验证 MCP 是否工作

### 方法 1：检查进程
```powershell
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server*") {
        Write-Host "[√] MCP 服务器正在运行 (PID: $($_.Id))" -ForegroundColor Green
    }
}
```

### 方法 2：在 OpenClaw 中测试
在对话中输入：
```
使用浏览器打开 https://example.com
```

如果成功，你会看到浏览器操作的结果。

### 方法 3：查看 MCP 服务器输出
如果 MCP 服务器在可见窗口中运行，你会看到：
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

当 OpenClaw 调用工具时，会显示相应的日志。

## 故障排除

### 问题 1：MCP 服务器启动后立即退出

**原因：** 依赖缺失或路径错误

**解决：**
```powershell
cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
npm install
```

### 问题 2：OpenClaw 找不到 MCP 工具

**原因：** MCP 服务器未正确连接到 Gateway

**解决：**
1. 确保 MCP 服务器在 Gateway 启动后启动
2. 检查 mcp.json 配置是否正确
3. 尝试重启 Gateway

### 问题 3：端口冲突

**原因：** MCP 服务器使用的端口被占用

**解决：**
```powershell
# 查找占用端口的进程
netstat -ano | findstr "LISTENING"

# 如果需要，结束冲突的进程
Stop-Process -Id <PID> -Force
```

## 下一步建议

1. **尝试方案 4**：直接在 OpenClaw 对话中测试功能
   - 这是最快的验证方法
   - 如果能用，就不需要担心进程问题

2. **如果方案 4 不行**：使用方案 2 手动启动 MCP 服务器
   - 创建自动化启动脚本
   - 每次使用前运行脚本

3. **长期解决方案**：联系 OpenClaw 支持
   - 询问正确的 MCP 自动启动配置
   - 确认当前版本是否支持自动启动
   - 提供你的配置文件和诊断信息

## 总结

虽然 OpenClaw Gateway 不会自动启动 MCP 服务器，但我们有多种方法可以让它工作：

✅ **最简单**：直接测试功能（可能已经工作）
✅ **最可靠**：手动启动 MCP 服务器
✅ **最方便**：创建自动化启动脚本

选择最适合你的方案，然后开始使用 Playwright Browser Skill 的 101 个浏览器自动化工具！

## 配置文件位置

- OpenClaw 配置：`C:\Users\Administrator\.openclaw\openclaw.json`
- MCP 配置：`C:\Users\Administrator\.openclaw\settings\mcp.json`
- MCP 服务器：`C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`
- 技能目录：`C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\`

## 相关脚本

- `check-gateway-and-mcp.ps1` - 检查 Gateway 和 MCP 状态
- `test-mcp-manual-start.ps1` - 手动启动 MCP 服务器
- `monitor-mcp-startup.ps1` - 监控 MCP 启动
- `find-mcp-view.md` - 查找 MCP Server 视图的指南
