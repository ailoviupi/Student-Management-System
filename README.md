# 学生管理系统

<p align="center">
  <img src="https://img.shields.io/badge/Vue-3.4+-green.svg" alt="Vue">
  <img src="https://img.shields.io/badge/Spring%20Boot-2.7+-blue.svg" alt="Spring Boot">
  <img src="https://img.shields.io/badge/Element--Plus-2.5+-blue.svg" alt="Element Plus">
  <img src="https://img.shields.io/badge/MySQL-8.0+-orange.svg" alt="MySQL">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</p>

一个基于 Vue3 + Spring Boot 的现代化学生管理系统，支持响应式设计，可在 PC 和移动端流畅使用。

## ✨ 功能特性

### 用户角色
- 👨‍💼 **管理员**: 系统管理、用户管理、数据查看
- 👨‍🏫 **教师**: 学生管理、成绩录入、考勤管理
- 👨‍🎓 **学生**: 查看课程、成绩查询、考勤记录

### 核心功能
- 📊 **数据可视化**: 使用 ECharts 展示统计数据和图表
- 📱 **响应式设计**: 完美适配 PC、平板和手机
- 🔐 **JWT 认证**: 安全的用户认证和权限控制
- 📄 **Excel 导出**: 支持成绩等数据导出
- 🎨 **现代化 UI**: 使用 Element Plus 组件库

## 🛠️ 技术栈

### 前端
- **Vue 3.4+** - 渐进式 JavaScript 框架
- **Vue Router 4** - 官方路由管理器
- **Element Plus** - 桌面端组件库
- **ECharts** - 数据可视化图表库
- **Axios** - HTTP 客户端
- **Vite** - 下一代前端构建工具

### 后端
- **Spring Boot 2.7+** - 快速开发框架
- **Spring Security** - 安全框架
- **MyBatis** - ORM 框架
- **MySQL 8.0+** - 关系型数据库
- **JWT** - JSON Web Token 认证
- **PageHelper** - 分页插件
- **EasyExcel** - Excel 处理工具

## 📁 项目结构

```
student-management/
├── frontend/                 # 前端项目
│   ├── src/
│   │   ├── api/             # API 接口
│   │   ├── assets/          # 静态资源
│   │   ├── components/      # 公共组件
│   │   ├── router/          # 路由配置
│   │   ├── views/           # 页面视图
│   │   │   ├── student/     # 学生端页面
│   │   │   └── ...          # 管理端页面
│   │   ├── App.vue
│   │   └── main.js
│   ├── package.json
│   └── vite.config.js
│
├── backend/                  # 后端项目
│   ├── src/main/java/
│   │   └── com/example/student/
│   │       ├── config/      # 配置类
│   │       ├── controller/  # 控制器
│   │       ├── service/     # 业务逻辑
│   │       ├── mapper/      # 数据访问
│   │       ├── entity/      # 实体类
│   │       └── dto/         # 数据传输对象
│   ├── src/main/resources/
│   │   ├── application.yml  # 配置文件
│   │   └── mapper/          # MyBatis XML
│   └── pom.xml
│
└── README.md
```

## 🚀 快速开始

### 环境要求
- JDK 1.8+
- Node.js 16+
- MySQL 8.0+
- Maven 3.6+

### 1. 克隆项目

```bash
git clone https://github.com/ailoviupi/Student-Management-System.git
cd Student-Management-System
```

### 2. 数据库配置

创建 MySQL 数据库并执行初始化脚本：

```sql
CREATE DATABASE student_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

修改后端配置文件 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/student_db?useUnicode=true&characterEncoding=utf-8
    username: your_username
    password: your_password
```

### 3. 启动后端

```bash
cd backend
mvn spring-boot:run
```

后端服务默认运行在 http://localhost:8081

### 4. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端服务默认运行在 http://localhost:3000

### 5. 访问系统

打开浏览器访问 http://localhost:3000

**默认账号密码：**
- 管理员: `admin` / `admin123`
- 教师: `teacher1` / `teacher123`

## 📱 响应式适配

系统完美支持多种设备：

| 设备 | 宽度 | 适配说明 |
|------|------|----------|
| 桌面端 | > 1200px | 完整侧边栏，多列布局 |
| 平板 | 768px - 1200px | 折叠侧边栏，双列布局 |
| 手机 | < 768px | 抽屉式菜单，单列布局 |

## 🔧 配置说明

### 后端配置 (application.yml)

```yaml
server:
  port: 8081  # 服务端口

spring:
  datasource:
    url: jdbc:mysql://localhost:3306/student_db
    username: root
    password: root

jwt:
  secret: your-secret-key  # JWT 密钥
  expiration: 86400000     # Token 过期时间（毫秒）
```

### 前端配置

在 `frontend/src/api/request.js` 中配置后端 API 地址：

```javascript
const baseURL = 'http://localhost:8081/api'
```

## 📸 界面预览

### 登录页面
- 现代化的渐变背景设计
- 支持快速体验账号填充

### 数据概览
- 统计卡片展示核心数据
- 多种图表可视化展示

### 学生管理
- 完整的增删改查功能
- 支持多条件搜索筛选

### 移动端适配
- 侧边栏抽屉式菜单
- 表格横向滚动支持
- 表单自适应布局

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 开源协议

本项目基于 [MIT](LICENSE) 协议开源。

## 🙏 致谢

- [Vue.js](https://vuejs.org/)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Element Plus](https://element-plus.org/)
- [ECharts](https://echarts.apache.org/)

---

<p align="center">
  如果这个项目对你有帮助，欢迎 ⭐ Star 支持！
</p>
