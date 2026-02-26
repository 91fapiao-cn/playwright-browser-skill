# 部署 MCP 配置到 OpenClaw

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "部署 MCP 配置到 OpenClaw" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$openclawSettings = "$env:USERPROFILE\.openclaw\settings"
$mcpConfigPath = "$openclawSettings\mcp.json"
$projectPath = $PSScriptRoot

Write-Host "[1/3] 检查 OpenClaw 配置目录..." -ForegroundColor Cyan

if (-not (Test-Path $openclawSettings)) {
    Write-Host "[!] OpenClaw 配置目录不存在，正在创建..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $openclawSettings -Force | Out-Null
    Write-Host "[√] 目录已创建: $openclawSettings" -ForegroundColor Green
} else {
    Write-Host "[√] 目录已存在: $openclawSettings" -ForegroundColor Green
}

Write-Host ""
Write-Host "[2/3] 准备 MCP 配置..." -ForegroundColor Cyan

# 创建配置内容
$mcpConfig = @{
    mcpServers = @{
        "playwright-browser" = @{
            command = "node"
            args = @("$projectPath\dist\mcp-server.js")
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

Write-Host "[√] 配置已准备" -ForegroundColor Green
Write-Host "    项目路径: $projectPath" -ForegroundColor Gray
Write-Host "    MCP 服务器: $projectPath\dist\mcp-server.js" -ForegroundColor Gray

Write-Host ""
Write-Host "[3/3] 写入配置文件..." -ForegroundColor Cyan

# 检查是否已存在配置
if (Test-Path $mcpConfigPath) {
    Write-Host "[!] 配置文件已存在" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "现有配置将被备份到: $mcpConfigPath.backup" -ForegroundColor Gray
    
    # 备份现有配置
    Copy-Item $mcpConfigPath "$mcpConfigPath.backup" -Force
    Write-Host "[√] 已备份现有配置" -ForegroundColor Green
}

# 写入新配置
$mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8

Write-Host "[√] 配置已写入: $mcpConfigPath" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "MCP 配置部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "配置内容：" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray
Get-Content $mcpConfigPath | Write-Host -ForegroundColor Gray
Write-Host "----------------------------------------" -ForegroundColor Gray
Write-Host ""

Write-Host "下一步：" -ForegroundColor Cyan
Write-Host "1. 确保项目已构建（npm run build）" -ForegroundColor Gray
Write-Host "2. 重启 OpenClaw" -ForegroundColor Gray
Write-Host "3. 在 OpenClaw 中测试 Playwright Browser Skill" -ForegroundColor Gray
Write-Host ""

Write-Host "测试命令示例：" -ForegroundColor Cyan
Write-Host "  browser_launch({ 'headless': false })" -ForegroundColor Gray
Write-Host "  browser_goto({ 'url': 'https://example.com' })" -ForegroundColor Gray
Write-Host "  browser_get_title()" -ForegroundColor Gray
Write-Host "  browser_close()" -ForegroundColor Gray
Write-Host ""
