# 项目结构说明

## 目录结构

```
playwright-browser-skill/
├── src/                          # 源代码目录
│   ├── index.ts                  # Playwright Service Layer（核心实现）
│   ├── mcp-server.ts            # MCP Server Layer（协议层）
│   └── server.ts                # 旧版服务器（已废弃）
│
├── dist/                         # 编译输出目录（npm run build 生成）
│   ├── index.js
│   ├── mcp-server.js
│   └── *.d.ts
│
├── .kiro/                        # OpenClaw 配置目录
│   └── skills/
│       └── playwright-browser.md # Skill 定义文件（AI 理解层）
│
├── examples/                     # 使用示例
│   └── basic-usage.ts           # 基础使用示例
│
├── docs/                         # 文档目录
│   ├── API.md                   # 完整 API 文档
│   ├── FEATURES.md              # 功能列表
│   ├── COMPARISON.md            # 功能对照表
│   ├── ARCHITECTURE.md          # 架构说明
│   ├── DEPLOYMENT.md            # 部署指南
│   └── PROJECT_STRUCTURE.md     # 本文件
│
├── package.json                  # NPM 配置
├── tsconfig.json                # TypeScript 配置
├── mcp-config.json              # MCP 服务器配置示例
├── README.md                    # 项目说明
└── .gitignore                   # Git 忽略文件
```

## 核心文件说明

### src/index.ts
**Playwright Service Layer - 执行层**

- 封装 Playwright 原生 API
- 提供 65+ 个浏览器操作方法
- 管理浏览器、上下文、页面实例
- 统一的返回格式和错误处理

**主要类**:
```typescript
class PlaywrightBrowserSkill {
  private browser: Browser | null
  private context: BrowserContext | null
  private page: Page | null
  
  // 浏览器管理
  async launch(options)
  async close()
  
  // 页面导航
  async goto(url, options)
  async goBack()
  
  // 元素交互
  async click(selector, options)
  async fill(selector, value)
  
  // ... 60+ 其他方法
}
```

### src/mcp-server.ts
**MCP Server Layer - 协议层**

- 实现 MCP (Model Context Protocol) 协议
- 通过 stdio 与 OpenClaw 通信
- 注册和暴露工具列表
- 处理工具调用请求并返回结果

**主要功能**:
```typescript
// 1. 创建 MCP 服务器
const server = new Server({...})

// 2. 注册工具列表
server.setRequestHandler(ListToolsRequestSchema, ...)

// 3. 处理工具调用
server.setRequestHandler(CallToolRequestSchema, ...)

// 4. 启动服务器
await server.connect(transport)
```

**工具命名规范**:
- 所有工具以 `browser_` 前缀
- 使用下划线分隔单词
- 例如: `browser_launch`, `browser_goto`

### .kiro/skills/playwright-browser.md
**Skill Definition - AI 理解层**

- Markdown 格式的工具描述
- 让 AI 理解工具的用途和用法
- 包含参数说明和使用示例
- 不包含实现细节

**结构**:
```markdown
---
name: playwright-browser
description: 浏览器自动化技能
version: 1.0.0
---

# 工具说明

## browser_launch
启动浏览器
- 参数说明
- 使用示例

## browser_goto
...
```

### mcp-config.json
**MCP 服务器配置示例**

告诉 OpenClaw 如何启动和连接 MCP 服务器。

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",              // 启动命令
      "args": ["./dist/mcp-server.js"], // 服务器脚本
      "disabled": false,              // 是否禁用
      "autoApprove": [...]            // 自动批准的工具
    }
  }
}
```

**使用方式**:
1. 复制到 `.kiro/settings/mcp.json` (工作区级别)
2. 或复制到 `~/.openclaw/settings/mcp.json` (用户级别)

### package.json
**NPM 配置文件**

```json
{
  "name": "playwright-browser-skill",
  "type": "module",                    // ES Module
  "main": "dist/index.js",            // 主入口
  "bin": {
    "playwright-browser-mcp": "./dist/mcp-server.js"  // CLI 命令
  },
  "scripts": {
    "build": "tsc",                   // 编译
    "start": "node dist/mcp-server.js" // 启动服务器
  },
  "dependencies": {
    "playwright": "^1.40.0",          // 浏览器自动化
    "@modelcontextprotocol/sdk": "^0.5.0"  // MCP 协议
  }
}
```

### tsconfig.json
**TypeScript 配置**

```json
{
  "compilerOptions": {
    "target": "ES2022",               // 目标 ES 版本
    "module": "ES2022",               // 模块系统
    "moduleResolution": "node",       // 模块解析
    "outDir": "./dist",               // 输出目录
    "rootDir": "./src",               // 源码目录
    "strict": true                    // 严格模式
  }
}
```

## 数据流

### 1. 启动流程

```
1. OpenClaw 读取 mcp-config.json
   ↓
2. 执行: node dist/mcp-server.js
   ↓
3. MCP Server 启动并监听 stdio
   ↓
4. OpenClaw 连接到 MCP Server
   ↓
5. 查询可用工具列表
   ↓
6. 加载 Skill 定义文件
   ↓
7. AI 可以开始调用工具
```

### 2. 工具调用流程

```
用户: "访问 example.com"
   ↓
AI 读取 Skill 定义，理解需要调用 browser_goto
   ↓
OpenClaw 发送 MCP 请求:
{
  "method": "tools/call",
  "params": {
    "name": "browser_goto",
    "arguments": { "url": "https://example.com" }
  }
}
   ↓
MCP Server 接收请求
   ↓
调用: browser.goto("https://example.com")
   ↓
Playwright Service 执行操作
   ↓
返回结果: { success: true, url: "..." }
   ↓
MCP Server 格式化响应
   ↓
OpenClaw 接收响应
   ↓
AI 生成回复: "已访问 example.com"
```

## 部署位置

### 开发环境

```
项目目录/
├── playwright-browser-skill/    # 本项目
│   ├── src/
│   ├── dist/
│   └── ...
│
├── .kiro/
│   ├── settings/
│   │   └── mcp.json            # 指向本项目的 dist/mcp-server.js
│   └── skills/
│       └── playwright-browser.md
```

### 生产环境（全局安装）

```
# NPM 全局包
/usr/local/lib/node_modules/playwright-browser-skill/

# 用户配置
~/.openclaw/
├── settings/
│   └── mcp.json                # 使用全局命令
└── skills/
    └── playwright-browser.md
```

## 构建产物

运行 `npm run build` 后生成：

```
dist/
├── index.js                    # PlaywrightBrowserSkill 类
├── index.d.ts                  # TypeScript 类型定义
├── mcp-server.js              # MCP 服务器入口
├── mcp-server.d.ts
└── server.js                   # 旧版（已废弃）
```

## 依赖关系

```
mcp-server.ts
    ↓ import
index.ts (PlaywrightBrowserSkill)
    ↓ import
playwright (chromium, firefox, webkit)
    ↓
浏览器引擎
```

## 配置文件优先级

### MCP 配置
1. 工作区: `.kiro/settings/mcp.json`
2. 用户级: `~/.openclaw/settings/mcp.json`

工作区配置会覆盖用户级配置。

### Skill 定义
1. 工作区: `.kiro/skills/playwright-browser.md`
2. 用户级: `~/.openclaw/skills/playwright-browser.md`

两者可以共存，OpenClaw 会加载所有找到的 Skill。

## 扩展点

### 添加新工具

1. **在 index.ts 中添加方法**
   ```typescript
   async newMethod(param: string) {
     // 实现
     return { success: true, result: ... }
   }
   ```

2. **在 mcp-server.ts 中注册工具**
   ```typescript
   {
     name: 'browser_new_method',
     description: '...',
     inputSchema: { ... }
   }
   ```

3. **在 mcp-server.ts 中添加处理**
   ```typescript
   case 'browser_new_method':
     result = await browser.newMethod(args.param);
     break;
   ```

4. **更新 Skill 定义**
   ```markdown
   ## browser_new_method
   新方法说明
   ```

### 自定义配置

可以通过环境变量传递配置：

```json
{
  "env": {
    "BROWSER_TYPE": "firefox",
    "HEADLESS": "true",
    "TIMEOUT": "30000"
  }
}
```

在代码中读取：
```typescript
const browserType = process.env.BROWSER_TYPE || 'chromium';
```

## 最佳实践

1. **保持三层分离**
   - Skill 定义：面向 AI 的描述
   - MCP Server：协议和通信
   - Playwright Service：实际实现

2. **统一返回格式**
   ```typescript
   { success: boolean, ...data }
   ```

3. **完善错误处理**
   ```typescript
   try {
     // 操作
   } catch (error) {
     return { success: false, error: error.message }
   }
   ```

4. **文档同步更新**
   - 添加功能时同步更新所有文档
   - 保持示例代码可运行

5. **版本管理**
   - 遵循语义化版本
   - 重大变更更新主版本号
