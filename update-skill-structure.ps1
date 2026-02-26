# 更新所有文档，使用正确的 skill 目录结构（每个 skill 一个文件夹）

Write-Host "开始更新 skill 目录结构..." -ForegroundColor Cyan

$files = @(
    "DEPLOYMENT_ARCHITECTURE.md",
    "FILE_LOCATIONS.md",
    "WINDOWS_GUIDE.md",
    "WINDOWS_SUMMARY.md",
    "WINDOWS_CHECKLIST.md",
    "QUICK_START_WINDOWS.md",
    "README.md",
    "CORRECT_PATHS.md",
    "test-windows.ps1",
    "test-windows.cmd"
)

# 定义替换规则
$replacements = @{
    # PowerShell 脚本中的路径
    'copy \.kiro\\skills\\playwright-browser\.md \$env:USERPROFILE\\\.openclaw\\skills\\' = 'if (-not (Test-Path "$env:USERPROFILE\.openclaw\skills\playwright-browser")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.openclaw\skills\playwright-browser" -Force | Out-Null }; Copy-Item .kiro\skills\playwright-browser.md "$env:USERPROFILE\.openclaw\skills\playwright-browser\playwright-browser.md"'
    
    # CMD 脚本中的路径
    'copy \.kiro\\skills\\playwright-browser\.md %USERPROFILE%\\\.openclaw\\skills\\' = 'if not exist "%USERPROFILE%\.openclaw\skills\playwright-browser" mkdir "%USERPROFILE%\.openclaw\skills\playwright-browser" & copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md'
    
    # Markdown 文档中的路径（单行）
    'copy \.kiro\\skills\\playwright-browser\.md %USERPROFILE%\\\.openclaw\\skills\\' = 'mkdir %USERPROFILE%\.openclaw\skills\playwright-browser & copy .kiro\skills\playwright-browser.md %USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md'
    
    # 目标路径描述
    '%USERPROFILE%\\\.openclaw\\skills\\playwright-browser\.md' = '%USERPROFILE%\.openclaw\skills\playwright-browser\playwright-browser.md'
    'C:\\Users\\你的用户名\\\.openclaw\\skills\\playwright-browser\.md' = 'C:\Users\你的用户名\.openclaw\skills\playwright-browser\playwright-browser.md'
    '\$env:USERPROFILE\\\.openclaw\\skills\\' = '$env:USERPROFILE\.openclaw\skills\playwright-browser\'
    
    # 目录结构描述
    '└── skills\\(\r?\n\s+)└── playwright-browser\.md' = '└── skills\$1    └── playwright-browser\$1        └── playwright-browser.md'
}

$count = 0

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "处理: $file" -ForegroundColor Yellow
        $content = Get-Content $file -Raw -Encoding UTF8
        
        $modified = $false
        foreach ($pattern in $replacements.Keys) {
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $replacements[$pattern]
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
    }
}

Write-Host "`n完成！共更新 $count 个文件" -ForegroundColor Green
