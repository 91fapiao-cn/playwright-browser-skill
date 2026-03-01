# 手动启动 MCP 服务器测试脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "MCP 服务器手动启动测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$mcpServerPath = "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill\dist\mcp-server.js"

# 检查文件是否存在
if (-not (Test-Path $mcpServerPath)) {
    Write-Host "[X] MCP 服务器文件不存在: $mcpServerPath" -ForegroundColor Red
    exit 1
}

Write-Host "[√] MCP 服务器文件存在" -ForegroundColor Green
Write-Host "    路径: $mcpServerPath" -ForegroundColor Gray
Write-Host ""

# 检查 Node.js
$nodeVersion = node --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "[√] Node.js 已安装: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "[X] Node.js 未安装或不在 PATH 中" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 启动 MCP 服务器
Write-Host "正在启动 MCP 服务器..." -ForegroundColor Yellow
Write-Host "按 Ctrl+C 停止服务器" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 切换到正确的目录并启动
Set-Location "C:\Users\Administrator\.openclaw\skills\playwright-browser-skill"
node dist\mcp-server.js
