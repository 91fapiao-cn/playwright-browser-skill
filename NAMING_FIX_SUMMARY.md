# 目录命名修复总结

## 问题
发行版包名使用 `playwright-browser-skill`，但部署脚本创建的目录名是 `playwright-browser`，导致路径不一致。

## 解决方案
统一使用 `playwright-browser-skill` 作为安装目录名。

## 已修复的文件
✅ `auto-deploy-en.cmd` - Windows 批处理脚本
✅ `auto-deploy-en.ps1` - PowerShell 脚本
✅ `auto-deploy-en.sh` - Mac/Linux Shell 脚本
✅ `auto-deploy.cmd` - 中文版 Windows 脚本
✅ `auto-deploy.ps1` - 中文版 PowerShell 脚本
✅ `auto-deploy.sh` - 中文版 Shell 脚本
✅ `mcp-config-fix.json` - 配置示例
✅ `MCP_CONFIG_FIX.md` - 修复文档

## 统一后的命名
- 发行版包名：`playwright-browser-skill-windows-v2.1.0.zip`
- 安装目录：`playwright-browser-skill`
- MCP 服务器名：`playwright-browser`（在 mcp.json 中）

## 正确的 mcp.json 配置
```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": [
        "C:/Users/Administrator/.openclaw/skills/playwright-browser-skill/dist/mcp-server.js"
      ],
      "disabled": false
    }
  }
}
```

## 下一步
1. 重新运行部署脚本（如果需要）
2. 验证 MCP 服务器能够正常启动
3. 重启 OpenClaw Gateway

详细说明请查看 `DIRECTORY_NAME_FIX.md`
