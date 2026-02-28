# 创建 GitHub Release 指南

## 当前状态

✅ Windows 发行版已生成：
- 文件：`releases/playwright-browser-skill-windows-v2.1.0.zip`
- 大小：9.41 MB
- 位置：`D:\newSkill\releases\`

⏳ Mac/Linux 发行版待生成（可选，如果你有 Mac/Linux 环境）

## 创建 Release 步骤

### 方法一：通过 GitHub 网页界面（推荐）

1. **访问 Releases 页面**
   - 打开：https://github.com/91fapiao-cn/playwright-browser-skill/releases
   - 点击 "Create a new release" 按钮

2. **创建 Tag**
   - 在 "Choose a tag" 下拉框中输入：`v2.1.0`
   - 点击 "Create new tag: v2.1.0 on publish"

3. **填写 Release 信息**
   
   **Release title（发布标题）：**
   ```
   v2.1.0 - 独立发行版首发 🎉
   ```

   **Description（发布说明）：**
   ```markdown
   # Playwright Browser Skill v2.1.0

   ## 🎉 重大更新

   首次提供**独立发行版**！无需 npm install 和构建，开箱即用！

   ## ✨ 新特性

   - 🚀 提供 Windows 独立发行版（开箱即用）
   - 📦 包含完整依赖，无需 npm install
   - ⚡ 一键自动部署脚本
   - 📚 完整的中英文文档
   - 🌍 跨平台自动部署支持

   ## 📥 下载

   ### Windows 用户（推荐）
   下载 `playwright-browser-skill-windows-v2.1.0.zip`（9.41 MB）

   **安装步骤：**
   1. 解压 ZIP 文件到任意目录
   2. 双击运行 `auto-deploy.cmd`（推荐）
      - 或者：打开命令提示符，运行 `auto-deploy.cmd`
      - 或者：如果熟悉 PowerShell，运行 `.\auto-deploy.ps1`
   3. 重启 OpenClaw
   4. 开始使用！

   **注意：** 推荐使用 `.cmd` 文件，因为大部分 Windows 电脑默认禁止运行 PowerShell 脚本。

   ### Mac/Linux 用户
   暂时请使用源码安装：
   ```bash
   git clone https://github.com/91fapiao-cn/playwright-browser-skill.git
   cd playwright-browser-skill
   npm install
   npm run build
   ./auto-deploy.sh
   ```

   ## 📖 文档

   - [完整文档](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/README.md)
   - [发行版使用指南](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/RELEASE_GUIDE.md)
   - [Windows 使用指南](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/WINDOWS_GUIDE.md)
   - [配置指南](https://github.com/91fapiao-cn/playwright-browser-skill/blob/main/CONFIGURATION_GUIDE.md)

   ## 🎯 功能特性

   - 🌐 完整的浏览器控制（Chromium、Firefox、WebKit）
   - 📱 设备模拟（iPhone、Android 等）
   - 🎯 智能选择器（CSS、ARIA、文本等）
   - 📸 截图和录制（页面、元素、PDF、视频）
   - 🌍 网络控制（请求拦截、响应模拟）
   - 🔍 内容提取（文本、HTML、链接等）
   - ⚡ 性能监控
   - 🎨 高级功能（Cookie、LocalStorage、地理位置等）

   ## 📊 工具统计

   - **101 个浏览器操作工具**
   - 8 个浏览器管理工具
   - 4 个页面导航工具
   - 12 个元素交互工具
   - 11 个内容提取工具
   - 更多高级功能...

   ## 🆚 发行版 vs 源码安装

   | 特性 | 发行版 | 源码安装 |
   |------|--------|---------|
   | 安装时间 | 1-2 分钟 | 5-10 分钟 |
   | 需要 npm install | ❌ 否 | ✅ 是 |
   | 需要构建 | ❌ 否 | ✅ 是 |
   | 下载大小 | ~9 MB | ~500 KB |
   | 适用人群 | 所有用户 | 开发者 |

   ## 🔧 系统要求

   - Windows 10/11
   - Node.js 18 或更高版本
   - OpenClaw AI 助手

   ## 📝 更新日志

   ### v2.1.0 (2026-02-28)
   - 🚀 新增跨平台自动部署脚本
   - 🔍 自动检测 OpenClaw 配置路径
   - 💾 自动备份现有配置
   - 📦 支持自定义安装路径
   - 📚 完整的自动部署文档
   - 🎁 首次提供独立发行版

   ### v2.0.0
   - ✨ 新增 88 个完整的浏览器操作工具
   - 📚 完整的中文文档
   - 🪟 Windows 平台完整支持

   ## 🙏 致谢

   感谢所有使用和支持本项目的用户！

   ## 📞 支持

   - 📧 Email: 91fapiao@gmail.com
   - 🐛 Issues: https://github.com/91fapiao-cn/playwright-browser-skill/issues
   - 💬 Discussions: https://github.com/91fapiao-cn/playwright-browser-skill/discussions

   ---

   **Made with ❤️ for OpenClaw Community**
   ```

4. **上传文件**
   - 在 "Attach binaries" 区域
   - 拖拽或点击上传：`releases/playwright-browser-skill-windows-v2.1.0.zip`
   - 等待上传完成

5. **发布**
   - 勾选 "Set as the latest release"
   - 点击 "Publish release" 按钮

### 方法二：使用 GitHub CLI（需要安装 gh）

```bash
# 创建 Release
gh release create v2.1.0 \
  releases/playwright-browser-skill-windows-v2.1.0.zip \
  --title "v2.1.0 - 独立发行版首发 🎉" \
  --notes-file RELEASE_NOTES.md

# 或者使用交互式创建
gh release create v2.1.0 --generate-notes
```

## 创建 Release 后

### 1. 验证 Release
- 访问：https://github.com/91fapiao-cn/playwright-browser-skill/releases
- 确认 v2.1.0 显示为 "Latest"
- 确认 ZIP 文件可以下载

### 2. 更新 README 中的下载链接

当前 README 中的链接是占位符：
```markdown
[playwright-browser-skill-windows-v2.1.0.zip](https://github.com/91fapiao-cn/playwright-browser-skill/releases)
```

需要更新为实际的下载链接：
```markdown
[playwright-browser-skill-windows-v2.1.0.zip](https://github.com/91fapiao-cn/playwright-browser-skill/releases/download/v2.1.0/playwright-browser-skill-windows-v2.1.0.zip)
```

### 3. 测试下载
- 点击 README 中的下载链接
- 确认可以正常下载 ZIP 文件
- 测试解压和安装流程

### 4. 宣传推广
- 在项目 README 顶部添加 Release 徽章
- 在社区分享发布消息
- 更新相关文档链接

## 后续版本发布

当需要发布新版本时：

1. **更新版本号**
   ```bash
   # 编辑 package.json
   # 更新 version 字段
   ```

2. **构建新版本**
   ```bash
   npm run build
   .\build-release.ps1 -Version "2.2.0"
   ```

3. **创建新 Release**
   - 重复上述步骤
   - 使用新的 tag：`v2.2.0`
   - 上传新的 ZIP 文件

## 常见问题

### Q: 如何删除错误的 Release？
A: 在 Release 页面点击 "Delete" 按钮，然后删除对应的 tag。

### Q: 如何编辑已发布的 Release？
A: 在 Release 页面点击 "Edit release" 按钮。

### Q: 如何添加 Mac/Linux 版本？
A: 
1. 在 Mac/Linux 环境运行：`./build-release.sh 2.1.0`
2. 编辑现有 Release
3. 上传生成的 tar.gz 文件

### Q: Release 文件大小限制？
A: GitHub 单个文件限制 2 GB，我们的 9 MB 完全没问题。

## 相关文档

- [BUILD_RELEASE.md](BUILD_RELEASE.md) - 打包指南
- [RELEASE_GUIDE.md](RELEASE_GUIDE.md) - 用户使用指南
- [RELEASE_SUMMARY.md](RELEASE_SUMMARY.md) - 技术总结

---

**准备好了吗？** 现在就去创建你的第一个 Release 吧！🚀
