# Skill 目录结构说明

## 🤔 问题

`.openclaw\skills\` 目录下，skill 文件应该如何组织？

## 📁 两种可能的结构

### 方式 1：直接放在 skills 目录（推荐）

```
C:\Users\你的用户名\.openclaw\
└── skills\
    ├── playwright-browser.md
    ├── another-skill.md
    └── third-skill.md
```

**特点**：
- 每个 skill 一个 `.md` 文件
- 文件名与 skill 的 `name` 字段对应
- 简单直接

**复制命令**：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

### 方式 2：每个 skill 一个文件夹

```
C:\Users\你的用户名\.openclaw\
└── skills\
    ├── playwright-browser\
    │   └── skill.md (或 playwright-browser.md)
    ├── another-skill\
    │   └── skill.md
    └── third-skill\
        └── skill.md
```

**特点**：
- 每个 skill 有独立的文件夹
- 可以包含额外的资源文件
- 更有组织性

**复制命令**：
```cmd
REM 创建 skill 文件夹
mkdir %USERPROFILE%\.openclaw\skills\playwright-browser

REM 复制 skill 文件
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\skill.md
```

或保持原文件名：
```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md
```

## 🔍 如何确定正确的方式？

### 方法 1：查看 OpenClaw 文档

查看 OpenClaw 的官方文档或示例。

### 方法 2：检查现有的 skills

如果你已经有其他 skills，查看它们的组织方式：

```cmd
dir %USERPROFILE%\.openclaw\skills\
```

### 方法 3：两种方式都试试

1. 先尝试方式 1（直接放在 skills 目录）
2. 重启 OpenClaw
3. 检查 OpenClaw 是否识别到 skill
4. 如果不行，再尝试方式 2

## 💡 推荐做法

根据 skill 文件的 frontmatter：

```yaml
---
name: playwright-browser
description: ...
version: 1.0.0
---
```

我**推荐使用方式 1**（直接放在 skills 目录），因为：

1. **文件名与 name 对应**：`playwright-browser.md` 对应 `name: playwright-browser`
2. **简单直接**：不需要额外的文件夹结构
3. **常见做法**：大多数配置系统采用这种方式

## 📝 推荐的部署步骤

### 步骤 1：确保目录存在

```cmd
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"
```

### 步骤 2：复制 skill 文件

```cmd
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

### 步骤 3：验证文件

```cmd
dir %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

应该看到：
```
2026/02/26  ...  playwright-browser.md
```

### 步骤 4：重启 OpenClaw

关闭并重新启动 OpenClaw。

### 步骤 5：验证 skill 是否被识别

在 OpenClaw 中检查是否能看到 `playwright-browser` skill。

## 🔄 如果方式 1 不工作

如果 OpenClaw 没有识别到 skill，尝试方式 2：

```cmd
REM 删除直接放置的文件
del %USERPROFILE%\.openclaw\skills\playwright-browser.md

REM 创建 skill 文件夹
mkdir %USERPROFILE%\.openclaw\skills\playwright-browser

REM 复制到文件夹中
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\skill.md
```

然后重启 OpenClaw 再次验证。

## 📊 目录结构对比

| 特性 | 方式 1（直接放置） | 方式 2（文件夹） |
|------|------------------|----------------|
| 简单性 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| 组织性 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 扩展性 | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 常见度 | ⭐⭐⭐⭐ | ⭐⭐⭐ |

## ✅ 验证清单

部署后检查：

- [ ] 文件已复制到正确位置
- [ ] 文件名正确（`playwright-browser.md`）
- [ ] 文件内容完整（包含 frontmatter）
- [ ] OpenClaw 已重启
- [ ] OpenClaw 识别到 skill
- [ ] 可以在 OpenClaw 中使用 skill

## 🆘 故障排除

### 问题：OpenClaw 没有识别到 skill

**可能原因**：
1. 文件位置不正确
2. 文件名不正确
3. 文件格式有问题
4. OpenClaw 没有重启

**解决步骤**：

1. **检查文件位置**：
```cmd
dir %USERPROFILE%\.openclaw\skills\
```

2. **检查文件内容**：
```cmd
type %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

确保包含正确的 frontmatter。

3. **检查文件编码**：
确保文件是 UTF-8 编码。

4. **重启 OpenClaw**：
完全关闭并重新启动。

5. **查看 OpenClaw 日志**：
检查是否有错误信息。

### 问题：skill 文件找不到

**检查路径**：
```cmd
echo %USERPROFILE%\.openclaw\skills\
```

应该显示类似：
```
C:\Users\你的用户名\.openclaw\skills\
```

## 📞 需要帮助？

如果仍然不确定，可以：

1. 查看 OpenClaw 的官方文档
2. 检查 OpenClaw 的示例 skills
3. 在 OpenClaw 社区提问
4. 查看 OpenClaw 的日志文件

## 🎯 最终建议

**我强烈建议先尝试方式 1**（直接放在 skills 目录）：

```cmd
REM 一键部署命令
if not exist "%USERPROFILE%\.openclaw\skills" mkdir "%USERPROFILE%\.openclaw\skills"
copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser.md
dir %USERPROFILE%\.openclaw\skills\playwright-browser.md
```

如果这不工作，再尝试方式 2。

---

**更新**：请在实际部署后告诉我哪种方式有效，我会更新所有文档！
