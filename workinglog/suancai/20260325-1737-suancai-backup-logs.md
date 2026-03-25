# 工作日志 - 酸菜

**任务:** 【PM 灌汤 — 原子任务 🟡 日志收集配置 + 备份脚本】

**时间:** 2026-03-25 17:41

**内容:**
1. 创建数据库备份脚本 `F:\openclaw\code\deploy\scripts\backup-db.sh`
2. 创建日志查看脚本 `F:\openclaw\code\deploy\scripts\view-logs.sh`

**详情:**
- backup-db.sh: 包含 MySQL 数据库备份功能，自动清理 7 天前的备份文件
- view-logs.sh: 支持查看不同服务的日志（backend, frontend, mysql, redis, all）

**状态:** 完成 ✅