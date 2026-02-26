import { PlaywrightBrowserSkill } from '../src/index.js';

async function testAdvancedFunctionality() {
  console.log('🧪 开始高级功能测试...\n');
  
  const browser = new PlaywrightBrowserSkill();
  
  try {
    // 1. 测试设备模拟
    console.log('1️⃣ 测试移动设备模拟...');
    await browser.launch({ 
      browserType: 'chromium',
      headless: true,
      deviceName: 'iPhone 13',
      viewport: { width: 390, height: 844 }
    });
    console.log('✅ 移动设备模拟成功');
    
    // 2. 测试多页面管理
    console.log('\n2️⃣ 测试多页面管理...');
    await browser.goto('https://example.com');
    const newPageResult = await browser.newPage();
    console.log('✅ 创建新页面:', newPageResult.message);
    
    const pagesResult = await browser.getAllPages();
    console.log('✅ 当前页面数:', pagesResult.pages.length);
    
    // 3. 测试页面切换
    console.log('\n3️⃣ 测试页面切换...');
    await browser.switchPage(0);
    console.log('✅ 切换到页面 0');
    
    // 4. 测试等待操作
    console.log('\n4️⃣ 测试等待操作...');
    await browser.waitForSelector('h1', { timeout: 5000 });
    console.log('✅ 元素等待成功');
    
    // 5. 测试视口设置
    console.log('\n5️⃣ 测试视口设置...');
    await browser.setViewportSize(1920, 1080);
    const viewportResult = await browser.getViewportSize();
    console.log('✅ 视口大小:', viewportResult.viewport);
    
    // 6. 测试滚动操作
    console.log('\n6️⃣ 测试滚动操作...');
    await browser.scrollTo(0, 500);
    console.log('✅ 滚动成功');
    
    // 7. 测试元素状态检查
    console.log('\n7️⃣ 测试元素状态检查...');
    const visibleResult = await browser.isVisible('h1');
    console.log('✅ H1可见性:', visibleResult.visible);
    
    const countResult = await browser.count('a');
    console.log('✅ 链接数量:', countResult.count);
    
    // 8. 测试LocalStorage
    console.log('\n8️⃣ 测试LocalStorage...');
    await browser.setLocalStorage('test_key', 'test_value');
    const storageResult = await browser.getLocalStorage('test_key');
    console.log('✅ LocalStorage值:', storageResult.result);
    
    // 9. 测试网络日志
    console.log('\n9️⃣ 测试网络日志...');
    await browser.goto('https://example.com');
    const requestLogs = await browser.getRequestLogs(5);
    console.log('✅ 请求日志数:', requestLogs.logs.length);
    
    const consoleLogs = await browser.getConsoleLogs(5);
    console.log('✅ 控制台日志数:', consoleLogs.logs.length);
    
    // 10. 测试性能指标
    console.log('\n🔟 测试性能指标...');
    const metricsResult = await browser.getMetrics();
    console.log('✅ 性能指标:', {
      domContentLoaded: metricsResult.metrics.domContentLoaded + 'ms',
      loadComplete: metricsResult.metrics.loadComplete + 'ms'
    });
    
    // 11. 测试高级选择器
    console.log('\n1️⃣1️⃣ 测试高级选择器...');
    const byTextResult = await browser.getByText('Example Domain');
    console.log('✅ 通过文本查找:', byTextResult.count, '个元素');
    
    // 12. 测试浏览器信息
    console.log('\n1️⃣2️⃣ 测试浏览器信息...');
    const versionResult = await browser.getBrowserVersion();
    console.log('✅ 浏览器版本:', versionResult.version);
    
    const connectedResult = await browser.isConnected();
    console.log('✅ 连接状态:', connectedResult.connected);
    
    // 清理
    console.log('\n🧹 清理测试环境...');
    await browser.close();
    console.log('✅ 清理完成');
    
    console.log('\n🎉 所有高级功能测试通过！');
    return true;
    
  } catch (error: any) {
    console.error('\n❌ 测试失败:', error.message);
    console.error(error.stack);
    
    try {
      await browser.close();
    } catch (e) {
      // 忽略清理错误
    }
    
    return false;
  }
}

// 运行测试
testAdvancedFunctionality().then(success => {
  process.exit(success ? 0 : 1);
});
