<!-- Last Modified: 2026-03-09 -->

# API 密钥配置指南

## 问题

三位 Agent 容器日志显示：
```
No API key found for provider "anthropic"
```

## 原因

docker-compose 中配置的是阿里云 API 密钥 (`OPENCLAW_API_KEY`)，但 Agent 内部默认使用 anthropic 模型，需要单独配置 anthropic 的 API 密钥。

## 解决方案

### 方案 1: 修改 docker-compose 使用阿里云模型

当前配置已使用阿里云：
```yaml
OPENCLAW_MODEL=qwen3-coder-plus
OPENCLAW_API_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1
OPENCLAW_API_KEY=sk-xxxxx
```

但容器内 Agent 可能需要重新初始化才能识别。

### 方案 2: 在容器内配置 API 密钥

进入容器执行：
```bash
docker exec -it openclaw-instance-1 openclaw configure --section model
```

或手动创建 auth-profiles.json：
```bash
docker exec -it openclaw-instance-1 bash
# 然后在容器内创建配置文件
```

### 方案 3: 重启容器应用环境变量

```bash
cd F:\openclaw\agent\deployment-2026-03-08\docker-compose
docker-compose -f docker-compose-agents.yml restart
```

---

*待进一步验证*
