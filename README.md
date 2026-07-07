# Planet Logistics App

تطبيق لوجستي أولي احترافي مكوّن من:

- Flutter Android App
- Customer tracking screen
- Driver location broadcasting screen
- Node.js Backend
- Socket.IO realtime tracking
- PostgreSQL/PostGIS dispatch support
- GitHub Actions + Codemagic APK build files

## Build APK using GitHub Actions

1. ارفع كل ملفات هذا المجلد إلى GitHub.
2. افتح تبويب Actions.
3. اختر Build Android APK.
4. اضغط Run workflow.
5. بعد انتهاء البناء، حمل Artifact باسم planet-logistics-debug-apk.

## Important

قبل البناء النهائي، استبدل:

`http://YOUR_SERVER_IP:3000`

بعنوان السيرفر الحقيقي.

## Backend

```bash
cd backend
cp .env.example .env
npm install
npm run dev
```

Health endpoint:

```text
http://localhost:3000/health
```
