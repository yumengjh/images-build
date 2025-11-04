# ===========================
# 构建阶段
# ===========================
FROM node:20-alpine AS builder

WORKDIR /app

# 复制依赖文件
COPY package*.json ./

# 安装依赖（包含 devDependencies）
RUN npm ci

# 复制源代码
COPY . .

# 构建 Nest 应用
RUN npm run build

# ===========================
# 运行阶段
# ===========================
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production

# 复制 package.json 以安装生产依赖
COPY package*.json ./

# 仅安装生产依赖
RUN npm ci --omit=dev && npm cache clean --force

# 从构建阶段复制编译结果
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]
