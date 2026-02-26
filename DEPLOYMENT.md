# 部署指南

## 架构概览

```
OpenClaw (AI) ←→ MCP Server ←→ Playwright Service ←→ Browser
```

## 快速开始

### 1. 安装依赖

```bash
npm install
npx playwright install
```

### 2. 构建项目

```bash
npm run build
```

### 3. 配置 OpenClaw

#### 方式A：工作区配置（推荐）

在你的项目根目录创建或编辑 `.kiro/settings/mcp.json`:

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "node",
      "args": ["/absolute/path/to/playwright-browser-skill/dist/mcp-server.js"],
      "env": {},
      "disabled": false,
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_close"
      ]
    }
  }
}
```

#### 方式B：用户级配置（全局）

编辑 `~/.openclaw/settings/mcp.json`，添加相同的配置。

### 4. 复制 Skill 定义

#### 工作区级别
```bash
mkdir -p .kiro/skills
cp .kiro/skills/playwright-browser.md .kiro/skills/
```

#### 用户级别（全局）
```bash
mkdir -p ~/.openclaw/skills
cp .kiro/skills/playwright-browser.md ~/.openclaw/skills/
```

### 5. 重启 OpenClaw

重启 OpenClaw 或重新加载 MCP 服务器配置。

### 6. 测试

在 OpenClaw 中输入：

```
启动浏览器，访问 example.com，获取页面标题
```

AI 应该会自动调用相应的工具完成任务。

## 详细配置说明

### MCP 配置参数

```json
{
  "mcpServers": {
    "playwright-browser": {
      // 启动命令（必需）
      "command": "node",
      
      // 命令参数（必需）
      "args": ["./dist/mcp-server.js"],
      
      // 环境变量（可选）
      "env": {
        "DEBUG": "playwright:*",
        "PLAYWRIGHT_BROWSERS_PATH": "/custom/path"
      },
      
      // 是否禁用（可选，默认false）
      "disabled": false,
      
      // 自动批准的工具列表（可选）
      // 列表中的工具不需要用户确认即可执行
      "autoApprove": [
        "browser_launch",
        "browser_goto",
        "browser_get_title",
        "browser_get_text",
        "browser_get_html",
        "browser_get_links",
        "browser_get_cookies",
        "browser_close"
      ]
    }
  }
}
```

### Skill 定义位置

Skill 定义文件可以放在以下位置：

1. **工作区级别**: `.kiro/skills/playwright-browser.md`
   - 仅在当前项目中可用
   - 适合项目特定的配置

2. **用户级别**: `~/.openclaw/skills/playwright-browser.md`
   - 在所有项目中可用
   - 适合通用工具

## 高级部署

### 作为 NPM 包安装

#### 1. 发布到 NPM

```bash
npm publish
```

#### 2. 全局安装

```bash
npm install -g playwright-browser-skill
```

#### 3. 配置使用全局命令

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "playwright-browser-mcp",
      "args": []
    }
  }
}
```

### 使用 npx（无需安装）

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "npx",
      "args": ["-y", "playwright-browser-skill"]
    }
  }
}
```

### Docker 部署

#### 1. 创建 Dockerfile

```dockerfile
FROM node:20-slim

# 安装 Playwright 依赖
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build
RUN npx playwright install

CMD ["node", "dist/mcp-server.js"]
```

#### 2. 构建镜像

```bash
docker build -t playwright-browser-skill .
```

#### 3. 运行容器

```bash
docker run -i playwright-browser-skill
```

#### 4. 配置 OpenClaw

```json
{
  "mcpServers": {
    "playwright-browser": {
      "command": "docker",
      "args": ["run", "-i", "playwright-browser-skill"]
    }
  }
}
```

## 故障排查

### 问题1：MCP 服务器无法启动

**症状**: OpenClaw 显示连接失败

**解决方案**:
1. 检查路径是否正确（使用绝对路径）
2. 确认已运行 `npm run build`
3. 检查 Node.js 版本（需要 v18+）
4. 查看 OpenClaw 日志获取详细错误

### 问题2：浏览器无法启动

**症状**: 调用 `browser_launch` 失败

**解决方案**:
1. 运行 `npx playwright install` 安装浏览器
2. 检查系统依赖（Linux 需要额外的库）
3. 尝试使用 headless 模式
4. 检查权限问题

### 问题3：工具未显示

**症状**: AI 无法识别浏览器工具

**解决方案**:
1. 确认 Skill 定义文件已复制到正确位置
2. 检查文件名是否正确
3. 重启 OpenClaw
4. 检查 MCP 服务器是否正常运行

### 问题4：权限被拒绝

**症状**: 某些工具调用需要用户确认

**解决方案**:
1. 将工具添加到 `autoApprove` 列表
2. 或在 OpenClaw 中手动批准

### 查看日志

#### MCP 服务器日志
```bash
# 启用调试模式
DEBUG=* node dist/mcp-server.js
```

#### Playwright 日志
```bash
# 在 env 中添加
"env": {
  "DEBUG": "playwright:*"
}
```

## 性能优化

### 1. 复用浏览器实例

不要频繁启动和关闭浏览器，尽量复用同一个实例。

### 2. 使用 headless 模式

生产环境使用无头模式可以提升性能：
```javascript
browser_launch({ headless: true })
```

### 3. 调整超时时间

根据网络情况调整超时：
```javascript
browser_goto({ url: "...", timeout: 30000 })
```

### 4. 限制并发

避免同时运行多个浏览器实例。

## 安全建议

1. **不要在 autoApprove 中添加危险操作**
   - `browser_evaluate` 可以执行任意 JavaScript
   - `browser_set_cookies` 可以修改认证信息

2. **使用环境变量存储敏感信息**
   ```json
   "env": {
     "API_KEY": "${API_KEY}"
   }
   ```

3. **限制访问的域名**
   - 在 Skill 定义中说明允许访问的域名
   - 在代码中添加域名白名单检查

4. **定期更新依赖**
   ```bash
   npm update
   npx playwright install
   ```

## 监控和维护

### 健康检查

创建一个简单的健康检查脚本：

```bash
#!/bin/bash
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | node dist/mcp-server.js
```

### 日志记录

在生产环境中启用日志：

```javascript
// 在 mcp-server.ts 中添加
import fs from 'fs';
const logStream = fs.createWriteStream('mcp-server.log', { flags: 'a' });
console.log = (...args) => logStream.write(args.join(' ') + '\n');
```

### 自动重启

使用 PM2 管理进程：

```bash
npm install -g pm2
pm2 start dist/mcp-server.js --name playwright-browser
pm2 save
pm2 startup
```

## 下一步

- 阅读 [API.md](./API.md) 了解所有可用方法
- 查看 [FEATURES.md](./FEATURES.md) 了解功能覆盖
- 参考 [ARCHITECTURE.md](./ARCHITECTURE.md) 理解架构设计
- 查看 [examples/](./examples/) 目录获取更多示例
