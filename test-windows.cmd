@echo off
REM Windows 兼容性测试脚本
REM 用于验证 Playwright Browser Skill 在 Windows 上的安装和配置

echo ========================================
echo Playwright Browser Skill - Windows 测试
echo ========================================
echo.

REM 检查 Node.js
echo [1/8] 检查 Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Node.js 未安装
    echo     请从 https://nodejs.org/ 下载并安装
    goto :error
) else (
    echo [√] Node.js 已安装
    node --version
)
echo.

REM 检查 npm
echo [2/8] 检查 npm...
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] npm 未安装
    goto :error
) else (
    echo [√] npm 已安装
    npm --version
)
echo.

REM 检查 node_modules
echo [3/8] 检查依赖...
if not exist "node_modules\" (
    echo [!] 依赖未安装，正在安装...
    call npm install
    if %errorlevel% neq 0 (
        echo [X] 依赖安装失败
        goto :error
    )
) else (
    echo [√] 依赖已安装
)
echo.

REM 检查 Playwright 浏览器
echo [4/8] 检查 Playwright 浏览器...
if not exist "%USERPROFILE%\AppData\Local\ms-playwright\" (
    echo [!] Playwright 浏览器未安装，正在安装...
    call npx playwright install chromium
    if %errorlevel% neq 0 (
        echo [X] 浏览器安装失败
        goto :error
    )
) else (
    echo [√] Playwright 浏览器已安装
)
echo.

REM 构建项目
echo [5/8] 构建项目...
if not exist "dist\" (
    echo [!] 项目未构建，正在构建...
    call npm run build
    if %errorlevel% neq 0 (
        echo [X] 项目构建失败
        goto :error
    )
) else (
    echo [√] 项目已构建
)
echo.

REM 检查关键文件
echo [6/8] 检查关键文件...
if not exist "dist\mcp-server.js" (
    echo [X] MCP 服务器文件不存在
    goto :error
) else (
    echo [√] MCP 服务器文件存在
)

if not exist "dist\index.js" (
    echo [X] 主文件不存在
    goto :error
) else (
    echo [√] 主文件存在
)
echo.

REM 运行基础测试
echo [7/8] 运行基础功能测试...
call node dist\test\basic-test.js
if %errorlevel% neq 0 (
    echo [X] 基础测试失败
    goto :error
)
echo.

REM 显示配置信息
echo [8/8] 显示配置信息...
echo.
echo MCP 配置示例（复制到 .openclaw\settings\mcp.json）：
echo {
echo   "mcpServers": {
echo     "playwright-browser": {
echo       "command": "node",
echo       "args": ["%CD%\\dist\\mcp-server.js"],
echo       "disabled": false,
echo       "autoApprove": ["browser_launch", "browser_goto", "browser_close"]
echo     }
echo   }
echo }
echo.

echo ========================================
echo [√] 所有测试通过！
echo ========================================
echo.
echo 下一步：
echo 1. 复制上面的 MCP 配置到 .openclaw\settings\mcp.json
echo 2. 创建 skill 文件夹并复制文件：
echo    mkdir %%USERPROFILE%%\.openclaw\skills\playwright-browser
echo    copy .kiro\skills\playwright-browser.md %%USERPROFILE%%\.openclaw\skills\playwright-browser\playwright-browser.md
echo 3. 重启 OpenClaw
echo 4. 在 OpenClaw 中测试：启动浏览器，访问 example.com
echo.
goto :end

:error
echo.
echo ========================================
echo [X] 测试失败
echo ========================================
echo.
echo 请查看上面的错误信息并修复问题
echo 详细说明请参考 WINDOWS_GUIDE.md
echo.
exit /b 1

:end
pause
