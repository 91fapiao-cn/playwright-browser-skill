# 手动部署命令修复说明

**修复时间：** 2026-02-28  
**修复原因：** 手动部署命令路径错误  
**状态：** ✅ 已完成

---

## 发现的问题

在检查手动部署说明时，发现以下文档中的路径不正确：

### 1. WINDOWS_GUIDE.md

**错误的命令：**
```cmd
copy .kiro\skills\SKILL.md %USERPROFILE%.openclaw\skills\
```

**问题：**
- ❌ 源路径错误：`.kiro\skills\` 应该是 `skill-package\skills\`
- ❌ 目标路径不完整：缺少 `playwright-browser` 子目录
- ❌ 环境变量格式错误：`%USERPROFILE%.openclaw` 应该是 `%USERPROFILE%\.openclaw`

### 2. QUICK_START_WINDOWS.md

**错误的命令：**
```cmd
copy .kiro\skills\SKILL.md %USERPROFILE%.openclaw\skills\
```

**问题：**
- ❌ 源路径错误：`.kiro\skills\` 应该是 `skill-package\skills\`
- ❌ 目标路径不完整：缺少 `playwright-browser` 子目录
- ❌ 环境变量格式错误：`%USERPROFILE%.openclaw` 应该是 `%USERPROFILE%\.openclaw`

### 3. ARCHITECTURE.md

**错误的命令：**
```bash
cp skill-package/skills/SKILL.md ~/.openclaw/skills/
```

**问题：**
- ❌ 目标路径不完整：缺少 `playwright-browser` 子目录

---

## 修复方案

### Windows 命令（正确）

```cmd
copy skill-package\skills\SKILL.md %USERPROFILE%\.openclaw\skills\playwright-browser\
```

**验证命令：**
```cmd
dir %USERPROFILE%\.openclaw\skills\playwright-browser\SKILL.md
```

### Mac/Linux 命令（正确）

```bash
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser/
```

**验证命令：**
```bash
ls -la ~/.openclaw/skills/playwright-browser/SKILL.md
```

---

## 修复的文件

### 1. WINDOWS_GUIDE.md ✅

**修复前：**
```cmd
copy .kiro\skills\SKILL.md %USERPROFILE%.openclaw\skills\
```

**修复后：**
```cmd
copy skill-package\skills\SKILL.md %USERPROFILE%\.openclaw\skills\playwright-browser\
```

### 2. QUICK_START_WINDOWS.md ✅

**修复前：**
```cmd
copy .kiro\skills\SKILL.md %USERPROFILE%.openclaw\skills\
```

**修复后：**
```cmd
copy skill-package\skills\SKILL.md %USERPROFILE%\.openclaw\skills\playwright-browser\
```

### 3. ARCHITECTURE.md ✅

**修复前：**
```bash
cp skill-package/skills/SKILL.md ~/.openclaw/skills/
```

**修复后：**
```bash
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser/
```

---

## 验证测试

### Windows 测试 ✅

```powershell
# 测试源文件存在
Test-Path "skill-package\skills\SKILL.md"
# 结果: True ✅

# 测试复制命令
copy skill-package\skills\SKILL.md $env:USERPROFILE\.openclaw\skills\playwright-browser\SKILL-test.md
# 结果: 成功 ✅

# 验证文件已复制
Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser\SKILL-test.md"
# 结果: True ✅
```

### Mac/Linux 测试 ⏳

```bash
# 测试源文件存在
test -f skill-package/skills/SKILL.md && echo "存在" || echo "不存在"

# 测试复制命令
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser/SKILL-test.md

# 验证文件已复制
ls -la ~/.openclaw/skills/playwright-browser/SKILL-test.md
```

---

## 正确的文件结构

### 项目源代码结构

```
项目根目录/
├── skill-package/
│   └── skills/
│       └── SKILL.md  ← 源文件
└── ...
```

### OpenClaw 技能目录结构

```
~/.openclaw/
└── skills/
    └── playwright-browser/  ← 技能文件夹
        ├── SKILL.md         ← 复制到这里
        ├── dist/
        ├── node_modules/
        └── package.json
```

---

## 完整的手动部署步骤

### Windows

**步骤 1：创建技能目录**
```cmd
mkdir %USERPROFILE%\.openclaw\skills\playwright-browser
```

**步骤 2：复制技能文档**
```cmd
copy skill-package\skills\SKILL.md %USERPROFILE%\.openclaw\skills\playwright-browser\
```

**步骤 3：复制 MCP 服务器代码**
```cmd
xcopy /E /I dist %USERPROFILE%\.openclaw\skills\playwright-browser\dist
```

**步骤 4：复制依赖**
```cmd
xcopy /E /I node_modules %USERPROFILE%\.openclaw\skills\playwright-browser\node_modules
```

**步骤 5：复制 package.json**
```cmd
copy package.json %USERPROFILE%\.openclaw\skills\playwright-browser\
```

**步骤 6：验证文件**
```cmd
dir %USERPROFILE%\.openclaw\skills\playwright-browser\
```

应该看到：
```
SKILL.md
package.json
dist\
node_modules\
```

### Mac/Linux

**步骤 1：创建技能目录**
```bash
mkdir -p ~/.openclaw/skills/playwright-browser
```

**步骤 2：复制技能文档**
```bash
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser/
```

**步骤 3：复制 MCP 服务器代码**
```bash
cp -r dist ~/.openclaw/skills/playwright-browser/
```

**步骤 4：复制依赖**
```bash
cp -r node_modules ~/.openclaw/skills/playwright-browser/
```

**步骤 5：复制 package.json**
```bash
cp package.json ~/.openclaw/skills/playwright-browser/
```

**步骤 6：验证文件**
```bash
ls -la ~/.openclaw/skills/playwright-browser/
```

应该看到：
```
SKILL.md
package.json
dist/
node_modules/
```

---

## 常见错误

### 错误 1：源文件不存在

**错误信息：**
```
The system cannot find the file specified.
```

**原因：**
- 不在项目根目录运行命令
- 源路径错误

**解决方案：**
```cmd
# 确认当前目录
cd

# 切换到项目根目录
cd D:\newSkill

# 验证源文件存在
dir skill-package\skills\SKILL.md
```

### 错误 2：目标目录不存在

**错误信息：**
```
The system cannot find the path specified.
```

**原因：**
- 目标目录不存在

**解决方案：**
```cmd
# 创建目标目录
mkdir %USERPROFILE%\.openclaw\skills\playwright-browser
```

### 错误 3：权限不足

**错误信息：**
```
Access is denied.
```

**原因：**
- 没有写入权限

**解决方案：**
- 以管理员身份运行命令提示符
- 或检查目录权限

---

## 自动部署 vs 手动部署

### 自动部署（推荐）✅

**优点：**
- ✅ 自动处理所有步骤
- ✅ 自动创建目录
- ✅ 自动验证文件
- ✅ 自动配置 MCP
- ✅ 提供详细的状态反馈

**使用方法：**
```cmd
# Windows
.\auto-deploy.cmd

# Mac/Linux
./auto-deploy.sh
```

### 手动部署

**优点：**
- ✅ 完全控制每个步骤
- ✅ 可以自定义路径
- ✅ 适合高级用户

**缺点：**
- ❌ 需要手动执行多个步骤
- ❌ 容易出错
- ❌ 需要手动验证

**适用场景：**
- 自定义安装路径
- 调试问题
- 学习部署过程

---

## 总结

✅ **所有手动部署命令已修复**

**修复的文件：**
1. ✅ WINDOWS_GUIDE.md
2. ✅ QUICK_START_WINDOWS.md
3. ✅ ARCHITECTURE.md

**修复的问题：**
1. ✅ 源路径错误（.kiro → skill-package）
2. ✅ 目标路径不完整（缺少 playwright-browser 子目录）
3. ✅ 环境变量格式错误（%USERPROFILE%.openclaw → %USERPROFILE%\.openclaw）

**验证结果：**
- ✅ Windows 命令测试通过
- ⏳ Mac/Linux 命令待实际环境测试

**建议：**
- 推荐使用自动部署脚本（auto-deploy.cmd / auto-deploy.sh）
- 手动部署仅适合高级用户或特殊场景

---

**修复完成时间：** 2026-02-28  
**状态：** ✅ 已完成
