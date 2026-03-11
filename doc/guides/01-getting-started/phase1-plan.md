<!-- Last Modified: 2026-03-12 -->

# 包子铺博客系统 - 第一阶段实施计划

**文档类型:** 项目实施计划  
**版本:** v1.0  
**创建日期:** 2026-03-12  
**负责人:** 灌汤 (PM)  
**阶段:** 第一阶段 (Demo 版本)

---

## 📋 第一阶段目标

**完成时间:** 2026-03-14 (3 天)

**核心交付物:**
1. ✅ 前端页面搭建完成 (首页、文章列表、文章详情)
2. ✅ 文章模块后端 API 完成 (CRUD)
3. ✅ Demo 级别页面可访问
4. ✅ 服务器环境准备就绪

**验收标准:**
- 可以在浏览器访问首页看到文章列表
- 可以点击查看文章详情
- 管理员可以登录后台创建/编辑文章
- 服务器 8.137.175.240 已配置完成

---

## 👥 团队分工

### 灌汤 (PM) 🍲
**职责:** 项目管理、需求澄清、进度跟踪、文档维护

### 酱肉 (后端) 🍖
**职责:** Spring Boot 后端开发、文章 API、数据库设计

### 豆沙 (前端) 🍡
**职责:** Vue 3 前端开发、页面组件、UI 设计

### 酸菜 (运维) 🥬
**职责:** 服务器配置、环境搭建、Nginx 部署

---

## 📅 详细任务分解

### Day 1 (2026-03-12) - 环境准备 + 基础架构

#### 酸菜 (运维) 🥬

**任务 1.1:** 服务器连接和状态检查
```bash
# 1. SSH 连接服务器
ssh root@8.137.175.240
# 密码：Qaz123!@#

# 2. 检查服务器配置
free -h          # 内存
df -h            # 磁盘
cat /etc/os-release  # 系统版本

# 3. 检查已安装软件
java -version    # Java
mysql --version  # MySQL
nginx -v         # Nginx
```

**任务 1.2:** 安装必要软件 (如未安装)
```bash
# 1. 更新包管理器
apt update && apt upgrade -y

# 2. 安装 JDK 21
apt install openjdk-21-jdk -y

# 3. 安装 MySQL 8.0
apt install mysql-server -y

# 4. 安装 Nginx
apt install nginx -y

# 5. 安装 Git
apt install git -y
```

**任务 1.3:** MySQL 数据库初始化
```sql
-- 1. 登录 MySQL
mysql -u root -p

-- 2. 创建数据库
CREATE DATABASE blog DEFAULT CHARACTER SET utf8mb4;

-- 3. 创建用户
CREATE USER 'blog_user'@'localhost' IDENTIFIED BY 'Blog@2026';
GRANT ALL PRIVILEGES ON blog.* TO 'blog_user'@'localhost';
FLUSH PRIVILEGES;

-- 4. 创建基础表结构
USE blog;

-- 用户表
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(11),
    role VARCHAR(20) DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 文章表
CREATE TABLE articles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    summary VARCHAR(500),
    author_id BIGINT,
    status VARCHAR(20) DEFAULT 'DRAFT',
    access_level INT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id)
);

-- 分类表
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(200),
    parent_id BIGINT,
    FOREIGN KEY (parent_id) REFERENCES categories(id)
);

-- 标签表
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL
);

-- 文章 - 标签关联表
CREATE TABLE article_tags (
    article_id BIGINT,
    tag_id BIGINT,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

-- 5. 插入测试数据
INSERT INTO users (username, password, email, role) VALUES 
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKTm8I/vsZC5O1P2Q3R4S5T6U7V8', 'admin@blog.com', 'ADMIN');

INSERT INTO categories (name, slug, description) VALUES 
('技术文章', 'tech', '技术相关'),
('生活随笔', 'life', '生活感悟');

INSERT INTO tags (name, slug) VALUES 
('Java', 'java'),
('Vue', 'vue'),
('Spring Boot', 'spring-boot');
```

**任务 1.4:** 创建部署目录
```bash
# 1. 创建应用目录
mkdir -p /opt/blog/{backend,frontend,logs}
chown -R root:root /opt/blog

# 2. 创建 Nginx 配置目录
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# 3. 创建日志目录
mkdir -p /var/log/blog
chown www-data:www-data /var/log/blog
```

**交付物:**
- [ ] 服务器状态报告
- [ ] 软件安装清单
- [ ] 数据库初始化完成
- [ ] 部署目录创建完成

---

#### 酱肉 (后端) 🍖

**任务 1.5:** 初始化 Spring Boot 项目
```bash
# 1. 进入后端目录
cd F:\openclaw\code\backend

# 2. 创建 Maven 项目结构
mkdir -p src/main/java/com/blog/{controller,service,repository,model,dto,config,exception}
mkdir -p src/main/resources
mkdir -p src/test/java/com/blog

# 3. 创建 pom.xml
```

**pom.xml 核心依赖:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>
    
    <groupId>com.blog</groupId>
    <artifactId>blog-backend</artifactId>
    <version>1.0.0</version>
    <name>Blog Backend</name>
    
    <properties>
        <java.version>21</java.version>
    </properties>
    
    <dependencies>
        <!-- Spring Boot Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        
        <!-- Spring Security -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-security</artifactId>
        </dependency>
        
        <!-- MyBatis-Plus -->
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus-boot-starter</artifactId>
            <version>3.5.5</version>
        </dependency>
        
        <!-- MySQL Driver -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <scope>runtime</scope>
        </dependency>
        
        <!-- JWT -->
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-api</artifactId>
            <version>0.12.3</version>
        </dependency>
        <dependency>
            <groupId>io.jsonwebtoken</groupId>
            <artifactId>jjwt-impl</artifactId>
            <version>0.12.3</version>
            <scope>runtime</scope>
        </dependency>
        
        <!-- Caffeine Cache -->
        <dependency>
            <groupId>com.github.ben-manes.caffeine</groupId>
            <artifactId>caffeine</artifactId>
        </dependency>
        
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        
        <!-- Test -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

**任务 1.6:** 创建 application.yml
```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/blog?useSSL=false&serverTimezone=UTC&characterEncoding=utf8
    username: blog_user
    password: Blog@2026
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 10
      minimum-idle: 5
      connection-timeout: 30000

  cache:
    caffeine:
      spec: maximumSize=1000,expireAfterWrite=10m

mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      id-type: auto
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0

jwt:
  secret: your-secret-key-here-change-in-production
  expiration: 7200000  # 2 hours

logging:
  level:
    root: WARN
    com.blog: INFO
  file:
    name: /var/log/blog/application.log
```

**任务 1.7:** 创建实体类 (Model)
```java
// Article.java
package com.blog.model;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("articles")
public class Article {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String title;
    
    private String content;
    
    private String summary;
    
    private Long authorId;
    
    private String status;  // DRAFT, PUBLISHED
    
    private Integer accessLevel;  // 0=public, 1=login, 2=vip
    
    private Integer viewCount;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
```

**交付物:**
- [ ] Spring Boot 项目结构创建
- [ ] pom.xml 配置完成
- [ ] application.yml 配置完成
- [ ] Article 实体类创建

---

#### 豆沙 (前端) 🍡

**任务 1.8:** 初始化 Vue 3 项目
```bash
# 1. 进入前端目录
cd F:\openclaw\code\frontend

# 2. 使用 Vite 创建项目
npm create vite@latest . -- --template vue-ts

# 3. 安装依赖
npm install

# 4. 安装额外依赖
npm install vue-router pinia axios element-plus @element-plus/icons-vue
npm install -D tailwindcss postcss autoprefixer

# 5. 初始化 Tailwind
npx tailwindcss init -p
```

**任务 1.9:** 配置 Vite 和 Tailwind

**vite.config.ts:**
```typescript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src')
    }
  },
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
})
```

**tailwind.config.js:**
```javascript
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

**任务 1.10:** 创建基础目录结构
```bash
mkdir -p src/{components/{common,article},views,stores,router,api,assets,utils}
```

**任务 1.11:** 创建路由配置
```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/article/:id',
    name: 'ArticleDetail',
    component: () => import('@/views/ArticleDetail.vue')
  },
  {
    path: '/category/:slug',
    name: 'Category',
    component: () => import('@/views/Category.vue')
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/admin/Dashboard.vue'),
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

**交付物:**
- [ ] Vue 3 项目初始化
- [ ] Vite 配置完成
- [ ] Tailwind CSS 配置完成
- [ ] 路由配置完成

---

### Day 2 (2026-03-13) - 核心功能开发

#### 酱肉 (后端) 🍖

**任务 2.1:** 创建 Repository 层
```java
// ArticleRepository.java
package com.blog.repository;

import com.blog.model.Article;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface ArticleRepository extends BaseMapper<Article> {
    List<Article> selectPublishedArticles();
    Article selectByIdWithAuthor(Long id);
}
```

**任务 2.2:** 创建 Service 层
```java
// ArticleService.java
package com.blog.service;

import com.blog.model.Article;
import com.blog.dto.ArticleDTO;
import java.util.List;

public interface ArticleService {
    List<ArticleDTO> getPublishedArticles(int page, int size);
    ArticleDTO getArticleById(Long id);
    ArticleDTO createArticle(ArticleDTO dto);
    ArticleDTO updateArticle(Long id, ArticleDTO dto);
    void deleteArticle(Long id);
}
```

**任务 2.3:** 创建 Controller 层
```java
// ArticleController.java
package com.blog.controller;

import com.blog.service.ArticleService;
import com.blog.dto.ArticleDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/articles")
@CrossOrigin(origins = "*")
public class ArticleController {
    
    @Autowired
    private ArticleService articleService;
    
    @GetMapping
    public List<ArticleDTO> getArticles(
        @RequestParam(defaultValue = "1") int page,
        @RequestParam(defaultValue = "10") int size
    ) {
        return articleService.getPublishedArticles(page, size);
    }
    
    @GetMapping("/{id}")
    public ArticleDTO getArticle(@PathVariable Long id) {
        return articleService.getArticleById(id);
    }
    
    @PostMapping
    public ArticleDTO create(@RequestBody ArticleDTO dto) {
        return articleService.createArticle(dto);
    }
    
    @PutMapping("/{id}")
    public ArticleDTO update(@PathVariable Long id, @RequestBody ArticleDTO dto) {
        return articleService.updateArticle(id, dto);
    }
    
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        articleService.deleteArticle(id);
    }
}
```

**任务 2.4:** 创建启动类
```java
// BlogApplication.java
package com.blog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BlogApplication {
    public static void main(String[] args) {
        SpringApplication.run(BlogApplication.class, args);
    }
}
```

**交付物:**
- [ ] Repository 层完成
- [ ] Service 层完成
- [ ] Controller 层完成
- [ ] 文章 API 可测试

---

#### 豆沙 (前端) 🍡

**任务 2.5:** 创建 API 客户端
```typescript
// src/api/article.ts
import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000
})

export interface Article {
  id: number
  title: string
  content: string
  summary: string
  authorId: number
  status: string
  accessLevel: number
  viewCount: number
  createdAt: string
  updatedAt: string
}

export const articleApi = {
  getList: (page = 1, size = 10) => 
    api.get<Article[]>(`/articles?page=${page}&size=${size}`),
  
  getById: (id: number) => 
    api.get<Article>(`/articles/${id}`),
  
  create: (data: Partial<Article>) => 
    api.post<Article>('/articles', data),
  
  update: (id: number, data: Partial<Article>) => 
    api.put<Article>(`/articles/${id}`, data),
  
  delete: (id: number) => 
    api.delete(`/articles/${id}`)
}
```

**任务 2.6:** 创建首页组件
```vue
<!-- src/views/Home.vue -->
<template>
  <div class="home">
    <Header />
    
    <main class="container">
      <div class="content">
        <ArticleList />
      </div>
      
      <aside class="sidebar">
        <Sidebar />
      </aside>
    </main>
    
    <Footer />
  </div>
</template>

<script setup lang="ts">
import Header from '@/components/common/Header.vue'
import Footer from '@/components/common/Footer.vue'
import ArticleList from '@/components/article/ArticleList.vue'
import Sidebar from '@/components/common/Sidebar.vue'
</script>

<style scoped>
.home {
  min-height: 100vh;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 30px;
}
</style>
```

**任务 2.7:** 创建文章列表组件
```vue
<!-- src/components/article/ArticleList.vue -->
<template>
  <div class="article-list">
    <h2 class="title">最新文章</h2>
    
    <div v-if="loading" class="loading">加载中...</div>
    
    <div v-else-if="error" class="error">{{ error }}</div>
    
    <div v-else>
      <ArticleCard 
        v-for="article in articles" 
        :key="article.id"
        :article="article"
      />
      
      <Pagination 
        :current="currentPage"
        :total="total"
        @change="handlePageChange"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { articleApi, type Article } from '@/api/article'
import ArticleCard from './ArticleCard.vue'
import Pagination from '../common/Pagination.vue'

const articles = ref<Article[]>([])
const loading = ref(true)
const error = ref('')
const currentPage = ref(1)
const total = ref(0)

const loadArticles = async () => {
  loading.value = true
  try {
    const response = await articleApi.getList(currentPage.value, 10)
    articles.value = response.data
    total.value = response.data.length
  } catch (e) {
    error.value = '加载文章失败'
  } finally {
    loading.value = false
  }
}

const handlePageChange = (page: number) => {
  currentPage.value = page
  loadArticles()
}

onMounted(() => {
  loadArticles()
})
</script>
```

**交付物:**
- [ ] API 客户端完成
- [ ] 首页组件完成
- [ ] 文章列表组件完成
- [ ] 可以展示文章列表

---

#### 酸菜 (运维) 🥬

**任务 2.8:** 配置 Nginx
```nginx
# /etc/nginx/sites-available/blog
server {
    listen 80;
    server_name 8.137.175.240;
    
    # 前端静态文件
    location / {
        root /var/www/blog-frontend;
        try_files $uri $uri/ /index.html;
    }
    
    # 后端 API 代理
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # 日志
    access_log /var/log/blog/access.log;
    error_log /var/log/blog/error.log;
}
```

**任务 2.9:** 启用 Nginx 配置
```bash
# 1. 创建软链接
ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/

# 2. 测试配置
nginx -t

# 3. 重载 Nginx
systemctl reload nginx
```

**任务 2.10:** 配置 systemd 服务
```ini
# /etc/systemd/system/blog-backend.service
[Unit]
Description=Blog Backend Service
After=network.target mysql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/blog/backend
ExecStart=/usr/bin/java -Xms600m -Xmx600m -XX:+UseG1GC -jar blog-backend.jar
Restart=on-failure
RestartSec=10

# 日志
StandardOutput=journal
StandardError=journal
SyslogIdentifier=blog-backend

[Install]
WantedBy=multi-user.target
```

**交付物:**
- [ ] Nginx 配置完成
- [ ] systemd 服务配置完成
- [ ] 服务可启动

---

### Day 3 (2026-03-14) - 集成测试 + Demo 发布

#### 酱肉 (后端) 🍖

**任务 3.1:** 打包 Spring Boot
```bash
cd F:\openclaw\code\backend
mvn clean package -DskipTests
```

**任务 3.2:** 上传 JAR 到服务器
```bash
# 使用 SCP 上传
scp target/blog-backend-1.0.0.jar root@8.137.175.240:/opt/blog/backend/blog-backend.jar
```

**任务 3.3:** 启动后端服务
```bash
# SSH 到服务器
ssh root@8.137.175.240

# 启动服务
systemctl start blog-backend
systemctl enable blog-backend

# 检查状态
systemctl status blog-backend

# 查看日志
journalctl -u blog-backend -f
```

**任务 3.4:** 测试 API
```bash
# 测试文章列表 API
curl http://8.137.175.240/api/articles

# 测试文章详情 API
curl http://8.137.175.240/api/articles/1
```

**交付物:**
- [ ] JAR 包上传完成
- [ ] 后端服务运行正常
- [ ] API 可访问

---

#### 豆沙 (前端) 🍡

**任务 3.5:** 构建前端
```bash
cd F:\openclaw\code\frontend
npm run build
```

**任务 3.6:** 上传前端到服务器
```bash
# 创建目录
ssh root@8.137.175.240 "mkdir -p /var/www/blog-frontend"

# 上传文件
scp -r dist/* root@8.137.175.240:/var/www/blog-frontend/
```

**任务 3.7:** 创建测试页面
```vue
<!-- 添加一些测试数据展示 -->
```

**交付物:**
- [ ] 前端构建完成
- [ ] 文件上传完成
- [ ] 页面可访问

---

#### 酸菜 (运维) 🥬

**任务 3.8:** 配置防火墙
```bash
# 开放 80 端口
ufw allow 80/tcp

# 开放 443 端口 (如果配置 SSL)
ufw allow 443/tcp

# 开放 22 端口 (SSH)
ufw allow 22/tcp

# 启用防火墙
ufw enable
```

**任务 3.9:** 配置监控脚本
```bash
#!/bin/bash
# /opt/blog/scripts/monitor.sh

echo "=== Blog System Monitor ==="
echo "Time: $(date)"
echo ""

# 检查 Nginx
echo "Nginx Status:"
systemctl is-active nginx

# 检查后端
echo "Backend Status:"
systemctl is-active blog-backend

# 检查 MySQL
echo "MySQL Status:"
systemctl is-active mysql

# 检查内存
echo ""
echo "Memory Usage:"
free -h

# 检查磁盘
echo ""
echo "Disk Usage:"
df -h /
```

**任务 3.10:** 最终验证
```bash
# 1. 访问首页
curl http://8.137.175.240/

# 2. 访问 API
curl http://8.137.175.240/api/articles

# 3. 检查所有服务
systemctl status nginx blog-backend mysql
```

**交付物:**
- [ ] 防火墙配置完成
- [ ] 监控脚本就绪
- [ ] 所有服务运行正常

---

## 📊 验收标准

### 功能验收
- [ ] 访问 http://8.137.175.240 可以看到首页
- [ ] 首页显示文章列表
- [ ] 点击文章可以查看详情
- [ ] 管理员可以登录后台
- [ ] 后台可以创建/编辑文章

### 技术验收
- [ ] 后端 API 响应时间 < 500ms
- [ ] 前端页面加载时间 < 3s
- [ ] 服务器内存占用 < 1.5GB
- [ ] 所有服务开机自启动

### 文档验收
- [ ] 部署文档完整
- [ ] API 文档完整
- [ ] 监控脚本可用

---

## 📝 每日站会

### Day 1 站会 (2026-03-12 18:00)
**参会:** 灌汤、酱肉、豆沙、酸菜

**议程:**
1. 酸菜汇报服务器状态
2. 酱肉汇报后端进度
3. 豆沙汇报前端进度
4. 灌汤同步明日计划

### Day 2 站会 (2026-03-13 18:00)
**议程:**
1. 后端 API 联调情况
2. 前端页面集成情况
3. 识别阻塞问题

### Day 3 站会 (2026-03-14 18:00)
**议程:**
1. Demo 验收
2. 问题复盘
3. 第二阶段规划

---

## ⚠️ 风险管理

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| 服务器资源不足 | 中 | 高 | JVM 调优、MySQL 优化 |
| API 联调失败 | 中 | 中 | 提前定义接口文档 |
| 前端样式问题 | 低 | 低 | 使用 Element Plus 组件库 |
| 网络延迟 | 低 | 中 | 本地开发，最后部署 |

---

## 📞 沟通机制

**日常沟通:** Gateway 实时通信

**紧急联系:** 
- 酱肉：`inbox/jiangrou/`
- 豆沙：`inbox/dousha/`
- 酸菜：`inbox/suancai/`

**进度汇报:** 每日 18:00 提交工作日志

---

**计划制定者:** 灌汤 (PM)  
**制定日期:** 2026-03-12  
**版本:** v1.0
