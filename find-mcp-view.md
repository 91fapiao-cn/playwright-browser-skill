# 如何找到 OpenClaw 的 MCP Server 视图

## 快速查找方法

### 1. 命令面板（推荐）
- 按 `Ctrl+Shift+P` 或 `F1`
- 输入 "MCP" 并查看可用命令
- 常见命令：
  - `MCP: Show Servers`
  - `MCP: Connect Server`
  - `MCP: Reconnect All Servers`

### 2. 侧边栏图标
在左侧或右侧边栏查找：
- 🔌 连接图标
- 🔗 链接图标
- 📦 包图标
- 标签：MCP Servers / Servers / Extensions

### 3. 视图菜单
- View > MCP Servers
- View > Extensions > MCP
- Tools > MCP

### 4. 设置界面
- 打开设置：`Ctrl+,`
- 搜索 "MCP"
- 查找 MCP 配置选项

## 如果找不到 MCP Server 视图

这可能意味着：

### 情况 1：OpenClaw 版本较旧
- MCP 功能可能在旧版本中不可用
- 建议更新到最新版本

### 情况 2：MCP 功能未启用
检查 `openclaw.json` 中是否有 MCP 相关配置：
```json
{
  "tools": {
    "mcp": {
      "enabled": true
    }
  }
}
```

### 情况 3：使用命令行管理 MCP

OpenClaw 可能通过命令行管理 MCP 服务器：

```powershell
# 查看 OpenClaw 命令帮助
openclaw --help

# 查看 MCP 相关命令
openclaw mcp --help

# 列出 MCP 服务器
openclaw mcp list

# 连接 MCP 服务器
openclaw mcp connect playwright-browser

# 查看 MCP 服务器状态
openclaw mcp status
```

## 替代方案：直接测试 MCP 功能

即使找不到 MCP Server 视图，你也可以直接测试 MCP 是否工作：

### 测试 1：在对话中使用工具
在 OpenClaw 对话中输入：
```
请列出所有可用的 MCP 工具
```

或者：
```
使用 Playwright Browser 打开 https://example.com
```

### 测试 2：检查进程
运行以下命令查看 MCP 服务器是否在运行：
```powershell
Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
    $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
    if ($cmdLine -like "*mcp-server*") {
        Write-Host "[√] MCP 服务器正在运行 (PID: $($_.Id))" -ForegroundColor Green
        Write-Host "    命令行: $cmdLine" -ForegroundColor Gray
    }
}
```

### 测试 3：查看开发者工具
1. 在 OpenClaw 中按 `F12` 或 `Ctrl+Shift+I`
2. 打开 Console 标签页
3. 输入：
   ```javascript
   // 查看 MCP 服务器状态
   console.log('MCP Servers:', window.mcpServers)
   ```
4. 或者搜索日志中的 "mcp" 或 "playwright"

## OpenClaw CLI 命令参考

如果 OpenClaw 支持 CLI，尝试这些命令：

```powershell
# 查看所有可用命令
openclaw --help

# MCP 相关命令
openclaw mcp list              # 列出所有 MCP 服务器
openclaw mcp status            # 查看 MCP 服务器状态
openclaw mcp connect <name>    # 连接指定的 MCP 服务器
openclaw mcp disconnect <name> # 断开指定的 MCP 服务器
openclaw mcp restart <name>    # 重启指定的 MCP 服务器
openclaw mcp logs <name>       # 查看 MCP 服务器日志

# 技能相关命令
openclaw skill list            # 列出所有技能
openclaw skill enable <name>   # 启用技能
openclaw skill disable <name>  # 禁用技能
```

## 当前配置检查

你的配置文件位置：
- OpenClaw 配置：`C:\Users\Administrator\.openclaw\openclaw.json`
- MCP 配置：`C:\Users\Administrator\.openclaw\settings\mcp.json`
- 技能目录：`C:\Users\Administrator\.openclaw\skills\`

当前配置状态：
- ✅ `playwright-browser-skill` 已在 `openclaw.json` 中启用
- ✅ `playwright-browser` MCP 服务器已在 `mcp.json` 中配置
- ✅ MCP 服务器文件存在且可以手动启动
- ✅ 显示 101 个工具已注册

## 下一步建议

1. **尝试命令面板**：按 `Ctrl+Shift+P` 搜索 "MCP"
2. **检查 OpenClaw 版本**：Help > About 查看版本号
3. **查看开发者工具**：按 `F12` 查看 Console 中的 MCP 相关日志
4. **直接测试功能**：在对话中尝试使用浏览器自动化命令
5. **尝试 CLI 命令**：运行 `openclaw mcp list` 或 `openclaw mcp status`

## 如果仍然找不到

请提供以下信息：
1. OpenClaw 版本号（Help > About）
2. 开发者工具 Console 中的日志（搜索 "mcp" 或 "playwright"）
3. 运行 `openclaw --help` 的输出
4. OpenClaw 界面截图

这样我可以更准确地帮你定位问题。
