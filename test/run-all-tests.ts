import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

interface TestResult {
  name: string;
  passed: boolean;
  duration: number;
  error?: string;
}

async function runTest(testFile: string): Promise<TestResult> {
  const startTime = Date.now();
  const testPath = join(__dirname, testFile);
  
  return new Promise((resolve) => {
    console.log(`\n${'='.repeat(60)}`);
    console.log(`🧪 运行测试: ${testFile}`);
    console.log('='.repeat(60));
    
    const child = spawn('node', [testPath], {
      stdio: 'inherit',
      shell: true
    });
    
    child.on('close', (code) => {
      const duration = Date.now() - startTime;
      resolve({
        name: testFile,
        passed: code === 0,
        duration,
        error: code !== 0 ? `退出码: ${code}` : undefined
      });
    });
    
    child.on('error', (error) => {
      const duration = Date.now() - startTime;
      resolve({
        name: testFile,
        passed: false,
        duration,
        error: error.message
      });
    });
  });
}

async function runAllTests() {
  console.log('🚀 开始运行所有测试...\n');
  
  const tests = [
    'basic-test.js',
    'advanced-test.js',
    'interaction-test.js'
  ];
  
  const results: TestResult[] = [];
  
  for (const test of tests) {
    const result = await runTest(test);
    results.push(result);
  }
  
  // 打印总结
  console.log('\n' + '='.repeat(60));
  console.log('📊 测试总结');
  console.log('='.repeat(60));
  
  let totalPassed = 0;
  let totalFailed = 0;
  let totalDuration = 0;
  
  results.forEach(result => {
    const status = result.passed ? '✅ 通过' : '❌ 失败';
    const duration = (result.duration / 1000).toFixed(2);
    
    console.log(`\n${status} ${result.name} (${duration}s)`);
    if (result.error) {
      console.log(`   错误: ${result.error}`);
    }
    
    if (result.passed) {
      totalPassed++;
    } else {
      totalFailed++;
    }
    totalDuration += result.duration;
  });
  
  console.log('\n' + '='.repeat(60));
  console.log(`总计: ${results.length} 个测试`);
  console.log(`✅ 通过: ${totalPassed}`);
  console.log(`❌ 失败: ${totalFailed}`);
  console.log(`⏱️  总耗时: ${(totalDuration / 1000).toFixed(2)}s`);
  console.log('='.repeat(60));
  
  if (totalFailed === 0) {
    console.log('\n🎉 所有测试通过！');
    process.exit(0);
  } else {
    console.log('\n💔 部分测试失败');
    process.exit(1);
  }
}

runAllTests().catch(error => {
  console.error('❌ 测试运行器错误:', error);
  process.exit(1);
});
