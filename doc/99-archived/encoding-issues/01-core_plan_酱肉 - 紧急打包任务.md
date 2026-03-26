<!-- Last Modified: 2026-03-23 -->

# 🔴 紧急任务：后端打包

**负责人:** 酱肉 (Jiangrou)  
**优先级:** CRITICAL  
**截止时间:** 2026-03-23 18:00

---

## 任务目标

使用 Maven 打包后端项目，生成可运行的 JAR 文件。

---

## 执行步骤

### 1. 检查项目完整性

```powershell
cd F:\openclaw\code\backend

# 检查 pom.xml 是否存在
Test-Path pom.xml

# 检查源码目录
Get-ChildItem src\main\java\com\openclaw -Recurse -Name | Select-Object -First 20
```

**预期:**
- pom.xml 存在
- 有 Controller/Service/Entity 等目录

### 2. 检查 Maven

```powershell
mvn -version
```

**预期输出:**
```
Apache Maven 3.9.x
Java version: 21.0.x
```

### 3. 清理并编译

```powershell
cd F:\openclaw\code\backend
mvn clean compile
```

**预期:** `BUILD SUCCESS`

### 4. 运行测试（可选，跳过可加速）

```powershell
# 如有测试失败可跳过
mvn test -DskipTests
```

### 5. 打包 JAR

```powershell
cd F:\openclaw\code\backend
mvn package -DskipTests
```

**预期输出:** `BUILD SUCCESS`

**输出文件:**
```
F:\openclaw\code\backend\target\backend-0.0.1-SNAPSHOT.jar
```

### 6. 验证 JAR 可运行

```powershell
cd F:\openclaw\code\backend\target
java -jar backend-0.0.1-SNAPSHOT.jar
```

**预期:**
- Spring Boot 启动
- 监听 8080 端口
- 无报错退出

**按 Ctrl+C 停止**

### 7. 写工作日志

**文件:** `workinglog/jiangrou/20260323-XXXXXX-jiangrou-后端打包.md`

**内容:**
- 执行的命令
- 命令输出（关键部分）
- JAR 文件路径
- 启动验证结果

---

## 可能的问题及解决

| 问题 | 解决 |
|------|------|
| Maven 未安装 | 执行 `choco install maven` 或手动安装 |
| 依赖下载失败 | 检查网络，配置 Maven 镜像 |
| 编译错误 | 检查 Java 版本是否为 21 |
| 端口 8080 被占用 | 修改 application.yml 中的 server.port |

---

## 验收标准

- [ ] JAR 文件存在：`target/backend-0.0.1-SNAPSHOT.jar`
- [ ] JAR 可运行：`java -jar` 能启动 Spring Boot
- [ ] 工作日志已写

---

*灌汤 (PM) | 2026-03-23*
