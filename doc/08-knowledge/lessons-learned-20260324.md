# 2026-03-24 复盘：教训与改进

**记录人:** 灌汤 (PM)
**项目:** 包子铺博客系统
**阶段:** 阶段 1 基础设施

---

## 问题清单

### P1: Schema 不一致
- **现象:** schema.sql (phone/nickname) vs Entity (username/email)
- **影响:** test-data.sql 远程成功本地失败
- **根因:** 无唯一真相源，schema.sql 和 Entity 独立维护
- **修复:** 以 Entity 为准重写 schema.sql，去掉中文注释
- **沉淀:** doc/02-specs/database-schema-management.md

### P2: Subagent 超时截断
- **现象:** 分配 8 个文件只完成 3 个；mvn compile 未执行就超时
- **根因:** sessions_spawn one-shot 模式有上限
- **修复:** 1 spawn = 1 文件 + 完整代码
- **沉淀:** doc/02-specs/agent-verification-protocol.md

### P3: Agent 虚假完成
- **现象:** 酸菜写 7 个"无法连接"日志；PM SSH 一次成功
- **根因:** Agent 未实际调用工具，只写了文字描述
- **修复:** PM 直接执行关键操作 + Test-Path 验证
- **沉淀:** doc/02-specs/agent-verification-protocol.md

### P4: 环境指令不明确
- **现象:** 酸菜在本地装 Redis 而非远程服务器
- **根因:** 任务指令未标注执行环境
- **修复:** 模板增加"执行环境"必填字段
- **沉淀:** 任务分配模板更新

### P5: PowerShell 编码问题
- **现象:** schema.sql 中文注释通过管道传 mysql 变乱码
- **根因:** PowerShell 管道默认编码非 UTF-8
- **修复:** SQL 文件不用中文注释
- **沉淀:** TOOLS.md 更新

### P6: 包结构混淆
- **现象:** PM 以为是 com.openclaw.blog.* 实际是 com.openclaw.*
- **根因:** 未先验证代码结构就分配任务
- **修复:** 分配前 Get-ChildItem -Recurse 确认
- **沉淀:** 项目看板修正

---

## 今日成果

| 项目 | 完成情况 |
|------|---------|
| 远程 Redis | PONG |
| 远程 MySQL openclaw | 5 表 + 测试数据 |
| 本地 MySQL openclaw | 5 表 + 测试数据（与远程一致） |
| 后端 Java 文件 | 42 个 |
| 前端源文件 | 21 个（含 category.ts + NavBar.vue） |
| 部署脚本 | docker-compose.yml + deploy.yml + deploy.ps1 |
| Schema 统一 | 两套环境 3/7/8/6/10 一致 |

---

## 改进措施

| 措施 | 状态 |
|------|------|
| database-schema-management.md | created |
| agent-verification-protocol.md | created |
| schema.sql 去中文注释重写 | done |
| test-data.sql 对齐 Entity | done |
| 两套环境重建验证 | done |

---

*下次分配任务前必读此文档。*
