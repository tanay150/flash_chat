# Troubleshooting Guide

## Common Issues and Solutions

### Flutter & Dart Issues

#### 1. Flutter Doctor Fails

```bash
# Check for issues
flutter doctor -v

# Common fixes
flutter doctor --android-licenses  # Accept Android licenses
flutter config --enable-web        # Enable web platform
flutter config --enable-windows    # Enable Windows platform
```

#### 2. Pub Get Issues

```bash
# Clear pub cache
flutter pub cache repair

# Remove lock files
rm pubspec.lock
rm -rf .dart_tool/

# Get fresh dependencies
flutter pub get
```

#### 3. Hot Reload Not Working

- Press `R` in terminal for hot restart
- Rebuild the app completely: `flutter run`
- Check for syntax errors

---

### Firebase Issues

#### 1. Firebase Initialization Error

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

Make sure:
- [ ] google-services.json (Android)
- [ ] GoogleService-Info.plist (iOS)
- [ ] Firebase project is configured

#### 2. Authentication Fails

**Check:**
- [ ] Firebase project is active
- [ ] Email/Password authentication enabled
- [ ] User exists in Firebase Auth
- [ ] Firestore security rules allow access

#### 3. Firestore Connection Issues

```dart
// Test connection
final test = await FirebaseFirestore.instance.collection('test').get();
print(test.docs);
```

---

### Android Issues

#### 1. Build Fails

```bash
# Clean build
flutter clean
flutter pub get
flutter run

# Check Android setup
flutter doctor
```

#### 2. Gradle Error

```bash
# Clean gradle cache
cd android
./gradlew clean
cd ..

# Rebuild
flutter run
```

#### 3. API Level Issues

Update `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34  // Latest
    minSdkVersion 21      // Minimum
}
```

---

### iOS Issues

#### 1. Build Fails

```bash
# Clean iOS build
rm -rf ios/Pods
rm ios/Podfile.lock
flutter pub get
flutter run
```

#### 2. Pod Issues

```bash
# Update CocoaPods
sudo gem install cocoapods

# Install pods
cd ios
pod install --repo-update
cd ..

flutter run
```

#### 3. Development Team Not Set

- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner in Project Navigator
- Go to Signing & Capabilities
- Select your Development Team

---

### Code Issues

#### 1. Null Safety Errors

```dart
// Bad
String name = null;  // Error: can't assign null to non-nullable type

// Good
String? name = null;  // Nullable
String name = '';     // Non-nullable with default
```

#### 2. Missing Imports

```bash
# Run analysis
flutter analyze

# Auto-fix
dart fix --apply
```

#### 3. Widget Not Found

- Check import statements
- Verify package is added to pubspec.yaml
- Run `flutter pub get`

---

### Performance Issues

#### 1. App Slow

- Use `ListView.builder` instead of `ListView`
- Use `const` constructors
- Profile with DevTools:
  ```bash
  flutter pub global activate devtools
  devtools
  ```

#### 2. Memory Leak

- Properly dispose controllers:
  ```dart
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  ```

- Close streams and listeners

#### 3. UI Jank

- Reduce rebuild frequency
- Use `RepaintBoundary` for complex widgets
- Optimize images and assets

---

### Network Issues

#### 1. Firebase Timeout

```dart
// Increase timeout
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
);
```

#### 2. Connection Error

- Check internet connection
- Verify Firebase project is accessible
- Check firewall settings

---

### Build & Release Issues

#### 1. APK Build Fails

```bash
# Clean build
flutter clean

# Build APK
flutter build apk --release

# Or split per ABI
flutter build apk --split-per-abi
```

#### 2. iOS Build Fails

```bash
# Update pods
cd ios
pod repo update
pod install
cd ..

# Build IPA
flutter build ios --release
```

#### 3. Signing Issues

**iOS:**
- Update signing certificate in Xcode
- Set correct Development Team
- Update provisioning profile

**Android:**
- Create signing key:
  ```bash
  keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
  ```

---

## Getting Help

### Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)

### Create an Issue

1. Check existing issues first
2. Gather error logs and stack traces
3. Provide:
   - Flutter/Dart version
   - Device/Emulator info
   - Steps to reproduce
   - Error messages

### Debug Information

```bash
# Get debug info
flutter doctor -v
flutter --version
dart --version
```

---

## Still Stuck?

- Create a GitHub issue
- Ask on Flutter Discord
- Post on Stack Overflow
- Check Flutter Discussions