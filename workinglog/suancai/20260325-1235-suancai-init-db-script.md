# 工作日志 - 酸菜 - 数据库初始化脚本创建

## 任务信息
- 任务ID: 【PM 灌汤 — 原子任务 🟡 数据库初始化脚本】
- 时间: 2026-03-25 12:35
- 内容: 创建数据库初始化脚本

## 完成的工作
1. 创建了部署脚本 `F:\openclaw\code\deploy\scripts\init-db.sh`
2. 脚本内容: 
   ```bash
   #!/bin/bash
   # 数据库初始化脚本
   # 用法: bash init-db.sh

   echo "=== 初始化博客数据库 ==="
   mysql -u root -p < /opt/baozipu/database/schema.sql
   echo "=== 验证建表结果 ==="
   mysql -u root -p -e "USE baoziblog; SHOW TABLES;"
   echo "=== 完成 ==="
   ```

## 状态
- 脚本已创建完成
- 准备在服务器上执行 schema.sql 建表