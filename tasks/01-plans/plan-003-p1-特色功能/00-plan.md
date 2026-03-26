<!-- Last Modified: 2026-03-25 23:25 -->

# Plan-03: 特色功能实现

**计划状态:** ⏳ 执行中 (第 2 轮)  
**创建日期:** 2026-03-25 23:25  
**负责人:** 灌汤 (PM)  
**执行周期:** 2026-03-26 03:30 ~ 2026-03-26 05:00（1.5 小时）  
**总轮次:** 5 轮

---

## 📊 当前进度

| 轮次 | 任务 | 负责人 | 状态 | 完成时间 |
|------|------|--------|------|----------|
| 1 | 定时任务框架配置 | 酱肉 🍖 | ✅ 完成 | 2026-03-26 10:03 |
| 2 | 文章发布调度任务 | 酱肉 🍖 | ⏳ 执行中 | - |
| 3 | 工作日志解析逻辑 | 酱肉 🍖 | ⏸️ 待执行 | - |
| 4 | 自动提交文章逻辑 | 酱肉 🍖 | ⏸️ 待执行 | - |
| 5 | Agent 状态 API | 酱肉 🍖 | ⏸️ 待执行 | - |

---

## 📋 计划目标

实现博客系统差异化特色功能（工作日志自动提交 + Agent 状态展示）。

### 覆盖的差异问题
| 编号 | 问题 | 类别 | 优先级 |
|------|------|------|--------|
| 🟢 #1 | 功能缺失（工作日志自动提交） | 功能缺失 | P1 |
| 🟢 #2 | 功能缺失（Agent 状态展示） | 功能缺失 | P1 |

---

## 🎯 成功标准

- [ ] 定时任务每日 18:00 自动执行
- [ ] 工作日志解析成功（markdown 格式）
- [ ] 自动创建文章（调用文章 API）
- [ ] Agent 状态 API 可调用
- [ ] 前端状态组件正常显示
- [ ] 轮询更新正常（30s 间隔）

---

## 📅 轮次安排

### 第 1 轮：定时任务框架配置

**负责人:** 酱肉 🍖  
**预计耗时:** 15 分钟  
**触发条件:** Plan-02 完成

**任务:**
1. 添加 Spring @EnableScheduling 配置
2. 创建调度器配置类
3. Maven 编译验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\config\SchedulerConfig.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan03-round1.md`

**验收标准:**
- [ ] @EnableScheduling 注解已添加
- [ ] 配置类语法正确
- [ ] 编译通过

**PM 验证:** 编译命令 + 代码检查

---

### 第 2 轮：工作日志解析逻辑

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 1 轮验收通过

**任务:**
1. 创建 LogParser.java（解析 markdown 日志）
2. 读取 workinglog 目录（4 个 Agent）
3. 提取关键信息（修改内容、修改文件、时间）
4. 单元测试验证

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\service\LogParser.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan03-round2.md`

**验收标准:**
- [ ] 可读取 markdown 文件
- [ ] 提取标题、内容、修改文件列表
- [ ] 支持 4 个 Agent 目录
- [ ] 编译通过

**PM 验证:** 代码检查 + 模拟测试

---

### 第 3 轮：自动提交文章逻辑

**负责人:** 酱肉 🍖  
**预计耗时:** 30 分钟  
**触发条件:** 第 2 轮验收通过

**任务:**
1. 创建 LogAutoSubmitScheduler.java
2. 实现 @Scheduled 方法（Cron: 0 0 18 * * ?）
3. 调用 ArticleService 创建文章
4. 记录提交日志

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\scheduler\LogAutoSubmitScheduler.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan03-round3.md`

**验收标准:**
- [ ] Cron 表达式正确（每日 18:00）
- [ ] 遍历 4 个 Agent 日志目录
- [ ] 调用 ArticleService.create()
- [ ] 记录提交成功/失败日志
- [ ] 编译通过

**PM 验证:** 代码检查 + 手动触发测试

---

### 第 4 轮：Agent 状态 API

**负责人:** 酱肉 🍖  
**预计耗时:** 15 分钟  
**触发条件:** 第 3 轮验收通过

**任务:**
1. 创建 AgentStatus.java（Entity）
2. 创建 AgentStatusController.java
3. 实现 GET /api/agent/status 接口
4. 返回 4 个 Agent 状态

**交付物:**
- `F:\openclaw\code\backend\src\main\java\com\baozipu\entity\AgentStatus.java`
- `F:\openclaw\code\backend\src\main\java\com\baozipu\controller\AgentStatusController.java`
- `F:\openclaw\agent\workinglog\jiangrou\{timestamp}-jiangrou-plan03-round4.md`

**验收标准:**
- [ ] AgentStatus 包含 name, status, lastActivity, currentTask
- [ ] GET /api/agent/status 返回 4 个 Agent 状态
- [ ] 状态可手动更新（用于测试）
- [ ] 编译通过

**PM 验证:** Postman 测试

---

### 第 5 轮：前端状态组件 + 轮询

**负责人:** 豆沙 🍡  
**预计耗时:** 30 分钟  
**触发条件:** 第 4 轮验收通过

**任务:**
1. 创建 AgentStatus.vue 组件
2. 实现 30s 轮询逻辑（setInterval）
3. 状态卡片 UI（4 个 Agent）
4. 集成到首页

**交付物:**
- `F:\openclaw\code\frontend\src\components\AgentStatus.vue`
- `F:\openclaw\code\frontend\src\api\agent.ts`
- `F:\openclaw\agent\workinglog\dousha\{timestamp}-dousha-plan03-round5.md`
- `F:\openclaw\agent\tasks\plan-03\review.md`（复盘报告）

**验收标准:**
- [ ] 组件显示 4 个 Agent 状态卡片
- [ ] 每 30s 自动刷新
- [ ] 状态颜色区分（正常/空闲/失联）
- [ ] 集成到 Home.vue
- [ ] TypeScript 编译通过

**PM 验证:** 浏览器访问 + 控制台检查

---

## 🔧 执行流程

```
Plan-02 完成
    ↓
[轮次 1] 酱肉 - 定时任务配置
    ↓ (PM 验证)
[轮次 2] 酱肉 - 日志解析逻辑
    ↓ (PM 验证)
[轮次 3] 酱肉 - 自动提交调度
    ↓ (PM 验证)
[轮次 4] 酱肉 - Agent 状态 API
    ↓ (PM 验证)
[轮次 5] 豆沙 - 前端状态组件
    ↓
Plan-03 完成 ✅
```

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| 定时任务不触发 | 低 | 高 | 检查 @EnableScheduling |
| 日志解析失败 | 中 | 中 | 增加错误处理 |
| 文章创建失败 | 中 | 中 | 记录失败日志，不中断 |
| 前端轮询内存泄漏 | 低 | 中 | 组件销毁时 clearInterval |

---

## 📊 依赖关系

**前置依赖:** Plan-02（文章管理 API）  
**后续依赖:** Plan-05（文档验收）

**跨 Agent 依赖:**
- 轮次 1-4：酱肉独立完成
- 轮次 5：豆沙执行，灌汤验证

---

## 📁 文件索引

**计划文档:** `F:\openclaw\agent\tasks\plan-03\plan.md`  
**工单目录:** `F:\openclaw\agent\tasks\plan-03\orders\`  
**验证清单:** `F:\openclaw\agent\tasks\plan-03\verify-list.md`  
**复盘报告:** `F:\openclaw\agent\tasks\plan-03\review.md`（待创建）

---

*创建时间：2026-03-25 23:25*  
*下次更新：轮次完成后自动更新*
