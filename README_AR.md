# Planet Logistics - Phase 1

هذه هي المرحلة الأولى من التطبيق:

- Flutter Android App
- شاشة عميل لتتبع السائق
- شاشة سائق لإرسال الموقع
- Backend Node.js + Socket.IO
- PostgreSQL/PostGIS لدعم أقرب سائق
- GitHub Actions لبناء APK تلقائيًا

## طريقة الرفع الصحيحة إلى GitHub

ارفع المجلد كاملًا كما هو، وليس الملفات متفرقة فقط.

الهيكل الصحيح داخل المستودع:

```txt
flutter_app/
backend/
README_AR.md
```

## استخراج APK عبر GitHub Actions

1. افتح المستودع في GitHub.
2. افتح تبويب Actions.
3. اختر Build Android APK.
4. اضغط Run workflow.
5. بعد الانتهاء، حمل Artifact باسم planet-logistics-debug-apk.

## ملاحظة مهمة

قبل بناء APK النهائي، عدل قيمة السيرفر:

```txt
http://YOUR_SERVER_IP:3000
```

أو استخدم dart-define في GitHub Actions.
