# MCP 服务器未自动启动问题排查

## 诊断结果

✅ **所有配置都正确**
- Node.js: v22.22.0
- MCP 服务器文件存在
- mcp.json 配置正确
- disabled = false
- MCP 服务器可以手动启动
- 依赖完整

## 问题原因

OpenClaw Gateway 重启后 MCP 没有自动启动，可能的原因：

1. **OpenClaw 进程未完全关闭**
   - 后台进程仍在运行
   - 配置未重新加载

2. **MCP 服务器需要手动重新连接**
   - OpenClaw 可能不会自动重连已配置的 MCP 服务器
   - 需要在 UI 中手动触发连接

3. **配置文件缓存**
   - OpenClaw 可能缓存了旧配置
   - 需要清除缓存

## 解决方案

### 方案 1：完全重启 OpenClaw（推荐）

**步骤：**

1. **完全关闭 OpenClaw**
   ```powershell
   # 查找所有 OpenClaw 进程
   Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"}
   
   # 强制关闭所有相关进程
   Get-Process | Where-Object {$_.ProcessName -like "*openclaw*"} | Stop-Process -Force
   ```

2. **等待 5-10 秒**
   确保所有进程完全退出

3. **重新启动 OpenClaw**
   从开始菜单或桌面图标启动

4. **验证 MCP 服务器状态**
   - 打开 OpenClaw
   - 查找 "MCP Servers" 或 "Model Context Protocol" 视图
   - 确认 `playwright-browser` 显示为 "Connected" 或 "运行中"

### 方案 2：手动重新连接 MCP 服务器

**步骤：**

1. **打开 MCP Server 视图**
   - 在 OpenClaw 侧边栏或设置中查找
   - 可能在 "Tools" 或 "Extensions" 部分

2. **找到 playwright-browser 服务器**
   - 应该在服务器列表中

3. **手动重新连接**
   - 点击 "Reconnect" 或 "Restart" 按钮
   - 或者先 "Disconnect" 再 "Connect"

4. **查看状态**
   - 状态应该变为 "Connected"
   - 应该显示 101 个可用工具

### 方案 3：清除 OpenClaw 缓存

**步骤：**

1. **关闭 OpenClaw**

2. **删除缓存文件**（可选，谨慎操作）
   ```powershell
   # 备份配置
   Copy-Item "C:\Users\Administrator\.openclaw\openclaw.json" "C:\Users\Administrator\.openclaw\openclaw-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
   
   # 不要删除整个 .openclaw 目录！
   # 只删除可能的缓存文件（如果存在）
   ```

3. **重新启动 OpenClaw**

### 方案 4：检查 OpenClaw 日志

**步骤：**

1. **打开开发者工具**
   - 在 OpenClaw 中：Help > Toggle Developer Tools
   - 或按 F12 / Ctrl+Shift+I

2. **查看 Console 标签页**
   - 搜索 "playwright"
   - 搜索 "mcp"
   - 搜索 "error"

3. **查找错误信息**
   常见错误：
   - `Cannot find module` - 路径错误
   - `Permission denied` - 权限问题
   - `ENOENT` - 文件不存在
   - `spawn node ENOENT` - Node.js 不在 PATH 中

4. **根据错误信息修复**

### 方案 5：使用绝对路径的 Node.js

如果 Node.js 不在 PATH 中，修改 mcp.json：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "C:\\Program Files\\nodejs\\node.exe",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"
      ],
      "disabled": false
    }
  }
}
```

找到 Node.js 路径：
```powershell
where.exe node
```

### 方案 6：手动启动 MCP 服务器（测试用）

**仅用于测试，不是永久解决方案：**

```powershell
# 在单独的 PowerShell 窗口中运行
cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
node dist\mcp-server.js
```

保持这个窗口打开，MCP 服务器会一直运行。

**注意：** 这不是正常的使用方式，OpenClaw 应该自动管理 MCP 服务器。

## 验证 MCP 服务器已加载

### 方法 1：查看 MCP Server 视图

在 OpenClaw 中：
1. 打开 MCP Server 视图
2. 查看 `playwright-browser` 状态
3. 应该显示：
   - 状态：Connected / 运行中
   - 工具数量：101
   - 服务器版本：v2.1

### 方法 2：测试工具调用

在 OpenClaw 对话中输入：

```
请列出所有可用的 MCP 工具
```

或者：

```
使用 Playwright Browser Skill 打开 https://example.com
```

如果工具可用，OpenClaw 会执行命令。

### 方法 3：查看开发者工具

1. 打开开发者工具（F12）
2. 在 Console 中输入：
   ```javascript
   // 查看 MCP 服务器状态（如果 OpenClaw 提供此 API）
   console.log('MCP Servers:', window.mcpServers)
   ```

## 常见问题

### Q1: MCP Server 视图在哪里？

**A:** 位置可能因 OpenClaw 版本而异：
- 侧边栏 > MCP Servers
- 设置 > Extensions > MCP
- 工具栏 > Tools > MCP Servers
- 命令面板 > "MCP" 搜索相关命令

### Q2: 显示 "Connection Failed" 或 "Error"

**A:** 可能的原因：
1. MCP 服务器文件损坏 - 重新部署
2. 依赖缺失 - 运行 `npm install`
3. 权限问题 - 以管理员身份运行 OpenClaw
4. 端口冲突 - 检查是否有其他进程占用

### Q3: 工具列表为空

**A:** 
1. MCP 服务器可能未完全启动
2. 尝试手动重新连接
3. 查看开发者工具 Console 中的错误

### Q4: 重启多次仍然无效

**A:** 
1. 检查是否有多个 OpenClaw 实例在运行
2. 检查是否有防火墙或安全软件阻止
3. 尝试以管理员身份运行 OpenClaw
4. 检查 Windows 事件查看器中的错误日志

## 高级排查

### 检查 OpenClaw 进程

```powershell
# 查看所有 OpenClaw 相关进程
Get-Process | Where-Object {$_.ProcessName -like "*openclaw*" -or $_.ProcessName -like "*claw*"} | Format-Table ProcessName, Id, StartTime

# 查看进程详细信息
Get-Process -Name "openclaw" | Select-Object *
```

### 检查端口占用

```powershell
# 查看 OpenClaw Gateway 端口
netstat -ano | findstr "18789"

# 查看所有 Node.js 进程
Get-Process node | Format-Table Id, ProcessName, StartTime
```

### 检查文件锁定

```powershell
# 检查 mcp-server.js 是否被锁定
$file = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js"
try {
    [IO.File]::OpenWrite($file).Close()
    Write-Host "文件未被锁定"
} catch {
    Write-Host "文件被锁定: $_"
}
```

## 最终建议

如果以上所有方法都无效：

1. **重新部署 Skill**
   ```powershell
   # 删除旧安装
   Remove-Item "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill" -Recurse -Force
   
   # 重新运行部署脚本
   .\auto-deploy-en.cmd
   ```

2. **检查 OpenClaw 版本**
   - 确保使用最新版本的 OpenClaw
   - MCP 功能可能在旧版本中不可用或有 bug

3. **联系支持**
   - 提供诊断报告：`mcp-diagnostic-report.txt`
   - 提供 OpenClaw 版本信息
   - 提供开发者工具 Console 中的错误日志
   - GitHub Issue: https://github.com/91fapiao-cn/playwright-browser-skill/issues

## 成功标志

当 MCP 服务器正确加载后，你应该看到：

✅ MCP Server 视图中 `playwright-browser` 状态为 "Connected"
✅ 显示 101 个可用工具
✅ 可以在对话中调用浏览器自动化功能
✅ 开发者工具 Console 中没有 MCP 相关错误

## 总结

根据诊断结果，你的配置是正确的。问题很可能是：

1. **OpenClaw 进程未完全重启** - 尝试强制关闭所有进程后重启
2. **需要手动重新连接** - 在 MCP Server 视图中手动触发连接
3. **OpenClaw 缓存问题** - 清除缓存后重启

**推荐操作顺序：**
1. 强制关闭所有 OpenClaw 进程
2. 等待 10 秒
3. 重新启动 OpenClaw
4. 打开 MCP Server 视图
5. 手动点击 "Reconnect" 或 "Connect"
6. 验证状态为 "Connected"
7. 测试工具调用

如果仍然无效，请提供 OpenClaw 开发者工具 Console 中的错误信息。
