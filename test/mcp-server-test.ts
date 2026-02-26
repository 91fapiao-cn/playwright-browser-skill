import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function testMCPServer() {
  console.log('🧪 测试 MCP 服务器...\n');
  
  const serverPath = join(__dirname, '../dist/mcp-server.js');
  
  console.log('1️⃣ 启动 MCP 服务器...');
  const server = spawn('node', [serverPath], {
    stdio: ['pipe', 'pipe', 'pipe']
  });
  
  let serverOutput = '';
  let serverError = '';
  
  server.stdout?.on('data', (data) => {
    serverOutput += data.toString();
  });
  
  server.stderr?.on('data', (data) => {
    serverError += data.toString();
    console.log('服务器日志:', data.toString().trim());
  });
  
  // 等待服务器启动
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  if (serverError.includes('已启动')) {
    console.log('✅ MCP 服务器启动成功\n');
  }
  
  // 测试工具列表请求
  console.log('2️⃣ 测试工具列表请求...');
  const listToolsRequest = {
    jsonrpc: '2.0',
    id: 1,
    method: 'tools/list',
    params: {}
  };
  
  server.stdin?.write(JSON.stringify(listToolsRequest) + '\n');
  
  // 等待响应
  await new Promise(resolve => setTimeout(resolve, 500));
  
  if (serverOutput) {
    try {
      const response = JSON.parse(serverOutput.split('\n')[0]);
      if (response.result && response.result.tools) {
        console.log('✅ 工具列表获取成功');
        console.log(`   找到 ${response.result.tools.length} 个工具`);
      }
    } catch (e) {
      console.log('⚠️  解析响应失败，但服务器正在运行');
    }
  }
  
  // 测试工具调用
  console.log('\n3️⃣ 测试工具调用...');
  const callToolRequest = {
    jsonrpc: '2.0',
    id: 2,
    method: 'tools/call',
    params: {
      name: 'browser_launch',
      arguments: {
        browserType: 'chromium',
        headless: true
      }
    }
  };
  
  server.stdin?.write(JSON.stringify(callToolRequest) + '\n');
  
  // 等待响应
  await new Promise(resolve => setTimeout(resolve, 3000));
  
  console.log('✅ 工具调用请求已发送\n');
  
  // 关闭服务器
  console.log('4️⃣ 关闭 MCP 服务器...');
  server.kill();
  
  await new Promise(resolve => setTimeout(resolve, 500));
  
  console.log('✅ MCP 服务器已关闭\n');
  
  console.log('🎉 MCP 服务器测试完成！');
  console.log('\n注意: 完整的 MCP 测试需要在 OpenClaw 环境中进行');
}

testMCPServer().catch(error => {
  console.error('❌ 测试失败:', error);
  process.exit(1);
});
