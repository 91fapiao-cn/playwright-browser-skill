---
name: playwright-browser-skill
description: OpenClaw 技能，用于使用 Playwright 进行全面的浏览器自动化。支持启动/关闭浏览器、页面导航、元素交互、内容提取、高级选择器、等待操作、截图/PDF生成、JavaScript执行、Cookie/本地存储管理、网络请求拦截与模拟、文件上传/下载、Frame操作、视口/设备模拟、地理位置设置以及性能指标获取。
---

# Playwright 浏览器自动化技能

此技能提供了使用 Playwright 进行端到端浏览器自动化的强大功能。它封装了 Playwright 的核心 API，允许您以编程方式控制浏览器，执行各种任务，包括但不限于网页抓取、UI 自动化测试、数据输入和表单提交。

## 功能概览

-   **浏览器管理**: 启动、关闭浏览器，创建、切换和关闭多个页面。
-   **页面导航**: 访问 URL、前进、后退、刷新。
-   **元素交互**: 点击、双击、悬停、填写输入框、输入文本、按键、选择下拉菜单、勾选/取消勾选复选框、聚焦、拖拽。
-   **内容提取**: 获取元素文本、页面标题、HTML内容、链接、属性、输入值。
-   **等待操作**: 等待元素出现、等待指定时间、等待 URL 匹配、等待网络请求/响应。
-   **截图和PDF**: 截取页面或元素截图，生成页面PDF。
-   **JavaScript执行**: 在页面上下文中执行 JavaScript 代码。
-   **Cookie和存储**: 设置/获取/清除 Cookie 和本地存储。
-   **网络和请求控制**: 设置HTTP头、离线模式、请求拦截、响应模拟、日志记录。
-   **文件操作**: 上传文件、下载文件。
-   **Frame操作**: 切换到指定 Frame，获取 Frame 列表。
-   **视口和设备**: 设置视口大小，模拟媒体类型，设置地理位置。
-   **高级选择器**: 通过角色、文本、标签、占位符、测试ID、Alt文本、标题查找元素。
-   **高级事件监听**: 获取控制台日志、请求日志、响应日志，并支持清除。
-   **键盘和鼠标高级操作**: 按下/释放键盘键、插入文本、移动鼠标、鼠标点击、鼠标滚轮。

## 何时使用此技能

当您需要执行以下任何浏览器相关任务时，请使用此技能：

-   **网页数据抓取**: 从网站上提取结构化数据。
-   **Web UI 自动化测试**: 自动化用户界面测试流程。
-   **表单自动填写和提交**: 自动化重复性表单操作。
-   **模拟用户行为**: 模拟用户的点击、输入、滚动等交互行为。
-   **性能监控**: 获取页面加载和渲染的性能指标。
-   **网络请求分析和修改**: 拦截、修改或模拟网络请求和响应。
-   **调试和日志分析**: 捕获控制台输出、网络请求/响应日志。

## 示例用法 (伪代码)

```typescript
// 启动一个无头 Chromium 浏览器
await agent.call('playwright-browser-skill:launch', { browserType: 'chromium', headless: true });

// 导航到指定页面
await agent.call('playwright-browser-skill:goto', { url: 'https://www.google.com' });

// 搜索文本
await agent.call('playwright-browser-skill:fill', { selector: 'textarea[name="q"]', value: 'OpenClaw AI' });
await agent.call('playwright-browser-skill:press', { selector: 'textarea[name="q"]', key: 'Enter' });

// 等待搜索结果加载
await agent.call('playwright-browser-skill:waitForSelector', { selector: '#search' });

// 截取页面截图
await agent.call('playwright-browser-skill:screenshot', { path: './google-search.png', fullPage: true });

// 提取搜索结果标题
const titles = await agent.call('playwright-browser-skill:evaluate', {
  script: `Array.from(document.querySelectorAll('h3')).map(el => el.textContent)`
});

console.log('搜索结果标题:', titles);

// 关闭浏览器
await agent.call('playwright-browser-skill:close');
```

## 注意事项

-   在初次使用前，请确保已经通过 `npm run install-browsers` 安装了 Playwright 浏览器二进制文件。
-   所有操作都假定浏览器已通过 `launch` 方法启动，并且 `page` 对象已初始化。
-   错误处理机制已内置，当浏览器或页面未启动时会抛出错误。
-   对于复杂交互，建议使用高级选择器 (如 `getByRole`, `getByText`) 以提高代码的健壮性。
-   网络请求和响应日志可在 `getConsoleLogs`, `getRequestLogs`, `getResponseLogs` 中获取。

## 内部实现

此技能通过 `src/index.ts` 暴露了 `PlaywrightBrowserSkill` 类，该类包含了所有 Playwright 封装方法。`src/mcp-server.ts` 负责启动 MCP 服务器并注册所有工具定义（来自 `src/tools-registry.ts`），通过 `src/tool-handlers.ts` 将 MCP 请求映射到 `PlaywrightBrowserSkill` 的相应方法。
