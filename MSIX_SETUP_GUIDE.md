# دليل إعداد حزمة MSIX لتطبيق مساعد كفو

## ما هي MSIX؟
MSIX هي صيغة حديثة لتوزيع تطبيقات Windows:
- ✅ تركيب وإلغاء تركيب نظيف
- ✅ تحديثات تلقائية
- ✅ عزل أفضل للتطبيق
- ✅ تقليل رسائل التحذير الأمنية

---

## 📦 خطوات إنشاء حزمة MSIX:

### 1. إضافة حزمة MSIX إلى المشروع:

```bash
flutter pub add msix
```

### 2. تكوين MSIX في `pubspec.yaml`:

```yaml
msix_config:
  # معلومات التطبيق
  display_name: مساعد كفو
  publisher_display_name: جامعة الملك فيصل
  identity_name: com.kfu.kfu_ai
  
  # رقم الإصدار
  msix_version: 1.0.0.0
  
  # الأيقونة
  logo_path: assets\\images\\mosa3ed_kfu_icon_app.jpg
  
  # معلومات الناشر (يمكن استخدام شهادة مؤقتة للتطوير)
  # publisher: CN=YourPublisher
  certificate_path: NONE  # استخدام شهادة مؤقتة
  
  # اللغات المدعومة
  languages: ar, en
  
  # الوصف
  description: تطبيق مساعد كفو - مساعد ذكي لطلاب جامعة الملك فيصل
  
  # نوع التطبيق
  install_certificate: false  # للتطوير فقط
```

### 3. بناء حزمة MSIX:

```bash
# بناء التطبيق أولاً
flutter build windows --release

# إنشاء حزمة MSIX
flutter pub run msix:create
```

### 4. النتيجة:
ستجد الملف `.msix` في مجلد:
```
build/windows/x64/runner/Release/kfu_ai.msix
```

---

## 🔐 للتوزيع المهني (بدون تحذيرات):

### خيار 1: شهادة رقمية حقيقية

احصل على شهادة من:
- **DigiCert** (موصى به): $200-500/سنة
- **Sectigo**: $100-300/سنة
- **GlobalSign**: $150-400/سنة

بعد الحصول على الشهادة:

```yaml
msix_config:
  certificate_path: path/to/your/certificate.pfx
  certificate_password: YourPassword
  publisher: CN=Your Company Name, O=Your Organization, L=Your City, S=Your State, C=SA
```

### خيار 2: Microsoft Store

النشر في Microsoft Store يوفر:
- ✅ توقيع رقمي تلقائي من Microsoft
- ✅ توزيع عالمي
- ✅ تحديثات تلقائية
- ✅ لا حاجة لشهادة رقمية

التكلفة: $19 (لمرة واحدة)

---

## 🧪 للتطوير والاختبار:

إذا كنت تريد اختبار التطبيق بدون تحذيرات على أجهزة محددة:

### 1. إنشاء شهادة تطوير مؤقتة:

```powershell
# في PowerShell (كمسؤول)
New-SelfSignedCertificate -Type Custom -Subject "CN=KFU Development" -KeyUsage DigitalSignature -FriendlyName "KFU AI Development Certificate" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

# تصدير الشهادة
$pwd = ConvertTo-SecureString -String "YourPassword" -Force -AsPlainText
Export-PfxCertificate -Cert "Cert:\CurrentUser\My\THUMBPRINT" -FilePath "kfu_dev_cert.pfx" -Password $pwd
```

### 2. تثبيت الشهادة على الأجهزة المستهدفة:
- افتح `kfu_dev_cert.pfx`
- ثبّته في "Trusted Root Certification Authorities"
- اختر "Local Machine"

---

## 📊 مقارنة الخيارات:

| الطريقة | التكلفة | سهولة الاستخدام | الأمان | التحذيرات |
|---------|---------|-----------------|--------|-----------|
| EXE عادي | مجاني | سهل جداً | ✅ | ⚠️ يظهر |
| MSIX + شهادة مؤقتة | مجاني | متوسط | ✅ | ⚠️ يظهر |
| MSIX + شهادة حقيقية | $100-500/سنة | متوسط | ✅✅ | ❌ لا يظهر |
| Microsoft Store | $19 (مرة واحدة) | سهل | ✅✅✅ | ❌ لا يظهر |

---

## 🎯 التوصيات:

### للتطوير والاختبار:
- استخدم EXE عادي مع ملف README للمستخدمين

### للتوزيع الداخلي (داخل الجامعة):
- MSIX + شهادة تطوير مؤقتة
- شارك الشهادة مع IT Department لتثبيتها على أجهزة الجامعة

### للتوزيع العام:
- Microsoft Store (الأسهل والأرخص)
- أو MSIX + شهادة رقمية حقيقية (للتحكم الكامل)

---

## 📞 مصادر إضافية:

- [Flutter MSIX Documentation](https://pub.dev/packages/msix)
- [Microsoft Code Signing Guide](https://docs.microsoft.com/en-us/windows/msix/package/sign-app-package-using-signtool)
- [DigiCert Code Signing](https://www.digicert.com/signing/code-signing-certificates)

---

**ملاحظة:** التحذير الأمني ليس مشكلة في التطبيق نفسه، بل هو إجراء أمني من Windows لحماية المستخدمين من تطبيقات مجهولة المصدر.

