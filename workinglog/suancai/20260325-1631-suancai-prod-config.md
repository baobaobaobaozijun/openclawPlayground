# 酸菜工作日志 - 生产环境配置

## 任务
- 创建生产环境配置文件 application-prod.yml

## 修改内容
- 创建 F:\openclaw\code\backend\src\main\resources\application-prod.yml
- 配置生产环境的数据库连接、Redis连接、日志等设置
- 关闭生产环境Swagger文档

## 配置详情
- 服务器端口: 8080
- 数据库连接池: HikariCP (最大连接20，最小空闲5)
- Redis连接: 支持环境变量配置
- 日志级别: root为WARN，com.openclaw为INFO
- 日志文件: /var/log/baozipu/application.log
- Swagger: 生产环境禁用

## 时间
2026-03-25 16:35