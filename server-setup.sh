#!/bin/bash

echo "🛠 เริ่มต้นติดตั้งระบบพื้นฐานสำหรับ Cloud Server..."

# Update & install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git ufw ca-certificates lsb-release gnupg

# ----------------------------
# ติดตั้ง Docker Engine แบบทางการ
# ----------------------------
echo "🐳 ติดตั้ง Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker on boot
sudo systemctl enable docker

# เพิ่มสิทธิ์ให้ผู้ใช้ปัจจุบันใช้ docker ได้เลย
sudo usermod -aG docker $USER

# ตรวจสอบเวอร์ชัน docker
docker --version
docker compose version

# สร้าง docker network สำหรับ proxy
docker network create proxy

# ----------------------------
# ตั้งค่า UFW Firewall
# ----------------------------
echo "🔥 ตั้งค่า Firewall (UFW)..."
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

echo "✅ ติดตั้งเสร็จสิ้นแล้ว! กรุณา logout และ login ใหม่ หรือ reboot ด้วยคำสั่ง: sudo reboot"
