# Windows 兼容性测试脚本 (PowerShell)
# 用于验证 Playwright Browser Skill 在 Windows 上的安装和配置

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Playwright Browser Skill - Windows 测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsFailed = 0

# 测试函数
function Test-Command {
    param($CommandName)
    try {
        Get-Command $CommandName -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# 1. 检查 Node.js
Write-Host "[1/8] 检查 Node.js..." -ForegroundColor Yellow
if (Test-Command "node") {
    $nodeVersion = node --version
    Write-Host "[√] Node.js 已安装: $nodeVersion" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[X] Node.js 未安装" -ForegroundColor Red
    Write-Host "    请从 https://nodejs.org/ 下载并安装" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# 2. 检查 npm
Write-Host "[2/8] 检查 npm..." -ForegroundColor Yellow
if (Test-Command "npm") {
    $npmVersion = npm --version
    Write-Host "[√] npm 已安装: $npmVersion" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[X] npm 未安装" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# 3. 检查依赖
Write-Host "[3/8] 检查依赖..." -ForegroundColor Yellow
if (Test-Path "node_modules") {
    Write-Host "[√] 依赖已安装" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[!] 依赖未安装，正在安装..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[√] 依赖安装成功" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[X] 依赖安装失败" -ForegroundColor Red
        $testsFailed++
    }
}
Write-Host ""

# 4. 检查 Playwright 浏览器
Write-Host "[4/8] 检查 Playwright 浏览器..." -ForegroundColor Yellow
$playwrightPath = "$env:USERPROFILE\AppData\Local\ms-playwright"
if (Test-Path $playwrightPath) {
    Write-Host "[√] Playwright 浏览器已安装" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[!] Playwright 浏览器未安装，正在安装..." -ForegroundColor Yellow
    npx playwright install chromium
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[√] 浏览器安装成功" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[X] 浏览器安装失败" -ForegroundColor Red
        $testsFailed++
    }
}
Write-Host ""

# 5. 构建项目
Write-Host "[5/8] 构建项目..." -ForegroundColor Yellow
if (Test-Path "dist") {
    Write-Host "[√] 项目已构建" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "[!] 项目未构建，正在构建..." -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[√] 项目构建成功" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[X] 项目构建失败" -ForegroundColor Red
        $testsFailed++
    }
}
Write-Host ""

# 6. 检查关键文件
Write-Host "[6/8] 检查关键文件..." -ForegroundColor Yellow
$filesOk = $true

if (Test-Path "dist\mcp-server.js") {
    Write-Host "[√] MCP 服务器文件存在" -ForegroundColor Green
} else {
    Write-Host "[X] MCP 服务器文件不存在" -ForegroundColor Red
    $filesOk = $false
}

if (Test-Path "dist\index.js") {
    Write-Host "[√] 主文件存在" -ForegroundColor Green
} else {
    Write-Host "[X] 主文件不存在" -ForegroundColor Red
    $filesOk = $false
}

if ($filesOk) {
    $testsPassed++
} else {
    $testsFailed++
}
Write-Host ""

# 7. 运行基础测试
Write-Host "[7/8] 运行基础功能测试..." -ForegroundColor Yellow
if (Test-Path "dist\test\basic-test.js") {
    node dist\test\basic-test.js
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[√] 基础测试通过" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "[X] 基础测试失败" -ForegroundColor Red
        $testsFailed++
    }
} else {
    Write-Host "[X] 测试文件不存在" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# 8. 显示配置信息
Write-Host "[8/8] 显示配置信息..." -ForegroundColor Yellow
$currentPath = (Get-Location).Path -replace '\\', '\\'
Write-Host ""
Write-Host "MCP 配置示例（复制到 .openclaw\settings\mcp.json）：" -ForegroundColor Cyan
Write-Host @"
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["$currentPath\\dist\\mcp-server.js"],
      "disabled": false,
      "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
    }
  }
}
"@ -ForegroundColor White
Write-Host ""

# 显示结果
Write-Host "========================================" -ForegroundColor Cyan
if ($testsFailed -eq 0) {
    Write-Host "[√] 所有测试通过！($testsPassed/8)" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor Yellow
    Write-Host "1. 复制上面的 MCP 配置到 .openclaw\settings\mcp.json" -ForegroundColor White
    Write-Host "2. 创建 skill 文件夹并复制文件：" -ForegroundColor White
    Write-Host "   mkdir `$env:USERPROFILE\.openclaw\skills\playwright-browser" -ForegroundColor Gray
    Write-Host "   copy .kiro\skills\playwright-browser.md `$env:USERPROFILE\.openclaw\skills\playwright-browser\playwright-browser.md" -ForegroundColor Gray
    Write-Host "3. 重启 OpenClaw" -ForegroundColor White
    Write-Host "4. 在 OpenClaw 中测试：启动浏览器，访问 example.com" -ForegroundColor White
    Write-Host ""
    exit 0
} else {
    Write-Host "[X] 测试失败 ($testsFailed 个失败)" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "请查看上面的错误信息并修复问题" -ForegroundColor Red
    Write-Host "详细说明请参考 WINDOWS_GUIDE.md" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
