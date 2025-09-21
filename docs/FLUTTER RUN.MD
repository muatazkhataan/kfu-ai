flutter build apk --debug

flutter build apk --release
تشغيل ويندوز
flutter build windows --debug
أو 
flutter clean
flutter build windows
بناء الأيقونات
flutter pub run flutter_launcher_icons:main -f pubspec.yaml

dart fix --apply

Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue

**FLUTTER CLEAN RUN**

flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run

**FLUTTER DEBUG RUN**

flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run --debug

**FLUTTER RELEASE RUN**

flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run --release

**FLUTTER BUILKD RELEASE **

flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter build apk --release --no-tree-shake-icons

flutter build apk --debug --target-platform android-arm64


flutter build apk --debug


flutter logs --clear

dart run flutter_launcher_icons

flutter analyze --no-fatal-infos

**CLEAN ANDROID 2**

flutter clean
cd android && ./gradlew --stop
cd android
./gradlew --stop
./gradlew clean
cd .. && flutter pub get
flutter run



**CREAT ARB FILES**
flutter gen-l10n

flutter pub run flutter_gen:flutter_gen_command

flutter clean && flutter pub get && flutter build apk --release


**Cash Clean**
flutter pub cache clean

**CASH REPAIR**
flutter pub cache repair

**أحذف cache بالكامل وأعد تحميله:**
flutter pub cache clean --force

flutter analyze --no-fatal-infos | grep -E "(error|Error)" | head -20

