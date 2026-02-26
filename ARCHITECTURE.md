# Playwright Browser Skill 架构说明

## 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                         OpenClaw                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                    AI Agent                           │  │
│  │  - 理解用户意图                                        │  │
│  │  - 决策调用哪些工具                                    │  │
│  │  - 组合多个工具完成任务                                │  │
│  └───────────────────────────────────────────────────────┘  │
│                           ↓                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Skill Definition                         │  │
│  │  (.kiro/skills/playwright-browser.md)                 │  │
│  │  - 工具描述和使用说明                                  │  │
│  │  - 参数说明和示例                                      │  │
│  │  - 让AI理解如何使用浏览器工具                          │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓ MCP Protocol
┌─────────────────────────────────────────────────────────────┐
│                    MCP Server Layer                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              mcp-server.ts                            │  │
│  │  - 实现MCP协议                                         │  │
│  │  - 注册工具列表                                        │  │
│  │  - 处理工具调用请求                                    │  │
│  │  - 返回标准化响应                                      │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              Playwright Service Layer                       │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         PlaywrightBrowserSkill (index.ts)             │  │
│  │  - 封装Playwright API                                 │  │
│  │  - 管理浏览器实例                                      │  │
│  │  - 提供65+个浏览器操作方法                             │  │
│  │  - 统一错误处理                                        │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                    Playwright Core                          │
│  - Chromium/Firefox/WebKit 浏览器引擎                       │
│  - 实际执行浏览器操作                                        │
│  - 处理页面渲染、JavaScript执行等                            │
└─────────────────────────────────────────────────────────────┘
```

## 三层架构详解

### 1. Skill Definition Layer（OpenClaw侧）

**文件**: `.kiro/skills/playwright-browser.md`

**职责**:
- 📝 描述工具的功能和用途
- 📋 说明参数格式和要求
- 💡 提供使用示例和最佳实践
- 🎯 让AI理解何时、如何使用这些工具

**特点**:
- Markdown格式，易于阅读和维护
- 包含元数据（name, description, version）
- 面向AI的描述性文档
- 不包含实现细节

### 2. MCP Server Layer（协议层）

**文件**: `src/mcp-server.ts`

**职责**:
- 🔌 实现MCP（Model Context Protocol）协议
- 📡 通过stdio与OpenClaw通信
- 🛠️ 注册和暴露工具列表
- 🔄 处理工具调用请求并返回结果
- ⚠️ 统一错误处理和响应格式

**工作流程**:
```
1. OpenClaw发送工具调用请求 (JSON-RPC)
   ↓
2. MCP Server接收并解析请求
   ↓
3. 调用对应的Playwright方法
   ↓
4. 获取执行结果
   ↓
5. 格式化为MCP响应
   ↓
6. 返回给OpenClaw
```

**工具命名规范**:
- 所有工具以 `browser_` 前缀
- 使用下划线分隔单词
- 例如: `browser_launch`, `browser_goto`, `browser_click`

### 3. Playwright Service Layer（执行层）

**文件**: `src/index.ts`

**职责**:
- 🎭 封装Playwright原生API
- 🔧 管理浏览器、上下文、页面实例
- 📦 提供统一的方法接口
- ✅ 参数验证和错误处理
- 🔄 状态管理（浏览器是否启动等）

**核心类**: `PlaywrightBrowserSkill`
- 单例模式管理浏览器实例
- 65+个方法覆盖常用操作
- 统一的返回格式: `{ success, ...data }`

## 数据流示例

### 示例：访问网页并获取标题

```
用户输入: "访问 example.com 并获取页面标题"
                    ↓
┌─────────────────────────────────────────────────────────┐
│ OpenClaw AI Agent                                       │
│ 1. 理解意图：需要启动浏览器、访问网页、获取标题          │
│ 2. 查看 Skill Definition 了解可用工具                   │
│ 3. 决策：调用 browser_launch → browser_goto →          │
│           browser_get_title                             │
└─────────────────────────────────────────────────────────┘
                    ↓ MCP Request
┌─────────────────────────────────────────────────────────┐
│ MCP Server (mcp-server.ts)                             │
│ 接收: { method: "tools/call",                          │
│        params: { name: "browser_launch", args: {} }}   │
│ 调用: browser.launch()                                 │
└─────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────┐
│ Playwright Service (index.ts)                          │
│ PlaywrightBrowserSkill.launch()                        │
│ - 启动 Chromium 浏览器                                  │
│ - 创建浏览器上下文                                       │
│ - 创建新页面                                            │
│ 返回: { success: true, message: "浏览器已启动" }        │
└─────────────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────────────┐
│ Playwright Core                                         │
│ 实际启动 Chromium 进程                                   │
└─────────────────────────────────────────────────────────┘
                    ↓ 返回结果
                (重复上述流程执行 goto 和 get_title)
                    ↓
┌─────────────────────────────────────────────────────────┐
│ OpenClaw AI Agent                                       │
│ 收到结果: { success: true, title: "Example Domain" }   │
│ 生成回复: "页面标题是：Example Domain"                   │
└─────────────────────────────────────────────────────────┘
```

## 配置文件

### mcp-config.json

OpenClaw的MCP服务器配置文件，告诉OpenClaw如何启动和连接MCP服务器。

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",                    // 启动命令
      "args": ["./dist/mcp-server.js"],    // 服务器脚本
      "env": {},                            // 环境变量
      "disabled": false,                    // 是否禁用
      "autoApprove": [...]                  // 自动批准的工具
    }
  }
}
```

## 部署方式

### 方式1：本地开发模式

```bash
# 1. 构建项目
npm run build

# 2. 配置 OpenClaw
# 将 mcp-config.json 内容添加到 ~/.openclaw/settings/mcp.json

# 3. 复制 Skill 定义
cp .kiro/skills/playwright-browser.md ~/.openclaw/skills/

# 4. 重启 OpenClaw
```

### 方式2：NPM包模式

```bash
# 1. 发布到 NPM
npm publish

# 2. 全局安装
npm install -g playwright-browser-skill

# 3. 配置使用全局命令
{
  "command": "playwright-browser-mcp"
}
```

### 方式3：Docker容器模式

```dockerfile
FROM node:20
WORKDIR /app
COPY . .
RUN npm install && npm run build
CMD ["node", "dist/mcp-server.js"]
```

## 通信协议

### MCP协议特点

- 基于 JSON-RPC 2.0
- 使用 stdio 进行进程间通信
- 支持工具列表查询和工具调用
- 标准化的请求/响应格式

### 请求示例

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "browser_goto",
    "arguments": {
      "url": "https://example.com"
    }
  }
}
```

### 响应示例

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "{\"success\": true, \"url\": \"https://example.com\"}"
      }
    ]
  }
}
```

## 扩展性

### 添加新工具

1. 在 `index.ts` 中添加新方法
2. 在 `mcp-server.ts` 中注册工具定义
3. 在 `mcp-server.ts` 的 switch 中添加处理逻辑
4. 更新 `.kiro/skills/playwright-browser.md` 文档

### 添加新功能

- 可以直接扩展 `PlaywrightBrowserSkill` 类
- 保持统一的返回格式
- 添加适当的错误处理
- 更新相关文档

## 优势

1. **关注点分离**: AI理解、协议通信、实际执行各司其职
2. **易于维护**: 每层独立，修改不影响其他层
3. **可扩展**: 轻松添加新工具和功能
4. **标准化**: 使用MCP协议，兼容其他MCP客户端
5. **可测试**: 每层可独立测试
6. **可复用**: Playwright Service层可用于其他项目

## 总结

这个架构实现了：
- ✅ **AI侧**: Skill定义让AI理解工具用途
- ✅ **协议侧**: MCP Server处理通信和调用
- ✅ **执行侧**: Playwright Service执行实际操作

三层协同工作，提供完整的浏览器自动化能力。
