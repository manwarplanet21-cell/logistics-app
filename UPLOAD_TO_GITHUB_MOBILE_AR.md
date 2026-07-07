# رفع المشروع إلى GitHub من الهاتف

## مهم جدًا
لا ترفع ملف ZIP نفسه. يجب رفع محتويات المجلد بعد فك الضغط.

لكن واجهة GitHub من الهاتف غالبًا لا ترفع المجلدات كاملة، لذلك لديك خياران:

## الخيار A: من كمبيوتر
1. فك الضغط عن `planet_logistics_app_full.zip`.
2. افتح المستودع في GitHub.
3. اختر Add file ثم Upload files.
4. اسحب كل محتويات المجلد دفعة واحدة.
5. اضغط Commit changes.

## الخيار B: من الهاتف باستخدام Termux
1. ثبت تطبيق Termux.
2. نفذ الأوامر التالية بعد فك ضغط المشروع في مجلد Downloads:

```bash
pkg update -y
pkg install git -y
cd /sdcard/Download/planet_logistics_app
git init
git add .
git commit -m "Initial logistics app"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/logistics-app.git
git push -u origin main
```

عند طلب كلمة المرور، GitHub يحتاج Personal Access Token وليس كلمة مرور الحساب.

## استخراج APK بعد رفع المشروع
1. افتح المستودع في GitHub.
2. ادخل إلى Actions.
3. اختر Build Android APK.
4. اضغط Run workflow.
5. بعد انتهاء البناء، حمل Artifact باسم `planet-logistics-debug-apk`.
