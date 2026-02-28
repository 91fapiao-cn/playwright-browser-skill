# 快速安装指南 | Quick Install Guide

## 中文版

### Windows 用户（3 步完成）

1. **下载** → [点击下载 ZIP](https://github.com/91fapiao-cn/playwright-browser-skill/releases)
2. **解压** → 解压到任意目录
3. **双击** → 双击运行 `auto-deploy.cmd`
4. **重启** → 重启 OpenClaw

✅ 完成！

### Mac/Linux 用户

```bash
# 下载并解压
tar -xzf playwright-browser-skill-*.tar.gz
cd playwright-browser-skill-*

# 运行部署
chmod +x auto-deploy.sh
./auto-deploy.sh

# 重启 OpenClaw
```

---

## English Version

### Windows Users (3 Steps)

1. **Download** → [Click to download ZIP](https://github.com/91fapiao-cn/playwright-browser-skill/releases)
2. **Extract** → Extract to any directory
3. **Double-click** → Double-click `auto-deploy-en.cmd`
4. **Restart** → Restart OpenClaw

✅ Done!

### Mac/Linux Users

```bash
# Download and extract
tar -xzf playwright-browser-skill-*.tar.gz
cd playwright-browser-skill-*

# Run deployment
chmod +x auto-deploy-en.sh
./auto-deploy-en.sh

# Restart OpenClaw
```

---

## 常见问题 | FAQ

### ❓ 为什么推荐 .cmd 而不是 .ps1？

**中文：** 大部分 Windows 电脑默认禁止运行 PowerShell 脚本（.ps1），但 CMD 批处理文件（.cmd）没有这个限制，可以直接双击运行。

**English:** Most Windows computers block PowerShell scripts (.ps1) by default, but CMD batch files (.cmd) have no such restriction and can be run directly by double-clicking.

### ❓ 双击 .cmd 文件没反应？

**中文：** 
1. 右键点击 `auto-deploy.cmd`
2. 选择"以管理员身份运行"
3. 或者打开命令提示符，手动运行：`auto-deploy.cmd`

**English:**
1. Right-click `auto-deploy-en.cmd`
2. Select "Run as administrator"
3. Or open Command Prompt and run manually: `auto-deploy-en.cmd`

### ❓ 提示找不到 Node.js？

**中文：** 需要先安装 Node.js 18 或更高版本：
- 访问：https://nodejs.org/
- 下载并安装 LTS 版本
- 重启电脑后重新运行部署脚本

**English:** You need to install Node.js 18 or higher first:
- Visit: https://nodejs.org/
- Download and install LTS version
- Restart computer and re-run deployment script

### ❓ 如何验证安装成功？

**中文：**
1. 重启 OpenClaw
2. 在对话中输入：`请使用 Playwright Browser Skill 启动浏览器`
3. 如果浏览器启动，说明安装成功

**English:**
1. Restart OpenClaw
2. In chat, type: `Please use Playwright Browser Skill to launch browser`
3. If browser launches, installation is successful

---

## 安装方法对比 | Installation Methods Comparison

| 方法 Method | 难度 Difficulty | 推荐度 Recommended | 说明 Notes |
|------------|----------------|-------------------|-----------|
| 双击 .cmd<br>Double-click .cmd | ⭐ 最简单<br>Easiest | ✅✅✅ | 无需任何命令<br>No commands needed |
| 命令提示符<br>Command Prompt | ⭐⭐ 简单<br>Easy | ✅✅ | 需要打开终端<br>Requires terminal |
| PowerShell | ⭐⭐⭐ 中等<br>Medium | ✅ | 可能需要权限<br>May need permissions |
| 手动部署<br>Manual | ⭐⭐⭐⭐ 复杂<br>Complex | ❌ | 仅供高级用户<br>Advanced users only |

---

## 获取帮助 | Get Help

- 📚 完整文档：[README.md](README.md)
- 📖 详细指南：[RELEASE_GUIDE.md](RELEASE_GUIDE.md)
- 🐛 问题反馈：[GitHub Issues](https://github.com/91fapiao-cn/playwright-browser-skill/issues)
- 📧 邮件支持：91fapiao@gmail.com

---

**Made with ❤️ for OpenClaw Community**
