# OpenClaw MCP 工具加载配置指南

## 配置状态：✅ 已完成

OpenClaw 已正确配置，可以加载 Playwright Browser MCP 工具。

## 已完成的配置步骤

### 1. 目录重命名 ✅
```
旧目录：C:\Users\Administrator\.openclaw\skills\playwright-browser
新目录：C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
```

### 2. MCP 配置更新 ✅
配置文件：`C:\Users\Administrator\.openclaw\settings\mcp.json`

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:\\Users\\Administrator\\.openclaw\\skills\\playwright-browser-skill\\dist\\mcp-server.js"
      ],
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

### 3. MCP 服务器验证 ✅
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

## 下一步操作

### 1. 重启 OpenClaw Gateway

**重要：** 必须重启 OpenClaw 才能加载新的 MCP 配置。

**方法 1：完全重启 OpenClaw**
1. 完全关闭 OpenClaw 应用
2. 重新启动 OpenClaw

**方法 2：重启 Gateway（如果支持）**
- 在 OpenClaw 设置中查找 "重启 Gateway" 或类似选项

### 2. 验证 MCP 服务器状态

重启后，在 OpenClaw 中：

1. **打开 MCP Server 视图**
   - 通常在侧边栏或设置中
   - 查找 "MCP Servers" 或 "Model Context Protocol"

2. **检查服务器状态**
   - 应该看到 `playwright-browser` 服务器
   - 状态应该显示为 "Connected" 或 "运行中"
   - 如果显示错误，查看错误信息

3. **查看可用工具**
   - 应该列出 101 个浏览器自动化工具
   - 工具名称以 `playwright_` 或 `browser_` 开头

### 3. 测试 MCP 工具

在 OpenClaw 对话中测试：

**测试 1：基本浏览器操作**
```
请使用 Playwright Browser Skill 启动浏览器并访问 example.com
```

**测试 2：截图功能**
```
打开 https://example.com 并截图
```

**测试 3：页面内容提取**
```
访问 https://example.com 并获取页面标题
```

如果这些命令能正常工作，说明 MCP 工具已正确加载。

## 常见问题排查

### 问题 1：MCP 服务器显示 "未连接" 或 "错误"

**可能原因：**
- OpenClaw 未重启
- 路径配置错误
- Node.js 不在 PATH 中

**解决方法：**

1. **确认路径正确**
   ```cmd
   dir C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js
   ```
   应该显示文件存在

2. **手动测试 MCP 服务器**
   ```cmd
   node C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js
   ```
   应该显示启动信息

3. **检查 Node.js**
   ```cmd
   node --version
   ```
   应该显示 v18.0.0 或更高版本

4. **重启 OpenClaw**
   完全关闭并重新启动

### 问题 2：OpenClaw 找不到工具

**可能原因：**
- MCP 服务器未启动
- 配置文件格式错误
- disabled 设置为 true

**解决方法：**

1. **检查 mcp.json 格式**
   确保 JSON 格式正确，没有语法错误

2. **确认 disabled 为 false**
   ```json
   "disabled": false
   ```

3. **查看 OpenClaw 日志**
   - 打开开发者工具（Help > Toggle Developer Tools）
   - 查看 Console 标签页
   - 搜索 "playwright" 或 "mcp" 相关错误

### 问题 3：工具调用失败

**可能原因：**
- Playwright 浏览器未安装
- 权限问题
- 依赖缺失

**解决方法：**

1. **安装 Playwright 浏览器**
   ```cmd
   cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
   npx playwright install
   ```

2. **检查依赖**
   ```cmd
   cd C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
   dir node_modules\playwright
   ```
   应该显示 playwright 目录存在

3. **查看详细错误**
   在 OpenClaw 中查看工具调用的详细错误信息

### 问题 4：autoApprove 不生效

**可能原因：**
- 工具名称不匹配
- 配置未生效

**解决方法：**

1. **检查工具名称**
   autoApprove 中的工具名称必须与实际工具名称完全匹配

2. **重启 OpenClaw**
   配置更改需要重启才能生效

3. **手动批准**
   如果 autoApprove 不生效，可以在工具调用时手动批准

## 配置文件位置

### MCP 配置
- **用户级别：** `C:\Users\Administrator\.openclaw\settings\mcp.json`
- **工作区级别：** `<workspace>\.kiro\settings\mcp.json`

### Skill 文件
- **安装目录：** `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\`
- **Skill 文档：** `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\SKILL.md`
- **MCP 服务器：** `C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js`

### OpenClaw 配置
- **主配置：** `C:\Users\Administrator\.openclaw\openclaw.json`

## 高级配置

### 添加更多 autoApprove 工具

如果你想自动批准更多工具，编辑 mcp.json：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close",
        "browser_click",
        "browser_type",
        "browser_screenshot",
        "browser_wait",
        "browser_scroll"
      ]
    }
  }
}
```

### 配置环境变量

如果需要设置环境变量：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "env": {
        "PLAYWRIGHT_BROWSERS_PATH": "C:\\playwright-browsers",
        "DEBUG": "pw:api"
      }
    }
  }
}
```

### 禁用 MCP 服务器

如果需要临时禁用：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "disabled": true
    }
  }
}
```

## 验证清单

完成配置后，确认以下项目：

- [ ] 目录已重命名为 `playwright-browser-skill`
- [ ] mcp.json 配置已更新
- [ ] 路径指向正确的 mcp-server.js
- [ ] disabled 设置为 false
- [ ] OpenClaw 已重启
- [ ] MCP Server 视图显示 "Connected"
- [ ] 可以看到 101 个工具
- [ ] 测试命令能正常工作

## 获取帮助

如果遇到问题：

1. **查看文档**
   - [OpenClaw MCP 指南](OPENCLAW_MCP_GUIDE.md)
   - [MCP 配置修复指南](MCP_CONFIG_FIX.md)
   - [Windows 使用指南](WINDOWS_GUIDE.md)

2. **查看日志**
   - OpenClaw 开发者工具 Console
   - MCP 服务器输出

3. **提交 Issue**
   - GitHub: https://github.com/91fapiao-cn/playwright-browser-skill/issues

4. **联系支持**
   - Email: 91fapiao@gmail.com

## 总结

✅ 目录已重命名
✅ MCP 配置已更新
✅ MCP 服务器可以正常启动
✅ 配置文件格式正确

现在只需要重启 OpenClaw，MCP 工具就会自动加载！
