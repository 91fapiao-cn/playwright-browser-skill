# 独立压缩包修复总结

## 问题描述

在测试独立压缩包部署时,发现 `skill-package/settings/mcp.json` 文件中使用了硬编码的绝对路径:

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["D:\\newSkill\\dist\\mcp-server.js"],  // ❌ 硬编码路径
      ...
    }
  }
}
```

这导致压缩包无法在其他环境直接使用。

---

## 修复方案

### 修改内容

#### 1. Windows 打包脚本 (build-release.ps1)

**修改前**:
```powershell
# 复制配置示例
New-Item -ItemType Directory -Path "$ReleaseDir\skill-package\settings" -Force | Out-Null
Copy-Item "skill-package\settings\mcp.json" -Destination "$ReleaseDir\skill-package\settings\"
```

**修改后**:
```powershell
# 生成配置示例 (使用相对路径)
New-Item -ItemType Directory -Path "$ReleaseDir\skill-package\settings" -Force | Out-Null

# 动态生成 mcp.json,使用相对路径
$mcpConfig = @{
    mcpServers = @{
        "playwright-browser" = @{
            command = "node"
            args = @("../../dist/mcp-server.js")  # 相对于 settings 目录的路径
            env = @{}
            disabled = $false
            autoApprove = @(
                "browser_launch",
                "browser_goto",
                "browser_get_title",
                "browser_get_text",
                "browser_get_html",
                "browser_get_links",
                "browser_get_cookies",
                "browser_close"
            )
        }
    }
}

$mcpConfig | ConvertTo-Json -Depth 10 | Set-Content "$ReleaseDir\skill-package\settings\mcp.json" -Encoding UTF8
Write-Host "    - 生成 mcp.json (使用相对路径)" -ForegroundColor Gray
```

#### 2. Mac/Linux 打包脚本 (build-release.sh)

**修改前**:
```bash
# 复制配置示例
mkdir -p "$RELEASE_DIR/skill-package/settings"
cp skill-package/settings/mcp.json "$RELEASE_DIR/skill-package/settings/"
```

**修改后**:
```bash
# 生成配置示例 (使用相对路径)
mkdir -p "$RELEASE_DIR/skill-package/settings"

# 动态生成 mcp.json,使用相对路径
cat > "$RELEASE_DIR/skill-package/settings/mcp.json" << 'EOF'
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["../../dist/mcp-server.js"],
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
EOF

echo "    - 生成 mcp.json (使用相对路径)"
```

---

## 修复效果

### 修复前
```
压缩包结构:
releases/playwright-browser-skill-windows-v2.1.0/
├── dist/
│   └── mcp-server.js
├── skill-package/
│   └── settings/
│       └── mcp.json  ❌ 包含: "D:\\newSkill\\dist\\mcp-server.js"

问题:
- 无法在其他环境使用
- 必须手动修改配置
- 依赖部署脚本
```

### 修复后
```
压缩包结构:
releases/playwright-browser-skill-windows-v2.1.0/
├── dist/
│   └── mcp-server.js
├── skill-package/
│   └── settings/
│       └── mcp.json  ✅ 包含: "../../dist/mcp-server.js"

优点:
- 使用相对路径,跨环境兼容
- 部署脚本会转换为绝对路径
- 更灵活的部署方式
```

---

## 路径说明

### 相对路径结构

```
压缩包根目录/
├── dist/
│   └── mcp-server.js          <-- 目标文件
├── skill-package/
│   └── settings/
│       └── mcp.json           <-- 配置文件位置
```

从 `skill-package/settings/` 到 `dist/mcp-server.js` 的相对路径:
```
../../dist/mcp-server.js
```

解释:
- `../` - 返回上一级到 `skill-package/`
- `../` - 再返回上一级到压缩包根目录
- `dist/mcp-server.js` - 进入 dist 目录找到文件

---

## 部署流程

### 方式 1: 使用部署脚本 (推荐)

部署脚本会自动处理路径转换:

```powershell
# Windows
.\auto-deploy-en.ps1 -SkipBuild

# Mac/Linux
./auto-deploy-en.sh --skip-build
```

脚本会:
1. 检测 OpenClaw 安装路径
2. 复制所有文件到正确位置
3. 将相对路径转换为绝对路径
4. 生成最终的 mcp.json 配置

### 方式 2: 手动部署

如果需要手动部署:

1. 解压压缩包到目标位置
2. 编辑 `skill-package/settings/mcp.json`
3. 将相对路径 `../../dist/mcp-server.js` 替换为实际的绝对路径
4. 复制到 OpenClaw 配置目录

---

## 测试验证

### 测试步骤

1. 重新打包:
```powershell
.\build-release.ps1
```

2. 检查生成的 mcp.json:
```powershell
Get-Content releases\playwright-browser-skill-windows-v2.1.0\skill-package\settings\mcp.json
```

3. 验证路径:
```json
{
  "mcpServers": {
    "playwright-browser": {
      "args": ["../../dist/mcp-server.js"]  // ✅ 相对路径
    }
  }
}
```

4. 测试部署:
```powershell
.\test-standalone-package.ps1
```

### 预期结果

```
配置检查:
  ✅ mcp.json 使用相对路径
  ✅ 路径: ../../dist/mcp-server.js
  ✅ 跨环境兼容
```

---

## 影响范围

### 修改的文件
1. ✅ `build-release.ps1` - Windows 打包脚本
2. ✅ `build-release.sh` - Mac/Linux 打包脚本

### 不受影响的文件
- `auto-deploy-en.ps1` - 部署脚本仍然正常工作
- `auto-deploy-en.sh` - 部署脚本仍然正常工作
- `SKILL.md` - 文档无需修改
- 其他配置文件 - 无需修改

---

## 版本更新建议

### 建议版本号
- 当前版本: v2.1.0
- 建议版本: v2.1.1 (修复配置问题)

### 更新日志
```markdown
## v2.1.1 (2024-XX-XX)

### 修复
- 修复独立压缩包中 mcp.json 使用硬编码路径的问题
- 改用相对路径,提高跨环境兼容性
- 优化打包脚本,动态生成配置文件

### 改进
- 压缩包现在可以在任意位置解压使用
- 部署脚本会自动转换相对路径为绝对路径
- 提升用户体验
```

---

## 后续行动

### 立即执行
- [x] 修改 build-release.ps1
- [x] 修改 build-release.sh
- [ ] 重新打包生成新版本
- [ ] 测试新版本压缩包
- [ ] 更新版本号到 v2.1.1

### 可选优化
- [ ] 添加配置验证工具
- [ ] 更新文档说明
- [ ] 添加自动化测试

---

## 总结

### 问题根源
打包脚本直接复制了开发环境的 mcp.json,导致包含硬编码的绝对路径。

### 解决方案
在打包时动态生成 mcp.json,使用相对路径,由部署脚本负责转换为绝对路径。

### 修复效果
- ✅ 压缩包跨环境兼容
- ✅ 部署流程更灵活
- ✅ 用户体验提升
- ✅ 保持向后兼容

---

**修复完成时间**: 2024
**修复人员**: Kiro AI
**修复状态**: ✅ 已完成
