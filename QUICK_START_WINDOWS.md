# Windows 快速开始指南

## 🎯 5 分钟快速部署

### 步骤 1：运行自动化测试

打开命令提示符（CMD）或 PowerShell，进入项目目录：

```cmd
cd D:\your-path\playwright-browser-skill
test-windows.cmd
```

或使用 PowerShell：

```powershell
cd D:\your-path\playwright-browser-skill
.\test-windows.ps1
```

### 步骤 2：复制 MCP 配置

测试脚本会生成配置示例，**创建或编辑** `%USERPROFILE%.openclaw\settings\mcp.json`：

**重要**：这个文件在 OpenClaw 配置目录，不是项目目录！

完整路径：`C:\Users\你的用户名.openclaw\settings\mcp.json`

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["D:\\your-path\\playwright-browser-skill\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

**重要**：将 `D:\\your-path\\` 替换为你的**项目目录**的实际路径！

### 步骤 3：复制 Skill 文件

从项目目录复制到 OpenClaw 配置目录：

```cmd
REM 在项目目录运行
copy .kiro\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

或手动复制：
- **源文件**：`项目目录.openclaw\skills\playwright-browser.md`
- **目标位置**：`C:\Users\你的用户名.openclaw\skills\playwright-browser.md`

### 步骤 4：重启 OpenClaw

关闭并重新启动 OpenClaw。

### 步骤 5：测试

在 OpenClaw 中输入：

```
启动浏览器，访问 example.com，获取页面标题
```

## ✅ 验证安装

如果看到类似输出，说明安装成功：

```json
{
  "success": true,
  "title": "Example Domain"
}
```

## 🐛 常见问题

### 问题：找不到模块

**错误**：`Cannot find module 'D:\...\dist\mcp-server.js'`

**解决**：
1. 确认已运行 `npm run build`
2. 检查路径是否正确（使用 `\\` 或 `/`）
3. 使用绝对路径

### 问题：浏览器启动失败

**错误**：`Executable doesn't exist`

**解决**：
```cmd
npx playwright install chromium
```

### 问题：权限错误

**解决**：以管理员身份运行命令提示符

## 📚 更多信息

- **详细指南**：[WINDOWS_GUIDE.md](./WINDOWS_GUIDE.md)
- **兼容性报告**：[WINDOWS_COMPATIBILITY.md](./WINDOWS_COMPATIBILITY.md)
- **API 文档**：[API.md](./API.md)

## 💡 使用示例

### 示例 1：网页截图

```
打开浏览器，访问 github.com，截图保存
```

### 示例 2：表单填写

```
启动浏览器，访问 google.com，搜索 "playwright"
```

### 示例 3：数据提取

```
打开浏览器，访问 example.com，获取所有链接
```

## 🎉 完成！

现在你可以在 Windows 上使用 Playwright Browser Skill 了！

有问题？查看 [WINDOWS_GUIDE.md](./WINDOWS_GUIDE.md) 获取详细帮助。
