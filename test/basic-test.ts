import { PlaywrightBrowserSkill } from '../src/index.js';

async function testBasicFunctionality() {
  console.log('🧪 开始基础功能测试...\n');
  
  const browser = new PlaywrightBrowserSkill();
  
  try {
    // 1. 测试浏览器启动
    console.log('1️⃣ 测试浏览器启动...');
    const launchResult = await browser.launch({ 
      browserType: 'chromium', 
      headless: true 
    });
    console.log('✅ 浏览器启动成功:', launchResult.message);
    
    // 2. 测试页面导航
    console.log('\n2️⃣ 测试页面导航...');
    const gotoResult = await browser.goto('https://example.com');
    console.log('✅ 页面导航成功:', gotoResult.url);
    
    // 3. 测试获取标题
    console.log('\n3️⃣ 测试获取页面标题...');
    const titleResult = await browser.getTitle();
    console.log('✅ 页面标题:', titleResult.title);
    
    // 4. 测试获取HTML
    console.log('\n4️⃣ 测试获取HTML...');
    const htmlResult = await browser.getHTML();
    console.log('✅ HTML长度:', htmlResult.html.length, '字符');
    
    // 5. 测试获取链接
    console.log('\n5️⃣ 测试获取所有链接...');
    const linksResult = await browser.getLinks();
    console.log('✅ 找到链接数量:', linksResult.links.length);
    
    // 6. 测试截图
    console.log('\n6️⃣ 测试截图功能...');
    const screenshotResult = await browser.screenshot({ 
      path: './test-screenshot.png',
      fullPage: true 
    });
    console.log('✅ 截图成功');
    
    // 7. 测试JavaScript执行
    console.log('\n7️⃣ 测试JavaScript执行...');
    const evalResult = await browser.evaluate('document.body.innerText.length');
    console.log('✅ 页面文本长度:', evalResult.result);
    
    // 8. 测试元素查询
    console.log('\n8️⃣ 测试元素查询...');
    const textResult = await browser.getText('h1');
    console.log('✅ H1文本:', textResult.text);
    
    // 9. 测试Cookie操作
    console.log('\n9️⃣ 测试Cookie操作...');
    await browser.setCookies([
      { name: 'test_cookie', value: 'test_value', domain: 'example.com', path: '/' }
    ]);
    const cookiesResult = await browser.getCookies();
    console.log('✅ Cookie数量:', cookiesResult.cookies.length);
    
    // 10. 测试浏览器关闭
    console.log('\n🔟 测试浏览器关闭...');
    const closeResult = await browser.close();
    console.log('✅ 浏览器关闭成功:', closeResult.message);
    
    console.log('\n🎉 所有基础功能测试通过！');
    return true;
    
  } catch (error: any) {
    console.error('\n❌ 测试失败:', error.message);
    console.error(error.stack);
    
    // 确保清理
    try {
      await browser.close();
    } catch (e) {
      // 忽略清理错误
    }
    
    return false;
  }
}

// 运行测试
testBasicFunctionality().then(success => {
  process.exit(success ? 0 : 1);
});
