# 🚀 Dockerized Multi-Project Deployment Environment with Caddy Proxy

ระบบโครงสร้างพื้นฐานสำหรับรันหลายเว็บแอปในเครื่องเดียว ด้วย Docker Compose + Caddy Proxy  
รองรับการแยกแต่ละโปรเจกต์เป็นอิสระ และจัดการโดเมนอัตโนมัติด้วย label-based routing

---

## 📦 Stack ที่รองรับ

- ✅ **Frontend / Backoffice**: Vue.js (เสิร์ฟผ่าน Nginx)
- ✅ **API**: NestJS (หรือ NodeJS backend อื่น ๆ)
- ✅ **Database**: PostgreSQL
- ✅ **Proxy & SSL**: Caddy Docker Proxy (auto HTTPS ด้วย Let's Encrypt)

---

## 📁 โครงสร้างโปรเจกต์

```plaintext
multi-project-deployment-infra/
├── _project-template/            # เทมเพลตสำหรับสร้างโปรเจกต์ใหม่
│   ├── docker-compose.yml
│   ├── frontend/ (Vue.js + Nginx)
│   ├── backoffice/ (Vue.js + Nginx)
│   └── api/ (NestJS)
│
├── projects/                     # โฟลเดอร์ที่ใช้เก็บโปรเจกต์จริง
│   └── my-project/              # ตัวอย่างโปรเจกต์ (คัดลอกจาก template)
│       └── docker-compose.yml
│
├── reverse-proxy/               # Caddy Docker Proxy สำหรับ routing
│   └── docker-compose.yml
│
├── server-setup.sh              # ติดตั้ง Docker + Compose บนเซิร์ฟเวอร์
├── docker-start.sh              # เริ่มระบบทั้งหมด
├── docker-stop.sh               # หยุดระบบทั้งหมด
├── docker-restart.sh            # รีสตาร์ทระบบทั้งหมด
└── README.md                    # ไฟล์นี้แหละจ้า
```

---

## 🛠 การติดตั้งเซิร์ฟเวอร์ (ครั้งเดียว)

```bash
./server-setup.sh
```

สิ่งที่ script จะทำให้:
- ติดตั้ง Docker + Compose
- สร้าง docker network สำหรับ proxy
- เปิด Firewall (UFW)
- เพิ่ม user เข้ากลุ่ม docker
- แนะนำ reboot หลังติดตั้ง

---

## 🚀 การเริ่มต้นระบบ

1. สร้างโปรเจกต์ใหม่จาก template:

```bash
cp -r _project-template projects/my-project
```

2. แก้ไข `.env` ภายใน `projects/my-project/` ให้กำหนดชื่อโปรเจกต์, พอร์ต, โดเมนให้เรียบร้อย

3. เริ่มระบบทั้งหมด:

```bash
./docker-start.sh
```

> หรือสั่งรันเฉพาะบางโปรเจกต์:
```bash
./docker-start.sh --only=my-project
```

---

## 🌐 การใช้งาน Caddy Proxy

Caddy จะ map โดเมนโดยอัตโนมัติ จาก label ที่กำหนดใน `docker-compose.yml`  
รองรับทั้ง HTTP → HTTPS, reverse proxy และ wildcard domain

ตัวอย่าง label:
```yaml
labels:
  caddy: api.myproject.com
  caddy.reverse_proxy: "{{upstreams 3000}}"
  caddy.redirects: "http://{http.request.hostport} https://{http.request.hostport}"
```

---

## 🧪 Health Check

ระบบมี `healthcheck` ครบ:
- PostgreSQL → `pg_isready`
- API → `curl` เช็คพอร์ตภายใน
- Caddy Proxy → `wget` localhost

---

## 📌 Tips

- ใช้ `.env` เพื่อเปลี่ยนชื่อโดเมนและพอร์ตได้ง่าย
- เปลี่ยนชื่อ container โดยใช้ `${PROJECT_NAME}-xxx` เพื่อไม่ชนกัน
- เพิ่ม `volume` แยกข้อมูลแต่ละโปรเจกต์
- รองรับ SSL ฟรีอัตโนมัติด้วย Let's Encrypt

---

## 🧠 แนะนำเพิ่มเติม

- ใช้ `git clone` repo นี้เป็น infra กลาง แล้ว copy `_project-template` ไปสร้างโปรเจกต์ใหม่
- ตั้ง DNS เป็น `*.yourdomain.com` → ชี้มายังเซิร์ฟเวอร์นี้
