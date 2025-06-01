# ใช้ Node.js 20 เป็น base image (หรือตามที่คุณใช้)
FROM node:20-alpine

# กำหนด working directory
WORKDIR /app

# คัดลอก package.json และ package-lock.json เพื่อติดตั้ง dependencies
COPY package*.json ./

# ติดตั้ง dependencies (prod dependencies เท่านั้น)
RUN npm install --omit=dev

# คัดลอกโค้ดแอปพลิเคชัน
COPY . .

# สร้างโปรเจกต์ NestJS (หากมีขั้นตอน build)
RUN npm run build

# expose พอร์ตที่ NestJS app รันอยู่ (ต้องตรงกับ API_PORT ใน .env)
EXPOSE 3000

# รันแอปพลิเคชัน
CMD ["node", "dist/main"] # หรือ "npm", "run", "start:prod"