# 文档路径批量更新说明

## 需要手动更新的历史文档

以下文档包含旧的路径引用，需要将 `playwright-browser` 改为 `playwright-browser-skill`：

### 1. MANUAL_DEPLOY_FIX.md
这是一个历史修复文档，记录了之前的手动部署问题。
- 所有 `~/.openclaw/skills/playwright-browser/` 改为 `~/.openclaw/skills/playwright-browser-skill/`

### 2. DEPLOYMENT_SUCCESS_REPORT.md
这是一个历史部署成功报告。
- 所有路径引用改为 `playwright-browser-skill`

### 3. DEPLOYMENT_SCRIPT_UPDATE_PLAN.md
这是一个历史更新计划文档。
- 路径引用改为 `playwright-browser-skill`

### 4. MAC_LINUX_GUIDE.md (剩余部分)
还有一处重复的命令需要更新：
```bash
mkdir -p ~/.openclaw/skills/playwright-browser
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser/
```
改为：
```bash
mkdir -p ~/.openclaw/skills/playwright-browser-skill
cp skill-package/skills/SKILL.md ~/.openclaw/skills/playwright-browser-skill/
```

## 已更新的文档

✅ README.md
✅ README_EN.md  
✅ DEPLOYMENT_VERIFICATION.md
✅ OPENCLAW_MCP_GUIDE.md
✅ RELEASE_PACKAGE_TEST_REPORT.md
✅ RELEASE_GUIDE.md
✅ AUTO_DEPLOY_README.md
✅ AUTO_DEPLOY_README_EN.md
✅ FINAL_UPDATE_SUMMARY.md
✅ FINAL_CHECKLIST.md
✅ ARCHITECTURE.md
✅ MAC_LINUX_GUIDE.md (部分)

## 建议

由于 MANUAL_DEPLOY_FIX.md, DEPLOYMENT_SUCCESS_REPORT.md, DEPLOYMENT_SCRIPT_UPDATE_PLAN.md 是历史文档，记录了之前的问题和修复过程，可以考虑：

1. **选项 A**：保持原样，作为历史记录
2. **选项 B**：添加注释说明这些是历史文档，路径已更新
3. **选项 C**：完全更新所有路径以保持一致性

推荐选项 C，以避免用户混淆。
