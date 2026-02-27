# 配置指南 / Configuration Guide

本文档详细说明 Playwright Browser Skill 的各种配置选项。

[English Version](#english-version) | 中文版本

---

## 中文版本

### 浏览器启动配置

#### 无头模式 (Headless Mode)

无头模式是浏览器自动化中最重要的配置选项之一。

**什么是无头模式？**

无头模式是指浏览器在后台运行，不显示图形界面窗口。这对于自动化任务和服务器环境特别有用。

**使用场景对比：**

| 场景 | 推荐模式 | 原因 |
|------|---------|------|
| 开发调试 | `headless: false` | 可以看到浏览器操作过程 |
| 自动化测试 | `headless: true` | 更快，资源占用少 |
| 数据抓取 | `headless: true` | 批量处理，无需界面 |
| 服务器部署 | `headless: true` | 服务器通常没有图形界面 |
| 学习演示 | `headless: false` | 便于观察和理解 |

**配置示例：**

```javascript
// 有界面模式 - 显示浏览器窗口
browser_launch({ 
  "headless": false 
})

// 无头模式 - 后台运行
browser_launch({ 
  "headless": true 
})

// 默认模式（省略参数时为无头模式）
browser_launch()
```

**性能对比：**

```
有界面模式：
- 启动时间：~2-3秒
- 内存占用：~200-300MB
- CPU占用：中等
- 适合：开发、调试、演示

无头模式：
- 启动时间：~1-2秒
- 内存占用：~100-150MB
- CPU占用：较低
- 适合：生产、自动化、批量任务
```

#### 浏览器类型选择

支持三种浏览器引擎：

```javascript
// Chromium（默认，推荐）
browser_launch({ 
  "browserType": "chromium",
  "headless": true 
})

// Firefox
browser_launch({ 
  "browserType": "firefox",
  "headless": true 
})

// WebKit（Safari 引擎）
browser_launch({ 
  "browserType": "webkit",
  "headless": true 
})
```

**浏览器选择建议：**

- **Chromium**：最稳定，兼容性最好，推荐用于生产环境
- **Firefox**：适合需要测试 Firefox 特定行为的场景
- **WebKit**：适合测试 Safari/iOS 兼容性

#### 设备模拟

模拟移动设备访问：

```javascript
// 模拟 iPhone 13
browser_launch({
  "headless": false,
  "device": "iPhone 13"
})

// 模拟 iPad Pro
browser_launch({
  "headless": false,
  "device": "iPad Pro"
})

// 自定义视口大小
browser_launch({
  "headless": false,
  "viewport": {
    "width": 1920,
    "height": 1080
  }
})
```

#### 其他启动选项

```javascript
browser_launch({
  "headless": true,           // 无头模式
  "slowMo": 100,              // 每个操作延迟100ms（调试用）
  "timeout": 30000,           // 超时时间30秒
  "args": [                   // 浏览器启动参数
    "--disable-gpu",
    "--no-sandbox"
  ]
})
```

### MCP 配置

#### 基础配置

在 `~/.openclaw/settings/mcp.json` 中配置：

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["<项目路径>/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_close"
      ]
    }
  }
}
```

#### 自动批准工具

`autoApprove` 列表中的工具将自动执行，无需用户确认：

**推荐的自动批准工具：**

```json
"autoApprove": [
  // 基础操作
  "browser_launch",
  "browser_close",
  "browser_goto",
  
  // 信息获取（安全）
  "browser_get_title",
  "browser_get_url",
  "browser_get_text",
  "browser_get_html",
  "browser_get_links",
  
  // 截图（安全）
  "browser_screenshot",
  
  // 等待操作（安全）
  "browser_wait_for_selector",
  "browser_wait_for_navigation"
]
```

**需要谨慎的工具（建议不自动批准）：**

```json
// 这些工具可能修改网页状态，建议手动确认
[
  "browser_click",
  "browser_fill",
  "browser_type",
  "browser_evaluate",
  "browser_set_cookie"
]
```

### 环境变量配置

可以通过环境变量配置默认行为：

```bash
# Windows (PowerShell)
$env:PLAYWRIGHT_HEADLESS = "true"
$env:PLAYWRIGHT_BROWSER = "chromium"
$env:PLAYWRIGHT_TIMEOUT = "30000"

# Mac/Linux
export PLAYWRIGHT_HEADLESS=true
export PLAYWRIGHT_BROWSER=chromium
export PLAYWRIGHT_TIMEOUT=30000
```

### 最佳实践

#### 1. 开发环境配置

```javascript
// 开发时使用有界面模式，便于调试
browser_launch({
  "headless": false,
  "slowMo": 50,  // 稍微减慢速度，便于观察
  "devtools": true  // 自动打开开发者工具
})
```

#### 2. 生产环境配置

```javascript
// 生产环境使用无头模式，提高性能
browser_launch({
  "headless": true,
  "timeout": 60000,  // 增加超时时间
  "args": [
    "--disable-dev-shm-usage",  // 避免共享内存问题
    "--no-sandbox"  // 服务器环境可能需要
  ]
})
```

#### 3. CI/CD 环境配置

```javascript
// CI/CD 环境推荐配置
browser_launch({
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--disable-setuid-sandbox",
    "--no-sandbox"
  ]
})
```

### 故障排查

#### 问题：无头模式下截图失败

**解决方案：**
```javascript
// 确保页面完全加载
browser_goto({ "url": "https://example.com" })
browser_wait_for_load_state({ "state": "networkidle" })
browser_screenshot({ "path": "screenshot.png" })
```

#### 问题：服务器环境无法启动浏览器

**解决方案：**
```javascript
// 添加必要的启动参数
browser_launch({
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage"
  ]
})
```

#### 问题：内存占用过高

**解决方案：**
```javascript
// 1. 使用无头模式
browser_launch({ "headless": true })

// 2. 及时关闭不用的页面
browser_close_page({ "pageId": "page-1" })

// 3. 完成任务后关闭浏览器
browser_close()
```

---

## English Version

### Browser Launch Configuration

#### Headless Mode

Headless mode is one of the most important configuration options in browser automation.

**What is Headless Mode?**

Headless mode means the browser runs in the background without displaying a graphical interface window. This is particularly useful for automation tasks and server environments.

**Use Case Comparison:**

| Scenario | Recommended Mode | Reason |
|----------|-----------------|--------|
| Development/Debugging | `headless: false` | Can see browser operations |
| Automated Testing | `headless: true` | Faster, less resource usage |
| Data Scraping | `headless: true` | Batch processing, no UI needed |
| Server Deployment | `headless: true` | Servers usually lack GUI |
| Learning/Demo | `headless: false` | Easy to observe and understand |

**Configuration Examples:**

```javascript
// Headed mode - Show browser window
browser_launch({ 
  "headless": false 
})

// Headless mode - Run in background
browser_launch({ 
  "headless": true 
})

// Default mode (headless when parameter omitted)
browser_launch()
```

**Performance Comparison:**

```
Headed Mode:
- Startup time: ~2-3 seconds
- Memory usage: ~200-300MB
- CPU usage: Medium
- Suitable for: Development, debugging, demos

Headless Mode:
- Startup time: ~1-2 seconds
- Memory usage: ~100-150MB
- CPU usage: Lower
- Suitable for: Production, automation, batch tasks
```

#### Browser Type Selection

Three browser engines are supported:

```javascript
// Chromium (default, recommended)
browser_launch({ 
  "browserType": "chromium",
  "headless": true 
})

// Firefox
browser_launch({ 
  "browserType": "firefox",
  "headless": true 
})

// WebKit (Safari engine)
browser_launch({ 
  "browserType": "webkit",
  "headless": true 
})
```

**Browser Selection Guide:**

- **Chromium**: Most stable, best compatibility, recommended for production
- **Firefox**: Suitable for testing Firefox-specific behavior
- **WebKit**: Suitable for testing Safari/iOS compatibility

#### Device Emulation

Emulate mobile device access:

```javascript
// Emulate iPhone 13
browser_launch({
  "headless": false,
  "device": "iPhone 13"
})

// Emulate iPad Pro
browser_launch({
  "headless": false,
  "device": "iPad Pro"
})

// Custom viewport size
browser_launch({
  "headless": false,
  "viewport": {
    "width": 1920,
    "height": 1080
  }
})
```

#### Other Launch Options

```javascript
browser_launch({
  "headless": true,           // Headless mode
  "slowMo": 100,              // Delay 100ms per operation (for debugging)
  "timeout": 30000,           // 30 second timeout
  "args": [                   // Browser launch arguments
    "--disable-gpu",
    "--no-sandbox"
  ]
})
```

### MCP Configuration

#### Basic Configuration

Configure in `~/.openclaw/settings/mcp.json`:

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["<project-path>/dist/mcp-server.js"],
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_close"
      ]
    }
  }
}
```

#### Auto-Approve Tools

Tools in the `autoApprove` list will execute automatically without user confirmation:

**Recommended Auto-Approve Tools:**

```json
"autoApprove": [
  // Basic operations
  "browser_launch",
  "browser_close",
  "browser_goto",
  
  // Information retrieval (safe)
  "browser_get_title",
  "browser_get_url",
  "browser_get_text",
  "browser_get_html",
  "browser_get_links",
  
  // Screenshots (safe)
  "browser_screenshot",
  
  // Wait operations (safe)
  "browser_wait_for_selector",
  "browser_wait_for_navigation"
]
```

**Tools Requiring Caution (not recommended for auto-approve):**

```json
// These tools may modify page state, manual confirmation recommended
[
  "browser_click",
  "browser_fill",
  "browser_type",
  "browser_evaluate",
  "browser_set_cookie"
]
```

### Environment Variable Configuration

Configure default behavior via environment variables:

```bash
# Windows (PowerShell)
$env:PLAYWRIGHT_HEADLESS = "true"
$env:PLAYWRIGHT_BROWSER = "chromium"
$env:PLAYWRIGHT_TIMEOUT = "30000"

# Mac/Linux
export PLAYWRIGHT_HEADLESS=true
export PLAYWRIGHT_BROWSER=chromium
export PLAYWRIGHT_TIMEOUT=30000
```

### Best Practices

#### 1. Development Environment Configuration

```javascript
// Use headed mode during development for easier debugging
browser_launch({
  "headless": false,
  "slowMo": 50,  // Slow down slightly for observation
  "devtools": true  // Auto-open developer tools
})
```

#### 2. Production Environment Configuration

```javascript
// Use headless mode in production for better performance
browser_launch({
  "headless": true,
  "timeout": 60000,  // Increase timeout
  "args": [
    "--disable-dev-shm-usage",  // Avoid shared memory issues
    "--no-sandbox"  // May be needed in server environments
  ]
})
```

#### 3. CI/CD Environment Configuration

```javascript
// Recommended configuration for CI/CD environments
browser_launch({
  "headless": true,
  "args": [
    "--disable-gpu",
    "--disable-dev-shm-usage",
    "--disable-setuid-sandbox",
    "--no-sandbox"
  ]
})
```

### Troubleshooting

#### Issue: Screenshot fails in headless mode

**Solution:**
```javascript
// Ensure page is fully loaded
browser_goto({ "url": "https://example.com" })
browser_wait_for_load_state({ "state": "networkidle" })
browser_screenshot({ "path": "screenshot.png" })
```

#### Issue: Cannot launch browser in server environment

**Solution:**
```javascript
// Add necessary launch arguments
browser_launch({
  "headless": true,
  "args": [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage"
  ]
})
```

#### Issue: High memory usage

**Solution:**
```javascript
// 1. Use headless mode
browser_launch({ "headless": true })

// 2. Close unused pages promptly
browser_close_page({ "pageId": "page-1" })

// 3. Close browser after completing tasks
browser_close()
```
