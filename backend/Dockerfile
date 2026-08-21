# 后端构建镜像：Maven 构建 + JRE 运行（用于 Render / 任意 Docker 平台免费部署）
# 注意：不复制 backend/settings.xml（其指向本地 d:/maven_repo，仅本机可用）

# ---- 构建阶段 ----
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
# 先拷 pom 单独下载依赖，利用 Docker 层缓存加速重复构建
COPY pom.xml .
RUN mvn -B -q dependency:go-offline || true
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ---- 运行阶段 ----
FROM eclipse-temurin:8-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8083
# PORT 是 Render 注入的端口（默认 10000），本地无 PORT 时回退 8083
# -Xmx256m：控制堆内存，适配 Render 免费层 512MB 限制
CMD ["sh", "-c", "java -Xmx256m -Xms64m -XX:MaxMetaspaceSize=128m -jar app.jar --server.port=${PORT:-8083}"]
