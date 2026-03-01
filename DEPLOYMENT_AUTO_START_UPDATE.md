# 部署脚本更新 - 自动启动 MCP 服务器

## 更新内容

已更新所有部署脚本，添加以下功能：

### 1. 部署完成后自动启动 MCP 服务器
- Windows (PowerShell): 在最小化窗口中启动
- Windows (CMD): 在最小化窗口中启动
- Mac/Linux: 在后台或新终端中启动

### 2. 配置开机自动启动
- **Windows**: 使用 Windows 任务计划程序（Task Scheduler）
  - 任务名称：`Playwright Browser MCP Server`
  - 触发器：用户登录时
  - 操作：运行启动脚本
  
- **macOS**: 使用 LaunchAgent
  - Plist 位置：`~/Library/LaunchAgents/com.playwright-browser-mcp.plist`
  - 触发器：用户登录时
  
- **Linux**: 使用 systemd 用户服务
  - 服务文件：`~/.config/systemd/user/playwright-browser-mcp.service`
  - 启用命令：`systemctl --user enable playwright-browser-mcp.service`

### 3. 创建启动脚本
部署时会在技能目录创建启动脚本：
- Windows PowerShell: `start-mcp-server.ps1`
- Windows CMD: `start-mcp-server.cmd`
- Mac/Linux: `start-mcp-server.sh`

## 更新的文件

### 英文版
- ✅ `auto-deploy-en.ps1` - Windows PowerShell 部署脚本
- ✅ `auto-deploy-en.cmd` - Windows CMD 部署脚本
- ✅ `auto-deploy-en.sh` - Mac/Linux Shell 部署脚本

### 中文版（待更新）
- ⏳ `auto-deploy.ps1` - Windows PowerShell 部署脚本
- ⏳ `auto-deploy.cmd` - Windows CMD 部署脚本
- ⏳ `auto-deploy.sh` - Mac/Linux Shell 部署脚本

## 使用方法

### 部署时自动启动
运行部署脚本后，MCP 服务器会自动启动：

```powershell
# Windows PowerShell
.\auto-deploy-en.ps1

# Windows CMD
auto-deploy-en.cmd

# Mac/Linux
./auto-deploy-en.sh
```

### 手动管理 MCP 服务器

#### Windows
```powershell
# 启动
PowerShell -File "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\start-mcp-server.ps1"

# 停止
Get-Process node | Where-Object {(Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine -like '*mcp-server*'} | Stop-Process

# 检查状态
Get-Process node | Where-Object {(Get-WmiObject Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine -like '*mcp-server*'}
```

#### Mac/Linux
```bash
# 启动
~/.openclaw/skills/playwright-browser-skill/start-mcp-server.sh

# 停止
pkill -f 'node.*mcp-server.js'

# 检查状态
pgrep -f 'node.*mcp-server.js'
```

### 管理自动启动

#### Windows - 任务计划程序
```powershell
# 查看任务
Get-ScheduledTask -TaskName "Playwright Browser MCP Server"

# 禁用自动启动
Disable-ScheduledTask -TaskName "Playwright Browser MCP Server"

# 启用自动启动
Enable-ScheduledTask -TaskName "Playwright Browser MCP Server"

# 删除任务
Unregister-ScheduledTask -TaskName "Playwright Browser MCP Server" -Confirm:$false
```

#### macOS - LaunchAgent
```bash
# 查看状态
launchctl list | grep playwright-browser-mcp

# 停止服务
launchctl unload ~/Library/LaunchAgents/com.playwright-browser-mcp.plist

# 启动服务
launchctl load ~/Library/LaunchAgents/com.playwright-browser-mcp.plist

# 删除自动启动
rm ~/Library/LaunchAgents/com.playwright-browser-mcp.plist
```

#### Linux - systemd
```bash
# 查看状态
systemctl --user status playwright-browser-mcp.service

# 停止服务
systemctl --user stop playwright-browser-mcp.service

# 启动服务
systemctl --user start playwright-browser-mcp.service

# 禁用自动启动
systemctl --user disable playwright-browser-mcp.service

# 启用自动启动
systemctl --user enable playwright-browser-mcp.service

# 删除服务
systemctl --user disable playwright-browser-mcp.service
rm ~/.config/systemd/user/playwright-browser-mcp.service
```

## 部署流程变化

### 之前的流程（7 步）
1. 检查项目环境
2. 构建项目
3. 检测 OpenClaw 路径
4. 准备目录结构
5. 部署独立技能包
6. 配置 MCP
7. 验证部署

### 现在的流程（9 步）
1. 检查项目环境
2. 构建项目
3. 检测 OpenClaw 路径
4. 准备目录结构
5. 部署独立技能包
6. 配置 MCP
7. 验证部署
8. **启动 MCP 服务器** ⭐ 新增
9. **配置自动启动** ⭐ 新增

## 优势

### 用户体验改进
1. **即时可用**：部署完成后 MCP 服务器立即可用，无需手动启动
2. **开机自启**：系统启动后自动运行，无需每次手动启动
3. **后台运行**：MCP 服务器在后台运行，不干扰正常使用
4. **易于管理**：提供清晰的管理命令，方便启动/停止/检查状态

### 技术实现
1. **跨平台支持**：Windows、macOS、Linux 都有对应的自启动方案
2. **系统集成**：使用系统原生的自启动机制（Task Scheduler、LaunchAgent、systemd）
3. **可靠性**：自动重启机制（部分平台支持）
4. **日志记录**：启动脚本包含日志输出，便于排查问题

## 注意事项

### Windows
- 需要管理员权限来创建计划任务（脚本会自动请求）
- MCP 服务器窗口会最小化，但不会完全隐藏
- 可以在任务管理器中看到 PowerShell 或 CMD 进程

### macOS
- LaunchAgent 在用户登录时启动
- 日志文件位于技能目录：`mcp-server.log` 和 `mcp-server-error.log`
- 可以使用 Console.app 查看日志

### Linux
- 需要 systemd 支持（大多数现代 Linux 发行版都支持）
- 服务在用户会话中运行，不是系统服务
- 日志可以通过 `journalctl --user -u playwright-browser-mcp.service` 查看

## 故障排除

### MCP 服务器未启动
1. 检查启动脚本是否存在
2. 手动运行启动脚本测试
3. 查看日志文件（如果有）
4. 检查 Node.js 是否在 PATH 中

### 自动启动未生效
1. **Windows**: 打开任务计划程序，检查任务是否存在和启用
2. **macOS**: 运行 `launchctl list | grep playwright-browser-mcp`
3. **Linux**: 运行 `systemctl --user status playwright-browser-mcp.service`

### 端口冲突
如果 MCP 服务器使用特定端口且被占用：
1. 停止占用端口的进程
2. 或修改 MCP 服务器配置使用不同端口

## 下一步计划

1. ✅ 更新英文版部署脚本
2. ⏳ 更新中文版部署脚本（需要同样的修改）
3. ⏳ 更新文档说明自动启动功能
4. ⏳ 测试所有平台的自动启动功能
5. ⏳ 创建卸载脚本（包括删除自动启动配置）

## 总结

通过这次更新，用户在部署 Playwright Browser Skill 后：
1. MCP 服务器会立即启动并可用
2. 系统重启后 MCP 服务器会自动启动
3. 无需手动管理 MCP 服务器的启动和停止
4. 提供了完整的管理命令用于高级用户

这大大改善了用户体验，解决了之前需要手动启动 MCP 服务器的问题。
