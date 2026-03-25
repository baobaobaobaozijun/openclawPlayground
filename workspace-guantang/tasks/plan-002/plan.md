# Plan-002 — 部署上线 + 冒烟测试

## 复盘基础

Plan-001 后项目状态：
- ✅ 后端编译通过（mvn BUILD SUCCESS）
- ✅ 前端构建通过（vite build 2.94s，dist/index.html 已生成）
- ✅ 部署脚本齐全（start.sh + deploy-all.sh + init-db.sh + nginx conf）
- ✅ 远程环境 6/6 验证通过
- 待做：实际部署到服务器 + 冒烟测试

## 本计划目标

把前后端部署到 8.137.175.240 并验证可访问。

## Round 1：打包 + 部署（PM 自执行）

按能力匹配原则，远程命令 PM 直接执行：
1. mvn clean package -DskipTests（后端打包）
2. scp JAR 到服务器
3. scp dist/ 到服务器  
4. SSH 重启后端
5. SSH 重载 Nginx
6. 冒烟测试（curl）

## Round 2：联调修复（按实际结果决定）

根据冒烟测试结果，下达修复工单给对应 Agent。
