// 浏览器全局对象类型声明
// 这些声明使得TypeScript在Node.js环境中识别浏览器API

interface Storage {
  getItem(key: string): string | null;
  setItem(key: string, value: string): void;
  removeItem(key: string): void;
  clear(): void;
  length: number;
  key(index: number): string | null;
}

interface Window {
  localStorage: Storage;
  scrollTo(x: number, y: number): void;
}

interface Performance {
  getEntriesByType(type: string): PerformanceEntry[];
}

interface PerformanceEntry {
  name: string;
  entryType: string;
  startTime: number;
  duration: number;
}

interface PerformanceNavigationTiming extends PerformanceEntry {
  domContentLoadedEventStart: number;
  domContentLoadedEventEnd: number;
  loadEventStart: number;
  loadEventEnd: number;
  fetchStart: number;
  domInteractive: number;
}

// 声明全局变量
declare var localStorage: Storage;
declare var window: Window;
declare var performance: Performance;
// 添加EntryType类型
type EntryType = 
  | 'navigation'
  | 'paint'
  | 'resource'
  | 'mark'
  | 'measure'
  | 'frame'
  | 'server';

// 更新Performance接口
interface Performance {
  getEntriesByType(type: EntryType): PerformanceEntry[];
}