# Playwright Browser Skill 一键部署脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Playwright Browser Skill - 部署脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在项目目录
if (-not (Test-Path ".kiro\skills\playwright-browser.md")) {
    Write-Host "[X] 错误：请在项目根目录运行此脚本" -ForegroundColor Red
    Write-Host "    当前目录：$(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/3] 检查 OpenClaw 配置目录..." -ForegroundColor Yellow

$openclawDir = "$env:USERPROFILE\.openclaw"
$settingsDir = "$openclawDir\settings"
$skillsDir = "$openclawDir\skills"
$skillDir = "$skillsDir\playwright-browser"

# 创建必要的目录
if (-not (Test-Path $openclawDir)) {
    Write-Host "  创建 .openclaw 目录..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $openclawDir -Force | Out-Null
}

if (-not (Test-Path $settingsDir)) {
    Write-Host "  创建 settings 目录..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}

if (-not (Test-Path $skillsDir)) {
    Write-Host "  创建 skills 目录..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
}

if (-not (Test-Path $skillDir)) {
    Write-Host "  创建 playwright-browser skill 目录..." -ForegroundColor Gray
    New-Item -ItemType Directory -Path $skillDir -Force | Out-Null
}

Write-Host "[√] 目录结构已准备就绪" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] 部署 Skill 文件..." -ForegroundColor Yellow

$sourceFile = ".kiro\skills\playwright-browser.md"
$targetFile = "$skillDir\playwright-browser.md"

try {
    Copy-Item $sourceFile $targetFile -Force
    Write-Host "[√] Skill 文件已复制" -ForegroundColor Green
    Write-Host "    目标位置：$targetFile" -ForegroundColor Gray
} catch {
    Write-Host "[X] Skill 文件复制失败：$_" -ForegroundColor Red
    exit 1
}

Write-Host ""

Write-Host "[3/3] 检查 MCP 配置..." -ForegroundColor Yellow

$mcpConfigFile = "$settingsDir\mcp.json"
$projectPath = (Get-Location).Path -replace '\\', '\\'

if (Test-Path $mcpConfigFile) {
    Write-Host "[!] MCP 配置文件已存在" -ForegroundColor Yellow
    Write-Host "    位置：$mcpConfigFile" -ForegroundColor Gray
    Write-Host ""
    Write-Host "请手动添加以下配置到 mcp.json：" -ForegroundColor Cyan
} else {
    Write-Host "[!] MCP 配置文件不存在，需要创建" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请创建文件：$mcpConfigFile" -ForegroundColor Cyan
    Write-Host "并添加以下内容：" -ForegroundColor Cyan
}

Write-Host ""
Write-Host @"
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["$projectPath\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
"@ -ForegroundColor White

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "[√] Skill 部署完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "1. 确保项目已构建（npm run build）" -ForegroundColor White
Write-Host "2. 配置 MCP（见上面的配置示例）" -ForegroundColor White
Write-Host "3. 重启 OpenClaw" -ForegroundColor White
Write-Host "4. 在 OpenClaw 中测试：启动浏览器，访问 example.com" -ForegroundColor White
Write-Host ""

Write-Host "Skill 文件位置：" -ForegroundColor Cyan
Write-Host "  $targetFile" -ForegroundColor White
Write-Host ""

Write-Host "MCP 配置位置：" -ForegroundColor Cyan
Write-Host "  $mcpConfigFile" -ForegroundColor White
Write-Host ""
