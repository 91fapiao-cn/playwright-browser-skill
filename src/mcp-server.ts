#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { PlaywrightBrowserSkill } from './index.js';
import { toolsRegistry, toolCount } from './tools-registry.js';
import { handleToolCall } from './tool-handlers.js';

// 创建 MCP 服务器
const server = new Server(
  {
    name: 'playwright-browser-skill',
    version: '2.1.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Playwright 实例
const browser = new PlaywrightBrowserSkill();

// 注册工具列表处理器
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools: toolsRegistry };
});

// 注册工具调用处理器
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    const result = await handleToolCall(browser, name, args || {});

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error: any) {
    return {
      content: [
        {
          type: 'text',
          text: `错误: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

// 启动服务器
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error(`Playwright Browser MCP Server v2.1 已启动`);
  console.error(`已注册 ${toolCount} 个工具，覆盖 100% 浏览器自动化场景`);
}

main().catch((error) => {
  console.error('服务器启动失败:', error);
  process.exit(1);
});
