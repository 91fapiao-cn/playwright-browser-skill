# MCP 服务器未自动启动问题排查

## 问题描述
Gateway 重启后，playwright-browser MCP 服务器没有自动启动。

## 可能的原因和解决方案

### 1. MCP 配置文件格式问题

检查 `C:\Users\Administrator\.openclaw\settings\mcp.json` 的格式：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"
      ],
      "disabled": false,
      "autoApprove": ["playwright_*"]
    }
  }
}
```

**关键点：**
- `command` 应该是 `"node"`（不是 `"playwright-browser-mcp"`）
- `args` 数组第一个元素应该是 `mcp-server.js` 的完整路径
- Windows 路径需要使用双反斜杠 `\\` 或单正斜杠 `/`
- `disabled` 必须是 `false`

### 2. Node.js 路径问题

确认 `node` 命令在系统 PATH 中：

```cmd
where node
```

如果 `node` 不在 PATH 中，需要使用完整路径：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "C:\\Program Files\\nodejs\\node.exe",
      "args": ["C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["playwright_*"]
    }
  }
}
```

### 3. 文件权限问题

确认 `dist/mcp-server.js` 有执行权限（虽然在 Windows 上通常不是问题）。

### 4. 依赖安装问题

确认 node_modules 已正确安装：

```cmd
cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
dir node_modules
```

如果缺少依赖，重新安装：

```cmd
npm install
```

### 5. OpenClaw 日志检查

查看 OpenClaw 的日志文件，通常在：
- `C:\Users\Administrator\.openclaw\logs\`
- 或者在 OpenClaw 的开发者工具控制台中

查找与 MCP 服务器启动相关的错误信息。

### 6. 手动测试 MCP 服务器

在命令行中手动启动 MCP 服务器，查看是否有错误：

```cmd
cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
node dist/mcp-server.js
```

如果有错误输出，这将帮助定位问题。

### 7. 配置文件位置问题

确认配置文件在正确的位置：
- 用户级别：`C:\Users\Administrator\.openclaw\settings\mcp.json`
- 工作区级别：`<workspace>\.kiro\settings\mcp.json`

OpenClaw 会合并这些配置，工作区配置优先级更高。

## 推荐的调试步骤

1. **验证 Node.js 可用性**
   ```cmd
   node --version
   ```

2. **手动测试 MCP 服务器**
   ```cmd
   node C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js
   ```
   
3. **检查 MCP 配置格式**
   - 确保 JSON 格式正确（没有多余的逗号、括号匹配等）
   - 确保路径使用正确的分隔符

4. **查看 OpenClaw 日志**
   - 在 OpenClaw 中打开开发者工具（Help > Toggle Developer Tools）
   - 查看 Console 标签页中的错误信息

5. **尝试简化配置**
   ```json
   {
     "mcpServers": {
       "playwright-browser": {
         "command": "node",
         "args": ["C:/Users/Administrator/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js"]
       }
     }
   }
   ```

## 常见错误和解决方案

### 错误：Cannot find module
**原因：** node_modules 未安装或路径不正确
**解决：** 运行 `npm install`

### 错误：command not found
**原因：** node 不在 PATH 中
**解决：** 使用 node.exe 的完整路径

### 错误：Permission denied
**原因：** 文件权限问题
**解决：** 以管理员身份运行 OpenClaw

### 服务器启动但无响应
**原因：** MCP 协议通信问题
**解决：** 检查 stdin/stdout 是否被其他程序占用

## 下一步

请执行以下操作并反馈结果：

1. 手动运行 MCP 服务器，看是否有错误输出
2. 检查 OpenClaw 的开发者工具控制台
3. 确认 mcp.json 的格式是否正确
4. 提供任何错误信息或日志

这将帮助我们进一步诊断问题。
