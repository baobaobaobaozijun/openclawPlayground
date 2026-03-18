# 任务分配：单元测试框架搭建

**任务 ID:** TASK-017  
**分配时间:** 2026-03-18 09:00  
**负责人:** 酱肉 (Jiangrou) 🍖  
**优先级:** 🔴 高  
**截止时间:** 2026-03-18 18:00 (9 小时)

---

## 📋 任务描述

搭建后端单元测试框架，确保代码质量和可测试性

---

## 🎯 任务目标

### 技术要求
1. **测试框架:** JUnit 5 (Jupiter)
2. **Mock 框架:** Mockito
3. **覆盖率工具:** JaCoCo
4. **目标覆盖率:** > 80%

### 交付内容
- [ ] `pom.xml` 添加测试依赖
- [ ] 配置 Maven Surefire 插件
- [ ] 配置 JaCoCo 插件
- [ ] 编写 ArticleService 测试用例
- [ ] 编写 UserService 测试用例
- [ ] 运行测试并生成覆盖率报告

---

## 📐 技术细节

### 依赖配置 (pom.xml)
```xml
<dependencies>
    <!-- JUnit 5 -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Mockito -->
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-junit-jupiter</artifactId>
        <version>5.5.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- AssertJ (可选，更好的断言) -->
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- Maven Surefire Plugin -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.1.2</version>
            <configuration>
                <includes>
                    <include>**/*Test.java</include>
                    <include>**/*Tests.java</include>
                </includes>
            </configuration>
        </plugin>
        
        <!-- JaCoCo Plugin -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.11</version>
            <executions>
                <execution>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 测试用例示例
```java
@SpringBootTest
class ArticleServiceTest {
    
    @Autowired
    private ArticleService articleService;
    
    @MockBean
    private ArticleRepository articleRepository;
    
    @Test
    @DisplayName("创建文章 - 成功")
    void createArticle_Success() {
        // Given
        Article article = new Article();
        article.setTitle("测试文章");
        article.setContent("测试内容");
        
        when(articleRepository.save(any())).thenReturn(article);
        
        // When
        Article saved = articleService.createArticle(article);
        
        // Then
        assertNotNull(saved.getId());
        assertEquals("测试文章", saved.getTitle());
        verify(articleRepository, times(1)).save(any());
    }
}
```

---

## ✅ 验收标准

1. **依赖配置:** pom.xml 包含所有测试依赖
2. **插件配置:** Surefire 和 JaCoCo 插件配置正确
3. **测试用例:** 至少 2 个 Service 层的完整测试
4. **测试通过:** `mvn test` 全部通过
5. **覆盖率报告:** `mvn jacoco:report` 生成报告，覆盖率>80%
6. **工作日志:** 按标准模板记录

---

## 📝 工作日志要求

**必须记录到:** `F:\openclaw\agent\workinglog\jiangrou\`

**文件名格式:** `YYYYMMDD-HHMMSS-jiangrou-TASK-017-单元测试框架搭建.md`

**日志模板:**
```markdown
## 修改信息
- **修改人:** 酱肉
- **修改时间:** 2026-03-18 HH:mm:ss
- **任务类型:** code

## 任务内容
TASK-017: 单元测试框架搭建

## 修改的文件
- `pom.xml` - 添加测试依赖
- `src/test/java/.../ArticleServiceTest.java` - 新增测试用例

## 关联通知
- [x] 已通知 PM 任务进度
- [ ] 已推送到 GitHub
```

---

## 🔗 相关文档

- [站会纪要](../../doc/meetings/daily-standup-20260318-0900.md)
- [技术规范](../../workspace-jiangrou/TECHNICAL-DOCS.md)
- [工作日志规范](../../doc/guides/工作日志规范.md)

---

**确认收到请回复:**
1. 已阅读任务详情
2. 已知晓技术要求
3. 预计完成时间

---
灌汤 | PM 🍲
