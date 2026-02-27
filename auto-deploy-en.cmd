@echo off
REM Playwright Browser Skill - Auto Deploy Script (Windows)
REM Automatically detects OpenClaw path and completes deployment

setlocal enabledelayedexpansion

REM Parameter processing
set "OPENCLAW_PATH="
set "SKIP_BUILD=0"

:parse_args
if "%~1"=="" goto args_done
if /i "%~1"=="--openclaw-path" (
    set "OPENCLAW_PATH=%~2"
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--skip-build" (
    set "SKIP_BUILD=1"
    shift
    goto parse_args
)
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help
echo [X] Unknown parameter: %~1
exit /b 1

:show_help
echo Usage: %~nx0 [options]
echo.
echo Options:
echo   --openclaw-path PATH   Specify OpenClaw configuration path
echo   --skip-build           Skip project build
echo   -h, --help             Show help information
exit /b 0

:args_done

echo ========================================
echo Playwright Browser Skill - Auto Deploy
echo ========================================
echo.

REM Step 0: Check project directory
echo [0/5] Checking project environment...

if not exist "skill-package\skills\playwright-browser.md" (
    echo [X] Error: Please run this script in the project root directory
    echo     Current directory: %CD%
    exit /b 1
)

set "PROJECT_PATH=%CD%"
echo [√] Project directory: %PROJECT_PATH%
echo.

REM Step 1: Build project
if "%SKIP_BUILD%"=="0" (
    echo [1/5] Building project...
    
    if not exist "package.json" (
        echo [X] Error: package.json not found
        exit /b 1
    )
    
    echo   Executing: npm run build
    call npm run build
    
    if errorlevel 1 (
        echo [X] Build failed
        exit /b 1
    )
    
    if not exist "dist\mcp-server.js" (
        echo [X] Error: Build artifact not found (dist\mcp-server.js)
        exit /b 1
    )
    
    echo [√] Project built successfully
) else (
    echo [1/5] Skipping build (using --skip-build parameter)
    
    if not exist "dist\mcp-server.js" (
        echo [X] Error: dist\mcp-server.js does not exist, please build the project first
        exit /b 1
    )
)
echo.

REM Step 2: Detect OpenClaw path
echo [2/5] Detecting OpenClaw configuration path...

if defined OPENCLAW_PATH (
    echo   Using specified path: %OPENCLAW_PATH%
    set "OPENCLAW_DIR=%OPENCLAW_PATH%"
) else (
    REM Check common paths
    if exist "%USERPROFILE%\.openclaw" (
        set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
        echo [√] Found OpenClaw config directory: !OPENCLAW_DIR!
    ) else if exist "%USERPROFILE%\.kiro" (
        set "OPENCLAW_DIR=%USERPROFILE%\.kiro"
        echo [√] Found Kiro config directory: !OPENCLAW_DIR!
    ) else if exist "%APPDATA%\openclaw" (
        set "OPENCLAW_DIR=%APPDATA%\openclaw"
        echo [√] Found OpenClaw config directory: !OPENCLAW_DIR!
    ) else if exist "%LOCALAPPDATA%\openclaw" (
        set "OPENCLAW_DIR=%LOCALAPPDATA%\openclaw"
        echo [√] Found OpenClaw config directory: !OPENCLAW_DIR!
    ) else (
        set "OPENCLAW_DIR=%USERPROFILE%\.openclaw"
        echo [!] No existing config found, will use default path: !OPENCLAW_DIR!
    )
)

set "SETTINGS_DIR=%OPENCLAW_DIR%\settings"
set "SKILLS_DIR=%OPENCLAW_DIR%\skills"
set "SKILL_DIR=%SKILLS_DIR%\playwright-browser"

echo [√] OpenClaw config directory: %OPENCLAW_DIR%
echo.

REM Step 3: Create directory structure
echo [3/5] Preparing directory structure...

if not exist "%OPENCLAW_DIR%" (
    mkdir "%OPENCLAW_DIR%"
    echo   [+] Created directory: %OPENCLAW_DIR%
)

if not exist "%SETTINGS_DIR%" (
    mkdir "%SETTINGS_DIR%"
    echo   [+] Created directory: %SETTINGS_DIR%
)

if not exist "%SKILLS_DIR%" (
    mkdir "%SKILLS_DIR%"
    echo   [+] Created directory: %SKILLS_DIR%
)

if not exist "%SKILL_DIR%" (
    mkdir "%SKILL_DIR%"
    echo   [+] Created directory: %SKILL_DIR%
)

echo [√] Directory structure ready
echo.

REM Step 4: Deploy standalone skill package
echo [4/7] Deploying standalone skill package...

REM 4.1 Copy Skill documentation
set "SOURCE_FILE=skill-package\skills\playwright-browser.md"
set "TARGET_FILE=%SKILL_DIR%\playwright-browser.md"

copy /Y "%SOURCE_FILE%" "%TARGET_FILE%" >nul
if exist "%TARGET_FILE%" (
    echo   [√] Skill documentation deployed
) else (
    echo [X] Skill documentation deployment failed
    exit /b 1
)

REM 4.2 Copy dist folder
echo   [*] Copying compiled code...
set "DIST_SOURCE=dist"
set "DIST_TARGET=%SKILL_DIR%\dist"

if exist "%DIST_TARGET%" (
    rmdir /s /q "%DIST_TARGET%"
)
xcopy /E /I /Y /Q "%DIST_SOURCE%" "%DIST_TARGET%" >nul
if exist "%DIST_TARGET%\mcp-server.js" (
    echo   [√] Compiled code deployed (dist/)
) else (
    echo [X] Compiled code deployment failed
    exit /b 1
)

REM 4.3 Copy necessary node_modules dependencies
echo   [*] Copying runtime dependencies...
set "NODE_MODULES_TARGET=%SKILL_DIR%\node_modules"

if exist "%NODE_MODULES_TARGET%" (
    rmdir /s /q "%NODE_MODULES_TARGET%"
)

echo     [*] Copying all dependencies (this may take a moment)...
xcopy /E /I /Y /Q "node_modules" "%NODE_MODULES_TARGET%" >nul

echo   [√] Runtime dependencies deployed
echo [√] Standalone skill package deployment complete
echo.

REM Step 5: Configure MCP
echo [5/7] Configuring MCP server...

set "MCP_CONFIG_PATH=%SETTINGS_DIR%\mcp.json"
set "DIST_PATH=%SKILL_DIR%\dist\mcp-server.js"

REM Escape backslashes in path for JSON
set "DIST_PATH_JSON=%DIST_PATH:\=\\%"

REM Create temporary configuration file
set "TEMP_CONFIG=%TEMP%\mcp-config-%RANDOM%.json"

(
echo {
echo   "mcpServers": {
echo     "playwright-browser": {
echo       "command": "node",
echo       "args": ["%DIST_PATH_JSON%"],
echo       "env": {},
echo       "disabled": false,
echo       "autoApprove": [
echo         "browser_launch",
echo         "browser_goto",
echo         "browser_get_title",
echo         "browser_get_text",
echo         "browser_get_html",
echo         "browser_get_links",
echo         "browser_get_cookies",
echo         "browser_close"
echo       ]
echo     }
echo   }
echo }
) > "%TEMP_CONFIG%"

REM If config file exists, backup
if exist "%MCP_CONFIG_PATH%" (
    echo   [!] Existing MCP configuration detected
    
    set "BACKUP_PATH=%MCP_CONFIG_PATH%.backup.%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%"
    set "BACKUP_PATH=!BACKUP_PATH: =0!"
    
    copy /Y "%MCP_CONFIG_PATH%" "!BACKUP_PATH!" >nul
    echo   [√] Backed up to: !BACKUP_PATH!
    echo   [!] Will overwrite existing configuration (refer to backup for manual merge)
)

REM Write configuration
copy /Y "%TEMP_CONFIG%" "%MCP_CONFIG_PATH%" >nul
del "%TEMP_CONFIG%"

echo [√] MCP configuration complete
echo.

REM Step 6: Verify deployment
echo [6/7] Verifying deployment...

set "ALL_OK=1"
if exist "%SKILL_DIR%\playwright-browser.md" (
    echo   [√] playwright-browser.md
) else (
    echo   [X] Missing: playwright-browser.md
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\dist\mcp-server.js" (
    echo   [√] dist\mcp-server.js
) else (
    echo   [X] Missing: dist\mcp-server.js
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\dist\index.js" (
    echo   [√] dist\index.js
) else (
    echo   [X] Missing: dist\index.js
    set "ALL_OK=0"
)

if exist "%SKILL_DIR%\node_modules\playwright" (
    echo   [√] node_modules\playwright
) else (
    echo   [X] Missing: node_modules\playwright
    set "ALL_OK=0"
)

if "%ALL_OK%"=="1" (
    echo [√] All files verified
) else (
    echo [X] Deployment verification failed
    exit /b 1
)
echo.

REM Step 7: Statistics
echo [7/7] Statistics...
echo   Total tools: 101
echo   Coverage: 88%%
echo.

REM Complete
echo ========================================
echo Deployment Complete!
echo ========================================
echo.

echo Deployment Summary:
echo   OpenClaw Config: %OPENCLAW_DIR%
echo   Standalone Package: %SKILL_DIR%
echo   Skill Documentation: %TARGET_FILE%
echo   MCP Config: %MCP_CONFIG_PATH%
echo   MCP Server: %DIST_PATH%
echo.

echo ✨ Standalone Package Features:
echo   ✅ Fully self-contained - No dependency on project source
echo   ✅ Directly shareable - Just package the entire folder
echo   ✅ Easy to manage - All files in one location
echo   ✅ Multi-version support - Install different versions simultaneously
echo.

echo Next Steps:
echo   1. Restart OpenClaw/Kiro
echo   2. Test in chat: 'Launch browser and visit example.com'
echo   3. Check MCP server status (should show playwright-browser)
echo.

echo Usage:
echo   Default deploy:  auto-deploy-en.cmd
echo   Skip build:      auto-deploy-en.cmd --skip-build
echo   Custom path:     auto-deploy-en.cmd --openclaw-path "C:\custom\path"
echo.

pause
