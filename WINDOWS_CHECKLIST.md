# Windows 部署检查清单

使用此清单确保在 Windows 上正确部署 Playwright Browser Skill。

## 📋 安装前检查

- [ ] Windows 10 或更高版本
- [ ] 至少 2GB 可用磁盘空间
- [ ] 管理员权限（用于安装）
- [ ] 稳定的网络连接（用于下载浏览器）

## 🔧 环境检查

### Node.js 和 npm

```cmd
node --version
```
- [ ] Node.js 版本 >= 18.0.0

```cmd
npm --version
```
- [ ] npm 已安装

### 项目目录

- [ ] 项目已下载或克隆
- [ ] 进入项目目录
- [ ] 路径中没有中文字符（推荐）
- [ ] 路径中没有空格（推荐）

## 📦 安装步骤

### 1. 运行自动化测试

```powershell
.\test-windows.ps1
```

或

```cmd
test-windows.cmd
```

检查输出：
- [ ] Node.js 检查通过
- [ ] npm 检查通过
- [ ] 依赖安装成功
- [ ] 浏览器下载成功
- [ ] 项目构建成功
- [ ] 关键文件存在
- [ ] 基础测试通过
- [ ] 配置示例生成

### 2. 手动安装（如果自动化失败）

```cmd
npm install
```
- [ ] 依赖安装成功（无错误）

```cmd
npx playwright install chromium
```
- [ ] Chromium 下载成功

```cmd
npm run build
```
- [ ] TypeScript 编译成功
- [ ] `dist` 目录已创建
- [ ] `dist\mcp-server.js` 存在
- [ ] `dist\index.js` 存在

## ⚙️ 配置步骤

### 1. MCP 配置

创建或编辑 `.kiro\settings\mcp.json`：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["完整路径\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
```

检查：
- [ ] 文件路径正确
- [ ] 使用了双反斜杠 `\\` 或单正斜杠 `/`
- [ ] 使用了绝对路径（不是相对路径）
- [ ] JSON 格式正确（无语法错误）

### 2. Skill 文件

```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%.openclaw\skills\
```

检查：
- [ ] 文件复制成功
- [ ] 目标目录存在
- [ ] 文件内容完整

## 🧪 测试步骤

### 1. 基础测试

```cmd
node dist\test\basic-test.js
```

检查输出：
- [ ] 浏览器启动成功
- [ ] 页面导航成功
- [ ] 获取标题成功
- [ ] 获取 HTML 成功
- [ ] 获取链接成功
- [ ] 截图成功
- [ ] JavaScript 执行成功
- [ ] 元素查询成功
- [ ] Cookie 操作成功
- [ ] 浏览器关闭成功

### 2. MCP 服务器测试

```cmd
node dist\mcp-server.js
```

检查：
- [ ] 服务器启动无错误
- [ ] 显示"已启动"消息
- [ ] 显示工具数量
- [ ] 按 Ctrl+C 可以停止

### 3. OpenClaw 集成测试

启动 OpenClaw 后：

```
启动浏览器，访问 example.com，获取页面标题
```

检查：
- [ ] OpenClaw 识别到 skill
- [ ] 浏览器成功启动
- [ ] 页面成功加载
- [ ] 返回了页面标题
- [ ] 无错误消息

## 🔍 故障排除

### 如果测试失败

- [ ] 查看错误消息
- [ ] 检查 [WINDOWS_GUIDE.md](./WINDOWS_GUIDE.md) 的"常见问题"
- [ ] 检查 [WINDOWS_COMPATIBILITY.md](./WINDOWS_COMPATIBILITY.md) 的"已知问题"
- [ ] 重新运行 `npm install`
- [ ] 重新运行 `npm run build`
- [ ] 以管理员身份运行

### 如果浏览器启动失败

```cmd
npx playwright install --force
```

- [ ] 重新下载浏览器
- [ ] 检查磁盘空间
- [ ] 检查网络连接

### 如果路径错误

- [ ] 使用绝对路径
- [ ] 使用双反斜杠 `\\`
- [ ] 或使用单正斜杠 `/`
- [ ] 避免路径中的空格和中文

## 🔒 安全检查

### 防火墙

- [ ] 允许 Node.js 访问网络
- [ ] 允许浏览器进程访问网络
- [ ] 首次运行时点击"允许访问"

### 杀毒软件

- [ ] 将项目目录添加到白名单（可选）
- [ ] 或临时禁用实时保护进行测试

### 权限

- [ ] 项目目录有读写权限
- [ ] 用户目录（.kiro）有读写权限

## 📊 性能检查

### 启动时间

- [ ] 浏览器启动 < 5 秒
- [ ] 页面加载 < 3 秒
- [ ] 截图生成 < 1 秒

### 资源使用

- [ ] 内存占用 < 500MB
- [ ] CPU 使用率正常
- [ ] 磁盘空间充足

## 📝 文档检查

确保已阅读：

- [ ] [README_WINDOWS.md](./README_WINDOWS.md) - Windows 用户必读
- [ ] [QUICK_START_WINDOWS.md](./QUICK_START_WINDOWS.md) - 快速开始
- [ ] [WINDOWS_GUIDE.md](./WINDOWS_GUIDE.md) - 详细指南（至少浏览一遍）

## ✅ 最终验证

### 功能验证

在 OpenClaw 中测试以下功能：

- [ ] 启动浏览器
- [ ] 访问网页
- [ ] 获取页面标题
- [ ] 获取页面内容
- [ ] 点击元素
- [ ] 填写表单
- [ ] 截图
- [ ] 关闭浏览器

### 稳定性验证

- [ ] 连续运行 3 次无错误
- [ ] 浏览器正常关闭
- [ ] 无内存泄漏
- [ ] 无僵尸进程

## 🎉 完成

如果所有项目都已勾选，恭喜你！Playwright Browser Skill 已成功部署在 Windows 上。

### 下一步

- 探索更多功能（查看 [FEATURES.md](./FEATURES.md)）
- 阅读 API 文档（查看 [API.md](./API.md)）
- 尝试高级功能（查看 [WINDOWS_GUIDE.md](./WINDOWS_GUIDE.md)）

## 📞 需要帮助？

如果有任何项目未通过：

1. 查看相关文档的故障排除部分
2. 重新运行测试脚本
3. 检查错误消息
4. 提交 GitHub Issue

---

**提示**：保存此清单，以便将来参考或在其他 Windows 机器上部署时使用。
