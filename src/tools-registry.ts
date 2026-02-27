// MCP 工具注册表 - 完整的 100+ 工具定义

export const toolsRegistry = [
  // ==================== 浏览器管理 ====================
  {
    name: 'browser_launch',
    description: '启动浏览器（支持设备模拟、视频录制、追踪等）',
    inputSchema: {
      type: 'object',
      properties: {
        browserType: { type: 'string', enum: ['chromium', 'firefox', 'webkit'] },
        headless: { type: 'boolean' },
        viewport: { type: 'object', properties: { width: { type: 'number' }, height: { type: 'number' } } },
        deviceName: { type: 'string', description: '设备名称，如 iPhone 13, Pixel 5' },
        recordVideo: { type: 'boolean', description: '是否录制视频' },
        recordTrace: { type: 'boolean', description: '是否记录追踪' },
        slowMo: { type: 'number', description: '慢动作延迟（毫秒）' }
      }
    }
  },
  {
    name: 'browser_close',
    description: '关闭浏览器',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_new_page',
    description: '创建新页面',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_switch_page',
    description: '切换到指定页面',
    inputSchema: {
      type: 'object',
      properties: { index: { type: 'number' } },
      required: ['index']
    }
  },
  {
    name: 'browser_close_page',
    description: '关闭指定页面',
    inputSchema: {
      type: 'object',
      properties: { index: { type: 'number' } }
    }
  },
  {
    name: 'browser_get_all_pages',
    description: '获取所有页面列表',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_get_version',
    description: '获取浏览器版本',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_is_connected',
    description: '检查浏览器连接状态',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 页面导航 ====================
  {
    name: 'browser_goto',
    description: '导航到指定URL',
    inputSchema: {
      type: 'object',
      properties: {
        url: { type: 'string' },
        waitUntil: { type: 'string', enum: ['load', 'domcontentloaded', 'networkidle'] },
        timeout: { type: 'number' }
      },
      required: ['url']
    }
  },
  {
    name: 'browser_go_back',
    description: '返回上一页',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_go_forward',
    description: '前进到下一页',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_reload',
    description: '刷新页面',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 元素交互 ====================
  {
    name: 'browser_click',
    description: '点击元素',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        timeout: { type: 'number' },
        button: { type: 'string', enum: ['left', 'right', 'middle'] },
        clickCount: { type: 'number' }
      },
      required: ['selector']
    }
  },
  {
    name: 'browser_dblclick',
    description: '双击元素',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_hover',
    description: '鼠标悬停',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_fill',
    description: '填写表单',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        value: { type: 'string' }
      },
      required: ['selector', 'value']
    }
  },
  {
    name: 'browser_type',
    description: '逐字符输入',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        text: { type: 'string' },
        delay: { type: 'number' }
      },
      required: ['selector', 'text']
    }
  },
  {
    name: 'browser_press',
    description: '按键',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        key: { type: 'string' }
      },
      required: ['selector', 'key']
    }
  },
  {
    name: 'browser_select',
    description: '选择下拉框',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        value: { type: ['string', 'array'] }
      },
      required: ['selector', 'value']
    }
  },
  {
    name: 'browser_check',
    description: '勾选复选框',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_uncheck',
    description: '取消勾选',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_focus',
    description: '聚焦元素',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_drag',
    description: '拖拽元素',
    inputSchema: {
      type: 'object',
      properties: {
        sourceSelector: { type: 'string' },
        targetSelector: { type: 'string' }
      },
      required: ['sourceSelector', 'targetSelector']
    }
  },
  {
    name: 'browser_tap',
    description: '触摸点击（移动端）',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },

  // ==================== 键盘鼠标高级操作 ====================
  {
    name: 'browser_keyboard_down',
    description: '按下键盘按键',
    inputSchema: {
      type: 'object',
      properties: { key: { type: 'string' } },
      required: ['key']
    }
  },
  {
    name: 'browser_keyboard_up',
    description: '释放键盘按键',
    inputSchema: {
      type: 'object',
      properties: { key: { type: 'string' } },
      required: ['key']
    }
  },
  {
    name: 'browser_mouse_move',
    description: '移动鼠标',
    inputSchema: {
      type: 'object',
      properties: {
        x: { type: 'number' },
        y: { type: 'number' },
        steps: { type: 'number' }
      },
      required: ['x', 'y']
    }
  },
  {
    name: 'browser_mouse_click',
    description: '鼠标点击坐标',
    inputSchema: {
      type: 'object',
      properties: {
        x: { type: 'number' },
        y: { type: 'number' }
      },
      required: ['x', 'y']
    }
  },
  {
    name: 'browser_mouse_down',
    description: '按下鼠标按键',
    inputSchema: {
      type: 'object',
      properties: {
        button: { type: 'string', enum: ['left', 'right', 'middle'] },
        clickCount: { type: 'number' }
      }
    }
  },
  {
    name: 'browser_mouse_up',
    description: '释放鼠标按键',
    inputSchema: {
      type: 'object',
      properties: {
        button: { type: 'string', enum: ['left', 'right', 'middle'] },
        clickCount: { type: 'number' }
      }
    }
  },
  {
    name: 'browser_mouse_wheel',
    description: '鼠标滚轮',
    inputSchema: {
      type: 'object',
      properties: {
        deltaX: { type: 'number' },
        deltaY: { type: 'number' }
      },
      required: ['deltaX', 'deltaY']
    }
  },
  {
    name: 'browser_keyboard_insert_text',
    description: '插入文本（不触发键盘事件）',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' }
      },
      required: ['text']
    }
  },

  // ==================== 内容提取 ====================
  {
    name: 'browser_get_text',
    description: '获取元素文本',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_get_title',
    description: '获取页面标题',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_get_html',
    description: '获取页面HTML',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_get_links',
    description: '获取所有链接',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_get_attribute',
    description: '获取元素属性',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        attribute: { type: 'string' }
      },
      required: ['selector', 'attribute']
    }
  },
  {
    name: 'browser_get_input_value',
    description: '获取输入框值',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_is_visible',
    description: '检查元素可见性',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_is_enabled',
    description: '检查元素是否启用',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_is_checked',
    description: '检查复选框状态',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_count',
    description: '统计元素数量',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },
  {
    name: 'browser_get_current_url',
    description: '获取当前URL',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 高级选择器 ====================
  {
    name: 'browser_get_by_role',
    description: '通过角色查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        role: { type: 'string' },
        name: { type: 'string' }
      },
      required: ['role']
    }
  },
  {
    name: 'browser_get_by_text',
    description: '通过文本查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' },
        exact: { type: 'boolean' }
      },
      required: ['text']
    }
  },
  {
    name: 'browser_get_by_label',
    description: '通过标签查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' },
        exact: { type: 'boolean' }
      },
      required: ['text']
    }
  },
  {
    name: 'browser_get_by_placeholder',
    description: '通过占位符查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' },
        exact: { type: 'boolean' }
      },
      required: ['text']
    }
  },
  {
    name: 'browser_get_by_test_id',
    description: '通过测试ID查找元素',
    inputSchema: {
      type: 'object',
      properties: { testId: { type: 'string' } },
      required: ['testId']
    }
  },
  {
    name: 'browser_get_by_alt_text',
    description: '通过alt文本查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' },
        exact: { type: 'boolean' }
      },
      required: ['text']
    }
  },
  {
    name: 'browser_get_by_title',
    description: '通过title属性查找元素',
    inputSchema: {
      type: 'object',
      properties: {
        text: { type: 'string' },
        exact: { type: 'boolean' }
      },
      required: ['text']
    }
  },

  // ==================== 等待操作 ====================
  {
    name: 'browser_wait_for_selector',
    description: '等待元素出现',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        timeout: { type: 'number' },
        state: { type: 'string', enum: ['attached', 'visible', 'hidden'] }
      },
      required: ['selector']
    }
  },
  {
    name: 'browser_wait_for_timeout',
    description: '等待指定时间',
    inputSchema: {
      type: 'object',
      properties: { timeout: { type: 'number' } },
      required: ['timeout']
    }
  },
  {
    name: 'browser_wait_for_url',
    description: '等待URL匹配',
    inputSchema: {
      type: 'object',
      properties: {
        url: { type: 'string' },
        timeout: { type: 'number' }
      },
      required: ['url']
    }
  },
  {
    name: 'browser_wait_for_request',
    description: '等待网络请求',
    inputSchema: {
      type: 'object',
      properties: {
        urlPattern: { type: 'string' },
        timeout: { type: 'number' }
      },
      required: ['urlPattern']
    }
  },
  {
    name: 'browser_wait_for_response',
    description: '等待网络响应',
    inputSchema: {
      type: 'object',
      properties: {
        urlPattern: { type: 'string' },
        timeout: { type: 'number' }
      },
      required: ['urlPattern']
    }
  },
  {
    name: 'browser_wait_for_function',
    description: '等待函数返回true',
    inputSchema: {
      type: 'object',
      properties: {
        fn: { type: 'string' },
        arg: { type: 'any' },
        timeout: { type: 'number' },
        polling: { type: 'number' }
      },
      required: ['fn']
    }
  },
  {
    name: 'browser_wait_for_load_state',
    description: '等待页面加载状态',
    inputSchema: {
      type: 'object',
      properties: {
        state: { type: 'string', enum: ['load', 'domcontentloaded', 'networkidle'] },
        timeout: { type: 'number' }
      },
      required: ['state']
    }
  },

  // ==================== 截图和PDF ====================
  {
    name: 'browser_screenshot',
    description: '截取页面截图',
    inputSchema: {
      type: 'object',
      properties: {
        path: { type: 'string' },
        fullPage: { type: 'boolean' },
        type: { type: 'string', enum: ['png', 'jpeg'] },
        quality: { type: 'number' }
      }
    }
  },
  {
    name: 'browser_screenshot_element',
    description: '截取元素截图',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        path: { type: 'string' }
      },
      required: ['selector']
    }
  },
  {
    name: 'browser_pdf',
    description: '生成PDF',
    inputSchema: {
      type: 'object',
      properties: {
        path: { type: 'string' },
        format: { type: 'string' },
        printBackground: { type: 'boolean' }
      }
    }
  },

  // ==================== JavaScript执行 ====================
  {
    name: 'browser_evaluate',
    description: '执行JavaScript代码',
    inputSchema: {
      type: 'object',
      properties: {
        script: { type: 'string' },
        arg: { type: 'any' }
      },
      required: ['script']
    }
  },
  {
    name: 'browser_add_script_tag',
    description: '添加脚本标签',
    inputSchema: {
      type: 'object',
      properties: {
        url: { type: 'string' },
        content: { type: 'string' }
      }
    }
  },
  {
    name: 'browser_add_style_tag',
    description: '添加样式标签',
    inputSchema: {
      type: 'object',
      properties: {
        url: { type: 'string' },
        content: { type: 'string' }
      }
    }
  },

  // ==================== Cookie和存储 ====================
  {
    name: 'browser_set_cookies',
    description: '设置Cookie',
    inputSchema: {
      type: 'object',
      properties: {
        cookies: { type: 'array' }
      },
      required: ['cookies']
    }
  },
  {
    name: 'browser_get_cookies',
    description: '获取Cookie',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_clear_cookies',
    description: '清除Cookie',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_set_local_storage',
    description: '设置LocalStorage',
    inputSchema: {
      type: 'object',
      properties: {
        key: { type: 'string' },
        value: { type: 'string' }
      },
      required: ['key', 'value']
    }
  },
  {
    name: 'browser_get_local_storage',
    description: '获取LocalStorage',
    inputSchema: {
      type: 'object',
      properties: { key: { type: 'string' } }
    }
  },
  {
    name: 'browser_clear_local_storage',
    description: '清除LocalStorage',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_storage_state',
    description: '保存存储状态',
    inputSchema: {
      type: 'object',
      properties: { path: { type: 'string' } }
    }
  },
  {
    name: 'browser_restore_storage_state',
    description: '恢复存储状态',
    inputSchema: {
      type: 'object',
      properties: { state: { type: 'object' } },
      required: ['state']
    }
  },

  // ==================== 网络控制 ====================
  {
    name: 'browser_set_offline',
    description: '设置离线模式',
    inputSchema: {
      type: 'object',
      properties: { offline: { type: 'boolean' } },
      required: ['offline']
    }
  },
  {
    name: 'browser_block_requests',
    description: '拦截请求',
    inputSchema: {
      type: 'object',
      properties: { patterns: { type: 'array' } },
      required: ['patterns']
    }
  },
  {
    name: 'browser_mock_response',
    description: '模拟响应',
    inputSchema: {
      type: 'object',
      properties: {
        urlPattern: { type: 'string' },
        response: { type: 'object' }
      },
      required: ['urlPattern', 'response']
    }
  },
  {
    name: 'browser_get_request_logs',
    description: '获取请求日志',
    inputSchema: {
      type: 'object',
      properties: { limit: { type: 'number' } }
    }
  },
  {
    name: 'browser_get_response_logs',
    description: '获取响应日志',
    inputSchema: {
      type: 'object',
      properties: { limit: { type: 'number' } }
    }
  },
  {
    name: 'browser_get_console_logs',
    description: '获取控制台日志',
    inputSchema: {
      type: 'object',
      properties: { limit: { type: 'number' } }
    }
  },
  {
    name: 'browser_clear_logs',
    description: '清除所有日志',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 文件操作 ====================
  {
    name: 'browser_upload_file',
    description: '上传文件',
    inputSchema: {
      type: 'object',
      properties: {
        selector: { type: 'string' },
        filePath: { type: ['string', 'array'] }
      },
      required: ['selector', 'filePath']
    }
  },
  {
    name: 'browser_download_file',
    description: '下载文件',
    inputSchema: {
      type: 'object',
      properties: { triggerSelector: { type: 'string' } },
      required: ['triggerSelector']
    }
  },

  // ==================== Frame操作 ====================
  {
    name: 'browser_get_frames',
    description: '获取所有frame',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 视口和设备 ====================
  {
    name: 'browser_set_viewport_size',
    description: '设置视口大小',
    inputSchema: {
      type: 'object',
      properties: {
        width: { type: 'number' },
        height: { type: 'number' }
      },
      required: ['width', 'height']
    }
  },
  {
    name: 'browser_get_viewport_size',
    description: '获取视口大小',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_emulate_media',
    description: '模拟媒体类型',
    inputSchema: {
      type: 'object',
      properties: {
        colorScheme: { type: 'string', enum: ['light', 'dark', 'no-preference'] },
        media: { type: 'string', enum: ['screen', 'print'] }
      }
    }
  },
  {
    name: 'browser_set_geolocation',
    description: '设置地理位置',
    inputSchema: {
      type: 'object',
      properties: {
        latitude: { type: 'number' },
        longitude: { type: 'number' },
        accuracy: { type: 'number' }
      },
      required: ['latitude', 'longitude']
    }
  },
  {
    name: 'browser_clear_geolocation',
    description: '清除地理位置',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_touchscreen_tap',
    description: '触摸屏点击坐标',
    inputSchema: {
      type: 'object',
      properties: {
        x: { type: 'number' },
        y: { type: 'number' }
      },
      required: ['x', 'y']
    }
  },

  // ==================== 滚动操作 ====================
  {
    name: 'browser_scroll_to',
    description: '滚动到指定位置',
    inputSchema: {
      type: 'object',
      properties: {
        x: { type: 'number' },
        y: { type: 'number' }
      },
      required: ['x', 'y']
    }
  },
  {
    name: 'browser_scroll_into_view',
    description: '滚动元素到可见区域',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } },
      required: ['selector']
    }
  },

  // ==================== 对话框处理 ====================
  {
    name: 'browser_handle_dialog',
    description: '处理对话框',
    inputSchema: {
      type: 'object',
      properties: {
        action: { type: 'string', enum: ['accept', 'dismiss'] },
        promptText: { type: 'string' }
      },
      required: ['action']
    }
  },

  // ==================== 性能和指标 ====================
  {
    name: 'browser_get_metrics',
    description: '获取性能指标',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_get_coverage',
    description: '开始收集代码覆盖率',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_stop_coverage',
    description: '停止收集代码覆盖率',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 无障碍 ====================
  {
    name: 'browser_get_accessibility_snapshot',
    description: '获取无障碍快照',
    inputSchema: {
      type: 'object',
      properties: { selector: { type: 'string' } }
    }
  },

  // ==================== 时间控制 ====================
  {
    name: 'browser_install_clock',
    description: '安装时钟控制',
    inputSchema: {
      type: 'object',
      properties: { time: { type: ['number', 'string'] } }
    }
  },
  {
    name: 'browser_set_system_time',
    description: '设置系统时间',
    inputSchema: {
      type: 'object',
      properties: { time: { type: ['number', 'string'] } },
      required: ['time']
    }
  },
  {
    name: 'browser_fast_forward',
    description: '快进时间',
    inputSchema: {
      type: 'object',
      properties: { time: { type: 'number' } },
      required: ['time']
    }
  },
  {
    name: 'browser_pause_clock',
    description: '暂停时钟',
    inputSchema: { type: 'object', properties: {} }
  },
  {
    name: 'browser_resume_clock',
    description: '恢复时钟',
    inputSchema: { type: 'object', properties: {} }
  },

  // ==================== 权限管理 ====================
  {
    name: 'browser_grant_permissions',
    description: '授予权限',
    inputSchema: {
      type: 'object',
      properties: {
        permissions: { type: 'array' },
        origin: { type: 'string' }
      },
      required: ['permissions']
    }
  },
  {
    name: 'browser_clear_permissions',
    description: '清除权限',
    inputSchema: { type: 'object', properties: {} }
  }
];

export const toolCount = toolsRegistry.length;
