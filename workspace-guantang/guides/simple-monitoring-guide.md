# OpenClaw 简化版监控方案

**版本:** v2.0 (简化实用版)  
**日期:** 2026-03-10  
**原则:** 零成本、可操作、灾难现场保护

---

## 🎯 核心功能

### 1. 灌汤监控系统

**脚本位置:** `workspace-guantang/scripts/simple-monitor.ps1`

**执行方式:**
```powershell
cd F:\openclaw\agent\workspace-guantang\scripts
.\simple-monitor.ps1
```

**监控内容:**
- ✅ Gateway 健康状态 (每 5 分钟)
- ✅ Docker 容器状态 (每 5 分钟)
- ✅ Token 使用量 (接近 2000 次时告警)
- ✅ Agent memory.md 更新情况

**故障处理:**
1. **自动保存灾难现场**到 `workspace-guantang/disasters/`
2. **生成详细报告**包含:
   - 错误详情
   - Docker 容器状态
   - 相关日志文件
   - 恢复建议
3. **无需外部通知**,所有信息保存在工作空间内

---

### 2. Agent Memory 机制

每个 Agent 维护一个 `MEMORY.md` 文件，记录:

**酱肉 MEMORY.md:**
- 当前任务进度
- 今日工作日志
- 技术决策记录
- 异常和解决方案
- API 调用统计

**豆沙 MEMORY.md:**
- UI 设计进展
- 组件开发状态
- 设计决策
- Token 使用情况

**酸菜 MEMORY.md:**
- CI/CD流水线状态
- 测试结果
- 运维记录
- 工具配置

**更新频率:**每 2 小时或完成任务时

---

## 📊 灾难恢复流程

### 场景 1: Token 耗尽

**现象:**
```
⚠️ Token 使用量接近限制 (当前：1850/2000)
🚨 保存灾难现场：Token 告警
✅ 灾难现场已保存到：disasters/disaster-20260310-143000-token_warning
```

**灾难目录内容:**
```
disasters/disaster-20260310-143000-token_warning/
├── DISASTER_REPORT.md   # 详细报告
├── jiangrou.log          # 酱肉日志
├── dousha.log            # 豆沙日志
└── suancai.log           # 酸菜日志
```

**恢复步骤:**
1. 查看 `DISASTER_REPORT.md`
2. 检查各 Agent 的 `MEMORY.md`了解经过
3. 补充新的 API Key
4. 更新配置文件

---

### 场景 2: 容器宕机

**现象:**
```
❌ openclaw-instance-1 无法访问：Exited(137)
🚨 保存灾难现场：容器宕机
✅ 灾难现场已保存到：disasters/disaster-20260310-143000-container_down
```

**灾难目录内容:**
```
disasters/disaster-20260310-143000-container_down/
├── DISASTER_REPORT.md      # 详细报告 + 恢复建议
├── jiangrou.log             # 容器最后日志
├── docker-config.json       # Docker 配置
└── network-inspect.json     # 网络状态
```

**恢复步骤:**
1. 阅读 `DISASTER_REPORT.md`中的恢复建议
2. 查看容器日志定位问题
3. 执行重启或重建命令
4. 验证功能恢复

---

### 场景 3: Gateway 离线

**现象:**
```
❌ Gateway 离线：Connection refused
🚨 保存灾难现场：Gateway 离线
✅ 灾难现场已保存到：disasters/disaster-20260310-143000-gateway_offline
```

**恢复步骤:**
1. 查看灾难报告中的 Gateway 日志
2. 检查端口 18789 占用情况
3. 重启 Gateway 服务
4. 验证连接恢复

---

## 🛠️ 日常使用

### 启动监控

**方法 1: 手动启动**
```powershell
cd F:\openclaw\agent\workspace-guantang\scripts
.\simple-monitor.ps1
```

**方法 2: 后台运行**
```powershell
Start-Process powershell -ArgumentList "-File", "F:\openclaw\agent\workspace-guantang\scripts\simple-monitor.ps1"
```

**方法 3: 开机自启**
创建计划任务，每 5 分钟执行一次

---

### 查看监控日志

**实时日志:**
```powershell
Get-Content F:\openclaw\agent\workspace-guantang\disasters\monitor-log.txt -Wait -Tail 50
```

**灾难报告:**
```powershell
dir F:\openclaw\agent\workspace-guantang\disasters\disaster-* | Sort-Object LastWriteTime -Descending | Select-Object -First 5
```

---

### 查看 Agent Memory

**快速浏览所有 Agent 状态:**
```powershell
# 酱肉
Get-Content F:\openclaw\agent\workspace-jiangrou\MEMORY.md | Select-String "当前任务|最后同步"

# 豆沙
Get-Content F:\openclaw\agent\workspace-dousha\MEMORY.md | Select-String "当前任务|最后同步"

# 酸菜
Get-Content F:\openclaw\agent\workspace-suancai\MEMORY.md | Select-String"当前任务|最后同步"
```

---

## 📈 最佳实践

### 1. 定期检查

**每日检查清单:**
- [ ] 查看最新的 monitor-log.txt
- [ ] 检查是否有新的 disaster 目录
- [ ] 浏览各 Agent MEMORY.md

**每周检查清单:**
- [ ] 清理旧的 disaster 目录 (保留最近 7 天)
- [ ] 审查 Token 使用趋势
- [ ] 优化监控脚本

---

### 2. 灾难预防

**Token 管理:**
- 监控显示接近 1800 次时立即补充
- 避免短时间内大量调用
- 实现请求节流

**容器健康:**
- 定期检查 Docker 资源使用
- 及时清理无用镜像和容器
- 保持 Docker 桌面更新

**Gateway 稳定:**
- 避免频繁重启
- 监控端口占用
- 定期备份配置

---

### 3. 故障排查技巧

**第一步:** 查看最新灾难报告
```powershell
$latest = dir F:\openclaw\agent\workspace-guantang\disasters\disaster-* | Sort-Object LastWriteTime -Descending | Select-Object -First 1
code $latest.FullName\DISASTER_REPORT.md
```

**第二步:** 查看相关 Agent Memory
```powershell
code F:\openclaw\agent\workspace-jiangrou\MEMORY.md
```

**第三步:** 分析日志
```powershell
Get-Content $latest.FullName\*.log | Select-String"ERROR|Exception" | Select-Object -First 20
```

---

## 🔗 相关文件

- [监控脚本](file://f:\openclaw\agent\workspace-guantang\scripts\simple-monitor.ps1)
- [酱肉 Memory](file://f:\openclaw\agent\workspace-jiangrou\MEMORY.md)
- [豆沙 Memory](file://f:\openclaw\agent\workspace-dousha\MEMORY.md)
- [酸菜 Memory](file://f:\openclaw\agent\workspace-suancai\MEMORY.md)
- [错误监控文档](file://f:\openclaw\agent\workspace-guantang\specs\03-technical-specs\agent-error-monitoring.md)

---

## 💡 核心理念

✅ **零成本** - 不需要短信、邮件等付费服务  
✅ **可操作性** - PowerShell 脚本一键执行  
✅ **灾难保护** - 自动保存所有现场信息  
✅ **透明可查** - 所有记录在 workspace 内可查  
✅ **简单实用** - 避免复杂架构，专注解决问题

---

**状态:** ✅ 简化版完成  
**更新日期:** 2026-03-10  
**维护者:**灌汤 (PM)
