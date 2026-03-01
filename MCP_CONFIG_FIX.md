# MCP 配置修复方案

## 问题诊断结果

✅ **MCP 服务器可以正常启动**
```
Playwright Browser MCP Server v2.1 已启动
已注册 101 个工具，覆盖 100% 浏览器自动化场景
```

❌ **问题原因：旧版本部署脚本使用了错误的目录名**

旧版本部署脚本使用的目录名：
```
C:\Users\Administrator\.openclaw\skills\playwright-browser
```

正确的目录名（与发行版包名一致）：
```
C:\Users\Administrator\.openclaw\skills\playwright-browser-skill
```

**已修复：** 所有部署脚本已更新为使用 `playwright-browser-skill` 作为目录名，与发行版包名保持一致。

## 修复步骤

### 方法 1：重新部署（推荐）

使用更新后的部署脚本重新部署：

```cmd
# Windows
.\auto-deploy-en.cmd

# 或 PowerShell
.\auto-deploy-en.ps1

# Mac/Linux
./auto-deploy-en.sh
```

部署脚本会自动：
1. 创建正确的目录 `playwright-browser-skill`
2. 复制所有必要文件
3. 生成正确的 mcp.json 配置

### 方法 2：手动修改配置（如果已经部署）

如果你已经使用旧版本脚本部署，可以手动修改配置：

1. 在 OpenClaw 中打开文件：
   ```
   C:\Users\Administrator\.openclaw\settings\mcp.json
   ```

2. 找到 `playwright-browser` 的配置

3. 将路径修改为：
   ```json
   {
     "mcpServers": {
       "playwright-browser": {
         "command": "node",
         "args": [
           "C:/Users/Administrator/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js"
         ],
         "disabled": false,
         "autoApprove": [
           "playwright_navigate",
           "playwright_click",
           "playwright_type",
           "playwright_screenshot",
           "playwright_get_content"
         ]
       }
     }
   }
   ```

4. 重命名已安装的目录：
   ```cmd
   cd C:\Users\Administrator\.openclaw\skills
   move playwright-browser playwright-browser-skill
   ```

5. 重启 OpenClaw Gateway 或在 MCP Server 视图中重新连接服务器

### 方法 3：使用提供的配置文件

我已经创建了正确的配置文件 `mcp-config-fix.json`，你可以：

1. 复制 `mcp-config-fix.json` 的内容
2. 替换或合并到 `C:\Users\Administrator\.openclaw\settings\mcp.json`
3. 确保目录名为 `playwright-browser-skill`
4. 重启 OpenClaw Gateway

## 验证修复

修复后，在 OpenClaw 中：

1. 打开 MCP Server 视图（Kiro 功能面板）
2. 查看 `playwright-browser` 服务器状态应该显示为 "运行中" 或 "Connected"
3. 尝试使用浏览器工具，例如在对话中输入：
   ```
   打开 https://example.com 并截图
   ```

## 关键配置说明

### command 字段
- 必须是 `"node"`（Node.js 可执行文件）
- 如果 node 不在 PATH 中，使用完整路径：`"C:/Program Files/nodejs/node.exe"`

### args 字段
- 第一个参数必须是 `mcp-server.js` 的完整路径
- 路径必须指向 `playwright-browser-skill` 目录
- Windows 路径可以使用：
  - 正斜杠：`C:/Users/...`（推荐）
  - 双反斜杠：`C:\\Users\\...`

### disabled 字段
- 必须是 `false` 才能启用服务器

### autoApprove 字段（可选）
- 列出不需要用户确认的工具名称
- 常用工具建议添加到此列表以提高效率

## 目录命名规范

为了保持一致性，项目使用以下命名规范：

- **发行版包名**：`playwright-browser-skill-windows-v2.1.0.zip`
- **安装目录名**：`playwright-browser-skill`
- **MCP 服务器名**：`playwright-browser`（在 mcp.json 中）

## 下一步

修复配置后，MCP 服务器应该能够自动启动。如果仍有问题，请检查：

1. OpenClaw 的开发者工具控制台（Help > Toggle Developer Tools）
2. 查看是否有其他错误信息
3. 确认 Node.js 版本 >= 18.0.0
4. 确认目录名为 `playwright-browser-skill`

## 测试命令

修复后可以尝试这些命令测试功能：

```
1. 打开网页并截图
2. 搜索页面内容
3. 点击页面元素
4. 填写表单
5. 执行 JavaScript 代码
```

所有 101 个浏览器自动化工具都应该可以正常使用。

## 相关文件

- 部署脚本：`auto-deploy-en.cmd`, `auto-deploy-en.ps1`, `auto-deploy-en.sh`
- 配置示例：`mcp-config-fix.json`
- 详细指南：`OPENCLAW_MCP_GUIDE.md`
