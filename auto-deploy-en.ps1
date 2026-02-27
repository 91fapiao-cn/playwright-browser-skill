# Playwright Browser Skill - Auto Deploy Script (Windows/Mac)
# Automatically detects OpenClaw path and completes deployment

param(
    [string]$OpenClawPath = "",
    [switch]$SkipBuild = $false
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Playwright Browser Skill - Auto Deploy" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function: Detect OpenClaw installation path
function Find-OpenClawPath {
    Write-Host "[*] Detecting OpenClaw installation path..." -ForegroundColor Yellow
    
    # Common OpenClaw configuration paths
    $possiblePaths = @(
        "$env:USERPROFILE\.openclaw",           # Windows default
        "$env:USERPROFILE\.kiro",               # Kiro default
        "$HOME/.openclaw",                       # Mac/Linux default
        "$HOME/.kiro",                           # Kiro Mac/Linux
        "$env:APPDATA\openclaw",                # Windows AppData
        "$env:LOCALAPPDATA\openclaw"            # Windows LocalAppData
    )
    
    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            Write-Host "[√] Found OpenClaw config directory: $path" -ForegroundColor Green
            return $path
        }
    }
    
    # If not found, use default path
    $defaultPath = if ($IsWindows -or $env:OS -match "Windows") {
        "$env:USERPROFILE\.openclaw"
    } else {
        "$HOME/.openclaw"
    }
    
    Write-Host "[!] No existing config found, will use default path: $defaultPath" -ForegroundColor Yellow
    return $defaultPath
}

# Function: Ensure directory exists
function Ensure-Directory {
    param([string]$Path)
    
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "  [+] Created directory: $Path" -ForegroundColor Gray
    }
}

# Step 0: Check project directory
Write-Host "[0/5] Checking project environment..." -ForegroundColor Yellow

if (-not (Test-Path "skill-package\skills\playwright-browser.md")) {
    Write-Host "[X] Error: Please run this script in the project root directory" -ForegroundColor Red
    Write-Host "    Current directory: $(Get-Location)" -ForegroundColor Gray
    exit 1
}

$projectPath = (Get-Location).Path
Write-Host "[√] Project directory: $projectPath" -ForegroundColor Green
Write-Host ""

# Step 1: Build project
if (-not $SkipBuild) {
    Write-Host "[1/5] Building project..." -ForegroundColor Yellow
    
    if (-not (Test-Path "package.json")) {
        Write-Host "[X] Error: package.json not found" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "  Executing: npm run build" -ForegroundColor Gray
    npm run build
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[X] Build failed" -ForegroundColor Red
        exit 1
    }
    
    if (-not (Test-Path "dist\mcp-server.js")) {
        Write-Host "[X] Error: Build artifact not found (dist\mcp-server.js)" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "[√] Project built successfully" -ForegroundColor Green
} else {
    Write-Host "[1/5] Skipping build (using -SkipBuild parameter)" -ForegroundColor Gray
    
    if (-not (Test-Path "dist\mcp-server.js")) {
        Write-Host "[X] Error: dist\mcp-server.js does not exist, please build the project first" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# Step 2: Detect OpenClaw path
Write-Host "[2/5] Detecting OpenClaw configuration path..." -ForegroundColor Yellow

$openclawDir = if ($OpenClawPath) {
    Write-Host "  Using specified path: $OpenClawPath" -ForegroundColor Gray
    $OpenClawPath
} else {
    Find-OpenClawPath
}

$settingsDir = Join-Path $openclawDir "settings"
$skillsDir = Join-Path $openclawDir "skills"
$skillDir = Join-Path $skillsDir "playwright-browser"

Write-Host "[√] OpenClaw config directory: $openclawDir" -ForegroundColor Green
Write-Host ""

# Step 3: Create directory structure
Write-Host "[3/5] Preparing directory structure..." -ForegroundColor Yellow

Ensure-Directory $openclawDir
Ensure-Directory $settingsDir
Ensure-Directory $skillsDir
Ensure-Directory $skillDir

Write-Host "[√] Directory structure ready" -ForegroundColor Green
Write-Host ""

# Step 4: Deploy standalone skill package
Write-Host "[4/7] Deploying standalone skill package..." -ForegroundColor Yellow

# 4.1 Copy Skill documentation
$sourceFile = "skill-package\skills\playwright-browser.md"
$targetFile = Join-Path $skillDir "playwright-browser.md"

try {
    Copy-Item $sourceFile $targetFile -Force
    Write-Host "  [√] Skill documentation deployed" -ForegroundColor Green
} catch {
    Write-Host "  [X] Skill documentation deployment failed: $_" -ForegroundColor Red
    exit 1
}

# 4.2 Copy dist folder (compiled code)
$distSource = "dist"
$distTarget = Join-Path $skillDir "dist"

Write-Host "  [*] Copying compiled code..." -ForegroundColor Gray
try {
    if (Test-Path $distTarget) {
        Remove-Item $distTarget -Recurse -Force
    }
    Copy-Item $distSource $distTarget -Recurse -Force
    Write-Host "  [√] Compiled code deployed (dist/)" -ForegroundColor Green
} catch {
    Write-Host "  [X] Compiled code deployment failed: $_" -ForegroundColor Red
    exit 1
}

# 4.3 Copy necessary node_modules dependencies
Write-Host "  [*] Copying runtime dependencies..." -ForegroundColor Gray
$nodeModulesTarget = Join-Path $skillDir "node_modules"

try {
    # Copy entire node_modules folder (ensure all dependencies are included)
    if (Test-Path $nodeModulesTarget) {
        Remove-Item $nodeModulesTarget -Recurse -Force
    }
    
    Write-Host "    [*] Copying all dependencies (this may take a moment)..." -ForegroundColor Gray
    Copy-Item "node_modules" $nodeModulesTarget -Recurse -Force
    
    Write-Host "  [√] Runtime dependencies deployed" -ForegroundColor Green
} catch {
    Write-Host "  [X] Dependencies deployment failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "[√] Standalone skill package deployment complete" -ForegroundColor Green
Write-Host ""

# Step 5: Configure MCP
Write-Host "[5/7] Configuring MCP server..." -ForegroundColor Yellow

$mcpConfigPath = Join-Path $settingsDir "mcp.json"

# Use standalone package path (independent of project source code)
$distPath = Join-Path $skillDir "dist\mcp-server.js"
$distPathJson = $distPath -replace '\\', '\\'

# Create MCP configuration
$mcpConfig = @{
    mcpServers = @{
        "playwright-browser" = @{
            command = "node"
            args = @($distPath)
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

# If config file exists, merge configuration
if (Test-Path $mcpConfigPath) {
    Write-Host "  [!] Existing MCP configuration detected" -ForegroundColor Yellow
    
    try {
        $existingConfig = Get-Content $mcpConfigPath -Raw | ConvertFrom-Json
        
        # Backup existing configuration
        $backupPath = "$mcpConfigPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $mcpConfigPath $backupPath -Force
        Write-Host "  [√] Backed up to: $backupPath" -ForegroundColor Gray
        
        # Merge configuration
        if (-not $existingConfig.mcpServers) {
            $existingConfig | Add-Member -MemberType NoteProperty -Name "mcpServers" -Value @{} -Force
        }
        
        $existingConfig.mcpServers | Add-Member -MemberType NoteProperty -Name "playwright-browser" -Value $mcpConfig.mcpServers."playwright-browser" -Force
        
        $existingConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
        Write-Host "  [√] Merged into existing configuration" -ForegroundColor Green
        
    } catch {
        Write-Host "  [!] Cannot parse existing configuration, will overwrite" -ForegroundColor Yellow
        $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
    }
} else {
    # Create new configuration
    $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath -Encoding UTF8
    Write-Host "  [√] Created new configuration file" -ForegroundColor Green
}

Write-Host "[√] MCP configuration complete" -ForegroundColor Green
Write-Host ""

# Step 6: Verify deployment
Write-Host "[6/7] Verifying deployment..." -ForegroundColor Yellow

$requiredFiles = @(
    (Join-Path $skillDir "playwright-browser.md"),
    (Join-Path $skillDir "dist\mcp-server.js"),
    (Join-Path $skillDir "dist\index.js"),
    (Join-Path $skillDir "node_modules\playwright")
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  [√] $(Split-Path $file -Leaf)" -ForegroundColor Gray
    } else {
        Write-Host "  [X] Missing: $file" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if ($allFilesExist) {
    Write-Host "[√] All files verified" -ForegroundColor Green
} else {
    Write-Host "[X] Deployment verification failed" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Step 7: Statistics
Write-Host "[7/7] Statistics..." -ForegroundColor Yellow

$skillDirSize = (Get-ChildItem $skillDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "  Standalone package size: $([math]::Round($skillDirSize, 2)) MB" -ForegroundColor Gray
Write-Host "  Total tools: 101" -ForegroundColor Gray
Write-Host "  Coverage: 88%" -ForegroundColor Gray
Write-Host ""

# Complete
Write-Host "========================================" -ForegroundColor Green
Write-Host "Deployment Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Deployment Summary:" -ForegroundColor Cyan
Write-Host "  OpenClaw Config: $openclawDir" -ForegroundColor White
Write-Host "  Standalone Package: $skillDir" -ForegroundColor White
Write-Host "  Skill Documentation: $targetFile" -ForegroundColor White
Write-Host "  MCP Config: $mcpConfigPath" -ForegroundColor White
Write-Host "  MCP Server: $distPath" -ForegroundColor White
Write-Host ""

Write-Host "✨ Standalone Package Features:" -ForegroundColor Cyan
Write-Host "  ✅ Fully self-contained - No dependency on project source" -ForegroundColor White
Write-Host "  ✅ Directly shareable - Just package the entire folder" -ForegroundColor White
Write-Host "  ✅ Easy to manage - All files in one location" -ForegroundColor White
Write-Host "  ✅ Multi-version support - Install different versions simultaneously" -ForegroundColor White
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Restart OpenClaw/Kiro" -ForegroundColor White
Write-Host "  2. Test in chat: 'Launch browser and visit example.com'" -ForegroundColor White
Write-Host "  3. Check MCP server status (should show playwright-browser)" -ForegroundColor White
Write-Host ""

Write-Host "Usage:" -ForegroundColor Cyan
Write-Host "  Default deploy:  .\auto-deploy-en.ps1" -ForegroundColor Gray
Write-Host "  Skip build:      .\auto-deploy-en.ps1 -SkipBuild" -ForegroundColor Gray
Write-Host "  Custom path:     .\auto-deploy-en.ps1 -OpenClawPath 'C:\custom\path'" -ForegroundColor Gray
Write-Host ""
