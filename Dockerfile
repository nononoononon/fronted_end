# 使用 Amazon Linux 2 作为基础镜像
FROM amazonlinux:2 as build

# 安装 Node.js、NPM、Git 和其他必要的软件包
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash - && \
    yum install -y nodejs git

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制本地代码到容器中
COPY . .

# 构建 React 应用
RUN npm run build

# 使用 Nginx 作为服务器
FROM nginx:1.19.0

# 将构建的 React 应用从构建阶段复制到 Nginx 文件夹
COPY --from=build /app/build /usr/share/nginx/html

# 暴露端口 80
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
