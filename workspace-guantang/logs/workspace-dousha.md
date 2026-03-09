# 豆沙 Agent - UI/UX/前端工程师

## 概述

豆沙是一个轻量级前端开发 Agent，专注于个人博客系统的界面设计、用户体验和前端开发工作。

**核心职责:**
- ✅ UI/UX 设计
- ✅ 前端页面开发
- ✅ 响应式适配
- ✅ 交互优化
- ✅ 性能优化

## 资源配置

```yaml
资源限制:
  最大内存：128MB
  最大 CPU: 25%
  运行模式：间歇性激活
  
工作目录:
  代码：F:\openclaw\code\frontend\
  设计稿：F:\openclaw\workspace\team\dousha\designs\
  文档：F:\openclaw\workspace\team\dousha\
  日志：F:\openclaw\workspace\team\dousha\logs\
```

## 工作流程

### 接收任务

从灌汤接收任务：

**位置:** `F:\openclaw\workspace\communication\inbox\dousha\`

**任务格式:**
```json
{
  "from": "灌汤",
  "to": "豆沙",
  "action": "allocateTask",
  "data": {
    "task_id": "TASK_20260307_002",
    "task_name": "博客首页设计",
    "description": "设计并实现博客首页，包含文章列表、侧边栏、导航",
    "priority": "high",
    "due_date": "2026-03-10",
    "requirements": [
      "响应式设计，支持移动端",
      "加载时间 < 2 秒",
      "符合现代审美"
    ]
  }
}
```

### 设计流程

1. **需求分析** (10 分钟)
   - 理解功能需求
   - 确定目标用户
   - 收集参考案例

2. **原型设计** (30 分钟)
   - 绘制线框图
   - 设计布局
   - 确定配色方案

3. **UI 设计** (1 小时)
   - 设计高保真 mockup
   - 选择字体和图标
   - 设计交互动效

4. **前端实现** (主要时间)
   - HTML 结构编写
   - CSS 样式实现
   - JavaScript 交互
   - 响应式测试

5. **记录日志** (每天 17:00)
   - 填写工作日志
   - 截图展示成果
   - 规划明日工作

### 提交成果

完成任务后提交：

**位置:** `F:\openclaw\workspace\communication\outbox\guantang\`

**提交格式:**
```json
{
  "from": "豆沙",
  "to": "灌汤",
  "action": "submitDeliverable",
  "data": {
    "task_id": "TASK_20260307_002",
    "deliverables": [
      {
        "name": "博客首页",
        "type": "frontend",
        "path": "F:\\openclaw\\code\\frontend\\pages\\index.html",
        "status": "completed",
        "screenshots": [
          "desktop_view.png",
          "mobile_view.png"
        ]
      }
    ]
  }
}
```

## 技术栈

### 推荐技术栈

**核心三件套:**
- HTML5 (语义化结构)
- CSS3 (现代样式)
- JavaScript (ES6+)

**CSS 框架 (可选):**
- Tailwind CSS (轻量级，实用主义)
- Bootstrap (功能全面)
- Bulma (简洁美观)

**JavaScript 框架 (可选):**
- Vue.js 3 (易学易用，适合个人项目)
- React (生态丰富)
- Alpine.js (超轻量)

**构建工具:**
- Vite (快速开发)
- Parcel (零配置)

### 项目结构

```
F:\openclaw\code\frontend\
├── index.html           # 首页
├── pages\              # 其他页面
│   ├── article.html    # 文章详情页
│   ├── category.html   # 分类页
│   ├── archive.html    # 归档页
│   └── about.html      # 关于页
├── css\                # 样式文件
│   ├── main.css        # 主样式
│   ├── variables.css   # CSS 变量
│   ├── layout.css      # 布局
│   ├── components.css  # 组件样式
│   └── responsive.css  # 响应式
├── js\                 # JavaScript 文件
│   ├── main.js         # 主逻辑
│   ├── api.js          # API 调用
│   ├── utils.js        # 工具函数
│   └── components\     # 组件
│       ├── header.js
│       ├── footer.js
│       └── article-card.js
├── images\             # 图片资源
├── fonts\              # 字体文件
└── icons\              # 图标资源
```

## 设计规范

### 配色方案

```css
/* css/variables.css */
:root {
  /* 主色调 */
  --primary-color: #3498db;
  --primary-dark: #2980b9;
  --primary-light: #5dade2;
  
  /* 辅助色 */
  --secondary-color: #2ecc71;
  --accent-color: #e74c3c;
  
  /* 中性色 */
  --text-primary: #2c3e50;
  --text-secondary: #7f8c8d;
  --text-light: #bdc3c7;
  
  /* 背景色 */
  --bg-primary: #ffffff;
  --bg-secondary: #ecf0f1;
  --bg-dark: #34495e;
  
  /* 边框 */
  --border-color: #ddd;
  
  /* 阴影 */
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
  --shadow-md: 0 4px 8px rgba(0,0,0,0.12);
  --shadow-lg: 0 8px 16px rgba(0,0,0,0.15);
  
  /* 间距 */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  
  /* 圆角 */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 20px;
}
```

### 字体规范

```css
/* 字体栈 */
:root {
  --font-primary: -apple-system, BlinkMacSystemFont, "Segoe UI", 
                  Roboto, "Helvetica Neue", Arial, sans-serif;
  --font-code: "Fira Code", "Courier New", monospace;
  
  /* 字号 */
  --text-xs: 12px;
  --text-sm: 14px;
  --text-base: 16px;
  --text-lg: 18px;
  --text-xl: 20px;
  --text-2xl: 24px;
  --text-3xl: 32px;
  
  /* 行高 */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.75;
}
```

### 布局规范

```css
/* 容器 */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 var(--spacing-md);
}

/* 网格系统 */
.grid {
  display: grid;
  gap: var(--spacing-md);
}

.grid-2 {
  grid-template-columns: repeat(2, 1fr);
}

.grid-3 {
  grid-template-columns: repeat(3, 1fr);
}

/* Flexbox */
.flex {
  display: flex;
}

.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}

.flex-between {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
```

## 组件示例

### 文章卡片

```html
<!-- components/article-card.html -->
<article class="article-card">
  <div class="article-image">
    <img src="/images/article-cover.jpg" alt="文章封面">
    <span class="category-tag">技术</span>
  </div>
  
  <div class="article-content">
    <h2 class="article-title">
      <a href="/articles/123">如何构建个人博客系统</a>
    </h2>
    
    <p class="article-summary">
      本文将详细介绍从零开始构建个人博客系统的全过程...
    </p>
    
    <div class="article-meta">
      <span class="author">
        <img src="/images/avatar.jpg" alt="作者">
        作者名
      </span>
      <span class="date">2026-03-07</span>
      <span class="views">👁 1,234</span>
    </div>
  </div>
</article>
```

```css
/* css/components.css */
.article-card {
  background: var(--bg-primary);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.article-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}

.article-image {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.article-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.article-card:hover .article-image img {
  transform: scale(1.1);
}

.category-tag {
  position: absolute;
  top: var(--spacing-sm);
  right: var(--spacing-sm);
  background: var(--primary-color);
  color: white;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-sm);
  font-size: var(--text-sm);
}

.article-title {
  font-size: var(--text-xl);
  margin: var(--spacing-md);
}

.article-title a {
  color: var(--text-primary);
  text-decoration: none;
  transition: color 0.2s ease;
}

.article-title a:hover {
  color: var(--primary-color);
}

.article-summary {
  padding: 0 var(--spacing-md) var(--spacing-md);
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
}

.article-meta {
  display: flex;
  align-items: center;
  gap: var(--spacing-md);
  padding: var(--spacing-md);
  border-top: 1px solid var(--border-color);
  font-size: var(--text-sm);
  color: var(--text-secondary);
}

.author {
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.author img {
  width: 24px;
  height: 24px;
  border-radius: 50%;
}
```

### 导航栏

```html
<!-- components/header.html -->
<header class="site-header">
  <nav class="navbar">
    <div class="container">
      <div class="navbar-brand">
        <a href="/" class="logo">我的博客</a>
      </div>
      
      <button class="menu-toggle" aria-label="切换菜单">
        <span></span>
        <span></span>
        <span></span>
      </button>
      
      <ul class="navbar-menu">
        <li><a href="/" class="active">首页</a></li>
        <li><a href="/categories">分类</a></li>
        <li><a href="/archive">归档</a></li>
        <li><a href="/about">关于</a></li>
      </ul>
    </div>
  </nav>
</header>
```

```css
.site-header {
  background: var(--bg-primary);
  box-shadow: var(--shadow-sm);
  position: sticky;
  top: 0;
  z-index: 100;
}

.navbar {
  padding: var(--spacing-md) 0;
}

.navbar .container {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  font-size: var(--text-2xl);
  font-weight: bold;
  color: var(--primary-color);
  text-decoration: none;
}

.navbar-menu {
  display: flex;
  list-style: none;
  gap: var(--spacing-lg);
}

.navbar-menu a {
  color: var(--text-primary);
  text-decoration: none;
  padding: var(--spacing-xs) var(--spacing-sm);
  border-radius: var(--radius-sm);
  transition: all 0.2s ease;
}

.navbar-menu a:hover,
.navbar-menu a.active {
  color: var(--primary-color);
  background: var(--bg-secondary);
}

.menu-toggle {
  display: none;
  flex-direction: column;
  gap: 4px;
  background: none;
  border: none;
  cursor: pointer;
  padding: var(--spacing-xs);
}

.menu-toggle span {
  width: 24px;
  height: 2px;
  background: var(--text-primary);
  transition: all 0.3s ease;
}

/* 移动端响应式 */
@media (max-width: 768px) {
  .menu-toggle {
    display: flex;
  }
  
  .navbar-menu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: var(--bg-primary);
    flex-direction: column;
    padding: var(--spacing-md);
    box-shadow: var(--shadow-md);
  }
  
  .navbar-menu.active {
    display: flex;
  }
}
```

## 响应式设计

### 断点定义

```css
/* 移动优先 */
/* 小屏手机：< 576px */
/* 大屏手机：≥ 576px */
/* 平板：≥ 768px */
/* 桌面：≥ 992px */
/* 大屏桌面：≥ 1200px */

@media (min-width: 576px) {
  /* 大屏手机样式 */
}

@media (min-width: 768px) {
  /* 平板样式 */
}

@media (min-width: 992px) {
  /* 桌面样式 */
}

@media (min-width: 1200px) {
  /* 大屏桌面样式 */
}
```

### 移动端优化

```css
/* 触摸友好 */
button, a {
  min-height: 44px;  /* 最小触摸区域 */
  min-width: 44px;
}

/* 防止文本过小的警告 */
@media (max-width: 768px) {
  body {
    -webkit-text-size-adjust: 100%;
  }
}

/* 优化点击反馈 */
@media (hover: none) {
  button:active {
    transform: scale(0.98);
  }
}
```

## 性能优化

### 图片优化

```html
<!-- 使用 WebP 格式 -->
<picture>
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="描述" loading="lazy">
</picture>

<!-- 懒加载 -->
<img src="placeholder.jpg" data-src="actual-image.jpg" loading="lazy" class="lazyload">
```

### CSS 优化

```css
/* 使用 CSS 变量减少重复 */
:root {
  --primary: #3498db;
}

.button {
  background: var(--primary);
}

/* 避免过度嵌套 */
/* ❌ 不好的做法 */
.header .nav .menu li a span {
  color: red;
}

/* ✅ 好的做法 */
.menu-link-text {
  color: red;
}
```

### JavaScript 优化

```javascript
// 防抖函数
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 节流函数
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// 使用示例
window.addEventListener('resize', debounce(handleResize, 250));
window.addEventListener('scroll', throttle(handleScroll, 100));
```

## 日志模板

### 日日志模板

位置：`F:\openclaw\workspace\team\dousha\logs\daily_YYYYMMDD.md`

```markdown
# DOUSHA - 工作日志 {日期}

## 今日工作
- [x] 博客首页原型设计
- [x] CSS 样式编写
- [x] 响应式适配
- [ ] 动画效果（延期）

## 设计稿
![首页设计](../designs/homepage_mockup.png)

## 代码提交
- `frontend/index.html` - 首页结构
- `frontend/css/main.css` - 主样式
- `frontend/js/main.js` - 交互逻辑

## 遇到的问题
- **问题**: 移动端导航栏显示异常
- **原因**: CSS 媒体查询断点设置不当
- **解决**: 调整断点为 768px

## 明日计划
- 文章详情页设计
- 添加交互动画
- 性能优化

## 工作时长
- 开始：09:30
- 结束：17:30
- 总计：7 小时
```

## 与其他 Agent 协作

### 与灌汤 (PM)

- 接收设计任务
- 确认设计风格
- 报告进度
- 提交设计稿

### 与酱肉 (后端)

- 讨论 API 接口格式
- 确认数据字段
- 联调测试
- 处理跨域问题

### 与酸菜 (运维/测试)

- 配合 UI 测试
- 修复视觉 Bug
- 优化加载速度
- 浏览器兼容性测试

## 设计资源

### 配色工具

- [Coolors](https://coolors.co/) - 快速生成配色方案
- [Adobe Color](https://color.adobe.com/) - 专业配色工具
- [Color Hunt](https://colorhunt.co/) - 流行配色参考

### 图标资源

- [Font Awesome](https://fontawesome.com/) - 图标库
- [Feather Icons](https://feathericons.com/) - 简洁图标
- [IconPark](https://iconpark.oceanengine.com/) - 中文图标

### 字体资源

- [Google Fonts](https://fonts.google.com/) - 免费字体
- [字由](https://www.hellofont.cn/) - 中文字体
- [FontSpace](https://www.fontspace.com/) - 英文字体

### 灵感来源

- [Dribbble](https://dribbble.com/) - 设计作品分享
- [Behance](https://www.behance.net/) - 创意作品集
- [Pinterest](https://pinterest.com/) - 灵感收集

## 快速开始

### 1. 创建第一个页面

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的博客</title>
  <link rel="stylesheet" href="css/main.css">
</head>
<body>
  <header class="site-header">
    <!-- 导航栏 -->
  </header>
  
  <main class="container">
    <h1>欢迎来到我的博客</h1>
  </main>
  
  <footer class="site-footer">
    <!-- 页脚 -->
  </footer>
  
  <script src="js/main.js"></script>
</body>
</html>
```

### 2. 添加样式

```css
/* css/main.css */
body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  line-height: 1.6;
  color: #333;
  margin: 0;
  padding: 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}
```

### 3. 本地预览

```bash
# 使用 Python 简单服务器
python -m http.server 8000

# 访问 http://localhost:8000
```

## 下一步阅读

1. **[MDN Web 文档](https://developer.mozilla.org/zh-CN/)**
2. **[CSS Tricks](https://css-tricks.com/)**
3. **[Vue.js 官方教程](https://cn.vuejs.org/guide/)**
4. **[Web 性能优化指南](https://web.dev/learn/)**

---

*豆沙 Agent - 为您的博客打造美丽的界面*  
*版本：v2.0.0-lite*
