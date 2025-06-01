# ใช้ Node.js 20 เป็น base image สำหรับ build stage
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Build Vue.js application
# ตรวจสอบว่าคำสั่ง build ของคุณสร้างไฟล์ static ไปที่ไหน (เช่น dist)
RUN npm run build

# ใช้ Nginx เป็น serve static files
FROM nginx:alpine

# คัดลอกไฟล์ build ที่ได้จาก stage ก่อนหน้าไปยัง Nginx public directory
# ตรวจสอบ path /app/dist ให้ตรงกับ output ของ npm run build ของคุณ
COPY --from=build /app/dist /usr/share/nginx/html

# คัดลอก Nginx custom config (ถ้ามี, ไม่บังคับ)
# COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# expose พอร์ตที่ Nginx จะ serve (ต้องตรงกับ BACKOFFICE_PORT/FRONTEND_PORT ใน .env)
EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]