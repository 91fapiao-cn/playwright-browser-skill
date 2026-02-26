# 批量替换 .kiro 为 .openclaw 的脚本

Write-Host "开始替换 .kiro 为 .openclaw..." -ForegroundColor Cyan

$files = @(
    "DEPLOYMENT_ARCHITECTURE.md",
    "FILE_LOCATIONS.md",
    "WINDOWS_GUIDE.md",
    "WINDOWS_SUMMARY.md",
    "WINDOWS_CHECKLIST.md",
    "QUICK_START_WINDOWS.md",
    "README.md",
    "README_WINDOWS.md",
    "PROJECT_STRUCTURE.md",
    "TEST_REPORT.md",
    "SUMMARY.md",
    "DEPLOYMENT.md",
    "ARCHITECTURE.md",
    "DEMO.md",
    "FINAL_TEST_REPORT.md",
    "FIXES_SUMMARY.md"
)

$replacements = @{
    "\.kiro" = ".openclaw"
    "%USERPROFILE%\\\.kiro" = "%USERPROFILE%\.openclaw"
    "~/.kiro" = "~/.openclaw"
    "C:\\Users\\你的用户名\\\.kiro" = "C:\Users\你的用户名\.openclaw"
    "C:\\Users\\Administrator\\\.kiro" = "C:\Users\Administrator\.openclaw"
}

$count = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "处理: $file" -ForegroundColor Yellow
        $content = Get-Content $file -Raw -Encoding UTF8
        
        $modified = $false
        foreach ($key in $replacements.Keys) {
            if ($content -match [regex]::Escape($key)) {
                $content = $content -replace [regex]::Escape($key), $replacements[$key]
                $modified = $true
            }
        }
        
        if ($modified) {
            Set-Content $file -Value $content -Encoding UTF8 -NoNewline
            Write-Host "  ✓ 已更新" -ForegroundColor Green
            $count++
        } else {
            Write-Host "  - 无需更新" -ForegroundColor Gray
        }
    } else {
        Write-Host "  × 文件不存在" -ForegroundColor Red
    }
}

Write-Host "`n完成！共更新 $count 个文件" -ForegroundColor Green
