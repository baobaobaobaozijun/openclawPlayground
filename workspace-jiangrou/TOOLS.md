<!-- Last Modified: 2026-03-12 -->

# TOOLS.md - 酱肉的工具箱

**角色:** 后端工程师  
**技术栈:** Java 21 + Spring Boot 3.2+  
**运行模式:** 本地化运行 (非 Docker)  
**更新日期:** 2026-03-12

---

## 📡 Gateway 通信配置 ⭐⭐⭐

### 对话式通信

**通信方式:** 直接通过 Gateway 对话界面

**Gateway 连接:**
- **URL:** `http://localhost:18790`
- **端口:** 18790
- **模式:** local (loopback)
- **认证:** token
- **Token:** `4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39`

**配置文件:** `C:\Users\Administrator\.openclaw\openclaw.json`

**工作空间:** `F:\openclaw\agent\workspace-jiangrou`

**说明:**
- ✅ 不再使用文件系统的 inbox/outbox 机制
- ✅ 所有沟通直接通过 Gateway 对话界面进行
- ✅ 任务分配、进度报告、问题讨论都在对话中完成
- ✅ 更自然、更可靠、更高效

---

---

## 📚 统一知识库 ⭐⭐⭐【新增】

**知识库路径:** `F:\openclaw\agent\doc`

**知识库索引:** [../../doc/README.md](../../doc/README.md)

**常用文档:**
- [系统架构](../../doc/specs/01-architecture/system-architecture.md)
- [API 设计](../../doc/specs/03-technical-specs/api-design.md)
- [博客系统需求](../../doc/specs/02-business-specs/blog-system-requirements.md)
- [数据库设计](../../doc/specs/02-business-specs/blog-system-database-design.md)
- [错误监控](../../doc/specs/03-technical-specs/agent-error-monitoring.md)

**知识库分类:**
```
doc/
├── specs/           # 规范文档
│   ├── 01-architecture/    # 架构设计
│   ├── 02-business-specs/  # 业务需求
│   ├── 03-technical-specs/ # 技术规范
│   └── 04-processes/       # 流程规范
├── guides/          # 使用指南
└── knowledge/       # 知识库
```

---

## 📖 参考资料

**架构说明:** [ARCHITECTURE.md](../ARCHITECTURE.md)
**轻量级架构:** [doc/ARCHITECTURE-LITE.md](../../doc/ARCHITECTURE-LITE.md)

---

**最后更新:** 2026-03-10  
**维护者:**酱肉 (Jiangrou)
