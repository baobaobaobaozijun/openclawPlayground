<!-- Last Modified: 2026-03-09 -->
<!-- Last Modified (CN): 2026-03-09 -->

# TOOLS.md - 本地笔记

## 📁 权限边界

**⚠️ 重要：写操作限制**

| 路径 | 权限 | 说明 |
|------|------|------|
| `F:\openclaw\agent\workspace-dousha\*` | ✅ 可写 | 我的工作空间 |
| `F:\openclaw\code\frontend\*` | ✅ 可写 | 前端代码目录 |
| `F:\openclaw\agent\workspace-*\*` | ⚠️ 只读 | 其他 Agent 工作空间 |
| `F:\openclaw\code\backend\*` | ❌ 只读 | 后端代码 |
| `C:\*` | ❌ 禁止 | 系统目录 |
| 其他所有路径 | ❌ 只读 | 外部数据 |

---

## 🏢 Agent 工作空间配置

### 豆沙 (前端工程师) 🍡
- **Workspace**: `F:\openclaw\agent\workspace-dousha`
- **Code**: `F:\openclaw\code\frontend`
- **Docker 挂载**: `/app/workspace` + `/app/frontend`
- **端口**: `18792` (容器映射)
- **职责**: 
  - Vue 3 + TypeScript 前端开发
  - UI/UX 设计与实现
  - 响应式网页设计
  - 前端性能优化
  - 跨浏览器兼容性测试

### 技术栈详情

**核心框架:**
- Vue.js 3.4+ (Composition API)
- TypeScript 5.3+
- Vite 5.0+
- Pinia 2.1+

**UI 组件库:**
- Element Plus 2.5+ (PC 端)
- Vant 4.7+ (移动端)
- Tailwind CSS 3.4+

**工具库:**
- Vue Router 4.2+
- Axios 1.6+
- ECharts 5.4+ (数据可视化)
- Day.js 1.11+ (日期处理)

**开发环境:**
- Node.js 20.x LTS
- npm / pnpm
- VS Code + Volar 插件
- Chrome DevTools

### 酱肉 (后端工程师) 🍖
- **Workspace**: `F:\openclaw\agent\workspace-jiangrou`
- **Code**: `F:\openclaw\code\backend`
- **技术栈**: Java 21 + Spring Boot 3.2+ + MySQL 8.0+ + Redis 7.0+

### 灌汤 (产品经理) 🍲
- **Workspace**: `F:\openclaw\agent\workspace-guantang`
- **职责**: 产品规划、需求分析、任务分配、进度跟踪

### 酸菜 (运维工程师) 🥬
- **Workspace**: `F:\openclaw\agent\workspace-suancai`
- **Code**: `F:\openclaw\code\deploy` + `F:\openclaw\code\tests`
- **职责**: Docker 部署、CI/CD、监控告警、自动化测试

---

## 🛠️ 我的 Skills

### 1. working-logger 📝

**用途:** 记录对 `F:\openclaw\agent\workspace-dousha` 的所有修改

**日志位置:** `F:\openclaw\agent\workspace-dousha\logs\`

**文件名格式:** `daily_YYYYMMDD.md`

### 2. auto-github-push 🚀

**用途:** 自动推送代码到 GitHub

**仓库:** https://github.com/baobaobaobaozijun/openclawPlayground

**触发时机:** 每次修改完 workspace-dousha 文件夹后

---

## 📡 Agent 通信

### 收件箱路径

| Agent | 收件箱 |
|-------|--------|
| 豆沙 | `F:\openclaw\agent\workspace-dousha\communication\inbox\dousha\` |
| 酱肉 | `F:\openclaw\agent\workspace-jiangrou\communication\inbox\jiangrou\` |
| 酸菜 | `F:\openclaw\agent\workspace-suancai\communication\inbox\suancai\` |
| 灌汤 | `F:\openclaw\agent\workspace-guantang\communication\inbox\guantang\` |

### 消息格式

```json
{
  "from": "dousha",
  "to": "{agent}",
  "action": "{action}",
  "data": {},
  "timestamp": "ISO8601"
}
```

### 常见通信场景

**与酱肉协作:**
- 确认 API 接口定义和数据格式
- 及时反馈接口问题和建议
- 配合进行接口联调
- 共同制定错误处理机制

**与灌汤协作:**
- 理解产品需求和用户场景
- 提供设计方案并确认
- 收集用户反馈并迭代
- 参与产品评审

**与酸菜协作:**
- 配置前端监控和错误追踪
- 性能指标监控
- 自动化测试集成
- 部署流程优化

---

## 🔧 常用命令

```bash
# 启动开发服务器
cd F:\openclaw\code\frontend
npm run dev

# 构建生产版本
npm run build

# 类型检查
npm run type-check

# 运行测试
npm run test

# 代码格式化
npm run lint -- --fix

# GitHub 认证
gh auth login

# 检查 git 状态
cd F:\openclaw\agent\workspace-dousha && git status

# 手动推送
cd F:\openclaw\agent\workspace-dousha && git add . && git commit -m "message" && git push

# 安装 skill
cd F:\openclaw\agent\workspace-dousha
npx clawhub install <skill-name>
```

---

## 📊 性能指标监控

### 关键指标

- **页面加载时间**: < 2s
- **首屏渲染时间 (FCP)**: < 1s
- **Lighthouse 性能评分**: ≥ 90
- ** bundle 体积**: < 500KB (gzipped)
- **API 响应时间**: P95 < 300ms

### 监控工具

- Chrome DevTools Performance
- Lighthouse CI
- Web Vitals Extension
- Bundle Analyzer

---

*最后更新：2026-03-09*  
*维护者：豆沙 (Dousha)*
