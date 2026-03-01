# OpenClaw MCP 命令参考（推测）

**日期**: 2026-03-01  
**状态**: 基于 MCP 协议标准的推测  
**注意**: 需要查看 OpenClaw 官方文档确认

---

## ⚠️ 重要说明

这个文档是基于 MCP 协议标准和常见实践的推测。OpenClaw 的实际命令格式可能不同。

**建议**:
1. 查看 OpenClaw 官方文档
2. 在 OpenClaw 中输入 `help` 或 `/help` 查看命令列表
3. 查看 OpenClaw 的设置或帮助菜单
4. 尝试不同的命令格式

---

## 🔍 可能的 MCP 调用方式

### 方式 1：自然语言（最可能）

OpenClaw 可能使用 AI 理解自然语言，自动选择和调用 MCP 工具：

```
用户：帮我访问 example.com 并获取页面标题
OpenClaw：[自动调用 browser_launch 和 browser_goto]
```

**优点**:
- 用户友好
- 不需要记住命令
- AI 自动选择最合适的工具

**缺点**:
- 可能不够精确
- 依赖 AI 的理解能力

---

### 方式 2：斜杠命令（常见）

类似 Discord、Slack 等应用的命令格式：

```
/mcp <server_name> <tool_name> [arguments]
```

**示例**:
```
/mcp playwright-browser browser_launch {"headless": false}
/mcp playwright-browser browser_goto {"url": "https://example.com"}
/mcp playwright-browser browser_get_title
```

**变体**:
```
/tool playwright-browser.browser_launch
/call playwright-browser browser_launch
/use playwright-browser browser_launch
```

---

### 方式 3：@提及语法

类似提及用户的语法：

```
@playwright-browser browser_launch
@playwright-browser browser_goto url="https://example.com"
```

---

### 方式 4：函数调用语法

类似编程语言的函数调用：

```
playwright-browser.browser_launch()
playwright-browser.browser_goto("https://example.com")
playwright-browser.browser_get_title()
```

---

### 方式 5：JSON-RPC 格式

标准的 MCP 协议格式（可能在高级模式下使用）：

```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "browser_launch",
    "arguments": {
      "headless": false
    }
  },
  "id": 1
}
```

---

## 📋 可能的命令列表

### 查看可用的 MCP 服务器

```
/mcp list
/mcp servers
/skills list
/tools list
```

### 查看服务器的工具

```
/mcp tools playwright-browser
/mcp describe playwright-browser
/tools playwright-browser
```

### 调用 MCP 工具

```
/mcp call playwright-browser browser_launch
/mcp playwright-browser browser_launch
/tool browser_launch
```

### 查看工具帮助

```
/mcp help playwright-browser browser_launch
/tool help browser_launch
```

---

## 🧪 测试建议

### 1. 查找帮助命令

在 OpenClaw 中尝试：

```
help
/help
?
/commands
/tools
/mcp
/skills
```

### 2. 查看设置菜单

检查 OpenClaw 的：
- 设置 → 命令
- 设置 → 工具
- 设置 → MCP
- 设置 → 技能

### 3. 尝试不同的命令格式

```
# 自然语言
帮我启动浏览器

# 斜杠命令
/mcp playwright-browser browser_launch
/tool browser_launch
/call browser_launch

# @提及
@playwright-browser browser_launch

# 函数调用
playwright-browser.browser_launch()
```

### 4. 查看 OpenClaw 文档

查找：
- 官方网站
- GitHub 仓库
- 用户手册
- API 文档

---

## 📚 MCP 协议标准

### MCP 工具调用流程

根据 MCP 协议标准：

```
1. 客户端（OpenClaw）发送 tools/list 请求
   → 获取所有可用工具

2. 客户端发送 tools/call 请求
   → 调用特定工具

3. 服务器（MCP Server）执行工具
   → 返回结果

4. 客户端接收结果
   → 展示给用户
```

### 标准 MCP 请求格式

```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "browser_launch",
    "arguments": {
      "browserType": "chromium",
      "headless": false
    }
  },
  "id": 1
}
```

### 标准 MCP 响应格式

```json
{
  "jsonrpc": "2.0",
  "result": {
    "content": [
      {
        "type": "text",
        "text": "Browser launched successfully"
      }
    ]
  },
  "id": 1
}
```

---

## 🔧 OpenClaw 配置线索

### 从 openclaw.json 发现

```json
{
  "commands": {
    "native": "auto",
    "nativeSkills": "auto"
  },
  "tools": {},
  "skills": {}
}
```

**推测**:
- `commands.native`: 可能控制内置命令
- `commands.nativeSkills`: 可能控制技能命令
- `tools`: 可能是工具配置
- `skills`: 可能是技能配置

### 从 mcp.json 发现

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["..."],
      "autoApprove": [...]
    }
  }
}
```

**推测**:
- `autoApprove`: 自动批准的工具列表
- 这些工具可能不需要用户确认就能调用

---

## 💡 实用建议

### 1. 从简单开始

先尝试最简单的自然语言：

```
帮我打开浏览器
访问 example.com
获取页面标题
```

### 2. 逐步明确

如果不工作，逐步增加明确性：

```
使用浏览器技能打开浏览器
使用 Playwright Browser Skill 访问 example.com
调用 playwright-browser 的 browser_launch 工具
```

### 3. 查看反馈

注意 OpenClaw 的响应：
- 错误消息可能包含正确的命令格式
- 提示信息可能告诉你如何调用
- 自动补全可能显示可用命令

### 4. 查看日志

如果 OpenClaw 有日志功能：
- 查看 MCP 调用日志
- 查看工具调用记录
- 查看错误日志

---

## 📖 参考资源

### OpenClaw 相关

- OpenClaw 官方网站
- OpenClaw GitHub 仓库
- OpenClaw 用户文档
- OpenClaw 社区论坛

### MCP 协议相关

- MCP 协议规范：https://modelcontextprotocol.io/
- MCP GitHub：https://github.com/modelcontextprotocol
- MCP 示例：https://github.com/modelcontextprotocol/servers

---

## 🎯 下一步行动

### 1. 查找 OpenClaw 文档

最可靠的方法是查看官方文档：
- 搜索 "OpenClaw MCP 使用"
- 搜索 "OpenClaw 命令列表"
- 搜索 "OpenClaw 工具调用"

### 2. 在 OpenClaw 中探索

尝试各种命令：
- 输入 `help`
- 输入 `/`（可能触发命令补全）
- 查看设置菜单
- 查看工具列表

### 3. 查看 OpenClaw 源代码

如果 OpenClaw 是开源的：
- 查看命令处理代码
- 查看 MCP 集成代码
- 查看示例和测试

### 4. 询问 OpenClaw 社区

- 在 OpenClaw 论坛提问
- 在 GitHub Issues 搜索
- 在 Discord/Slack 社区询问

---

## 📝 总结

### 最可能的调用方式

根据现代 AI 助手的设计趋势，OpenClaw 最可能使用：

1. **自然语言**（最推荐）
   ```
   帮我访问 example.com
   ```

2. **斜杠命令**（如果支持）
   ```
   /mcp playwright-browser browser_launch
   ```

3. **@提及**（如果支持）
   ```
   @playwright-browser browser_launch
   ```

### 如何确认

1. 查看 OpenClaw 官方文档
2. 在 OpenClaw 中输入 `help` 或 `/help`
3. 尝试不同的命令格式
4. 观察 OpenClaw 的反馈和提示

### 当前状态

- ✅ MCP 服务器已注册（playwright-browser）
- ✅ 技能状态：Ready
- ✅ 工具数量：101 个
- ❓ 调用方式：待确认

**建议**: 先尝试自然语言描述任务，如果不工作，再尝试其他命令格式。
