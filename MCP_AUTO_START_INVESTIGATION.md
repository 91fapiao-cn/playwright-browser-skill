# MCP 自动启动问题调查报告

## 调查结论

经过详细测试和配置对比，**OpenClaw Gateway 目前无法自动启动 MCP 服务器**，即使配置完全正确。

## 测试过程

### 1. 配置对比

**之前能工作的配置（备份）：**
```json
{
  "skills": {
    "entries": {
      "playwright-browser": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser\\dist\\mcp-server.js"],
          "type": "mcp"
        }
      }
    }
  }
}
```

**当前配置：**
```json
{
  "skills": {
    "entries": {
      "playwright-browser-skill": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
          "type": "mcp"
        }
      }
    }
  }
}
```

### 2. 关键发现

1. **配置格式正确** ✅
   - `openclaw.json` 中包含完整的 MCP 配置
   - `mcp.json` 中配置正确
   - 文件路径存在且可访问

2. **目录名称变化** ⚠️
   - 之前：`playwright-browser`
   - 现在：`playwright-browser-skill`
   - 旧目录已不存在

3. **多次重启测试** ❌
   - 完全停止 Gateway 后重启
   - 等待 30-40 秒监控
   - MCP 服务器从未自动启动

4. **手动启动正常** ✅
   - MCP 服务器可以手动启动
   - 显示：`已注册 101 个工具`
   - 功能完全正常

### 3. 可能的原因

#### 原因 A：OpenClaw 版本变化
- OpenClaw 可能在某个版本中改变了 MCP 启动机制
- 旧的配置格式可能不再被支持
- 需要新的配置方式或启动命令

#### 原因 B：配置位置变化
- MCP 配置可能需要在不同的位置
- 可能需要额外的配置文件或参数

#### 原因 C：Skill 类型识别问题
- OpenClaw 可能无法识别 `type: "mcp"` 配置
- 可能需要特定的 skill 结构或元数据

#### 原因 D：之前的"自动启动"可能是手动启动的
- 用户可能记错了，之前也是手动启动的
- 或者之前有其他脚本在后台自动启动

## 当前解决方案

由于无法实现真正的自动启动，我们提供了以下替代方案：

### 方案 1：一键启动脚本（推荐）

使用 `start-openclaw-with-mcp-auto.ps1` 脚本：

```powershell
.\start-openclaw-with-mcp-auto.ps1
```

**优点：**
- 一条命令启动 Gateway 和 MCP
- 自动检测是否已运行
- 显示详细状态信息
- MCP 服务器在后台运行（最小化窗口）

**缺点：**
- 每次使用前需要手动运行脚本
- MCP 服务器窗口需要保持打开

### 方案 2：Windows 计划任务（开机自启）

创建计划任务让 MCP 服务器开机自动启动：

```powershell
# 创建任务
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File D:\newSkill\start-openclaw-with-mcp-auto.ps1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest
Register-ScheduledTask -TaskName "OpenClaw MCP Auto Start" -Action $action -Trigger $trigger -Principal $principal -Description "自动启动 OpenClaw Gateway 和 MCP 服务器"
```

**优点：**
- 完全自动化，开机即启动
- 无需手动干预

**缺点：**
- 需要配置计划任务
- 可能影响开机速度

### 方案 3：Windows 服务（高级）

将 MCP 服务器注册为 Windows 服务：

需要使用 NSSM (Non-Sucking Service Manager) 或类似工具。

**优点：**
- 作为系统服务运行
- 自动重启
- 更稳定

**缺点：**
- 配置复杂
- 需要额外工具

## 配置文件状态

### openclaw.json
```json
{
  "skills": {
    "install": {
      "nodeManager": "npm"
    },
    "entries": {
      "playwright-browser-skill": {
        "enabled": true,
        "config": {
          "command": "node",
          "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
          "type": "mcp"
        }
      }
    }
  }
}
```

### mcp.json
```json
{
  "mcpServers": {
    "playwright-browser-skill": {
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

## 推荐的日常使用流程

### 每次使用 OpenClaw 前：

1. **运行启动脚本**
   ```powershell
   cd D:\newSkill
   .\start-openclaw-with-mcp-auto.ps1
   ```

2. **等待启动完成**（约 10-15 秒）

3. **验证状态**（可选）
   ```powershell
   .\check-gateway-and-mcp.ps1
   ```

4. **开始使用 OpenClaw**
   ```powershell
   openclaw tui
   ```
   或在 OpenClaw 对话中测试：
   ```
   使用浏览器打开 https://example.com
   ```

### 使用完毕后：

```powershell
.\stop-openclaw-and-mcp.ps1
```

## 进一步调查建议

如果想要实现真正的自动启动，可以尝试：

1. **查看 OpenClaw 官方文档**
   - 搜索 MCP 自动启动的最新配置方法
   - 查看是否有新的配置格式

2. **检查 OpenClaw 版本**
   ```powershell
   openclaw --version
   ```
   - 确认是否是最新版本
   - 查看版本更新日志中关于 MCP 的变化

3. **查看 OpenClaw 源代码**
   - 如果是开源项目，查看 skill 加载逻辑
   - 了解 MCP 服务器的启动机制

4. **联系 OpenClaw 支持**
   - 提供当前配置文件
   - 询问正确的 MCP 自动启动配置方法

5. **查看其他 MCP skill 的配置**
   - 检查 `C:\Users\Administrator\.openclaw\skills\` 中其他 skill
   - 看是否有成功自动启动的 MCP skill
   - 对比配置差异

## 总结

虽然无法实现 OpenClaw Gateway 自动启动 MCP 服务器，但通过提供的脚本工具，我们已经将启动过程简化到一条命令。

**当前最佳实践：**
- 使用 `start-openclaw-with-mcp-auto.ps1` 一键启动
- MCP 服务器在后台运行（最小化窗口）
- 使用 `check-gateway-and-mcp.ps1` 随时检查状态
- 使用 `stop-openclaw-and-mcp.ps1` 停止所有服务

这个方案虽然不是完全自动，但已经非常接近，并且稳定可靠。

## 文件清单

已创建的工具脚本：

1. `start-openclaw-with-mcp-auto.ps1` - 一键启动（自动模式）
2. `check-gateway-and-mcp.ps1` - 状态检查
3. `stop-openclaw-and-mcp.ps1` - 停止所有服务
4. `test-mcp-manual-start.ps1` - 手动启动 MCP 服务器
5. `monitor-mcp-startup.ps1` - 监控 MCP 启动
6. `MCP_FINAL_SOLUTION.md` - 完整解决方案文档
7. `MCP_AUTO_START_INVESTIGATION.md` - 本调查报告

## 配置文件位置

- OpenClaw 配置：`C:\Users\Administrator\.openclaw\openclaw.json`
- MCP 配置：`C:\Users\Administrator\.openclaw\settings\mcp.json`
- MCP 服务器：`C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`
- 备份文件：`C:\Users\Administrator\.openclaw\*.backup*`
