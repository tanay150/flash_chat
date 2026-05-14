# Development Guide

## Project Setup

### 1. Development Environment

**Required:**
- Flutter 3.8.1+
- Dart 3.4.1+
- Android SDK 21+ or iOS 11+
- Firebase CLI (optional)

**Recommended IDEs:**
- Android Studio with Flutter plugin
- VS Code with Flutter extension
- IntelliJ IDEA

### 2. Initial Setup

```bash
# Clone repository
git clone https://github.com/tanay150/flash_chat.git
cd flash_chat

# Get dependencies
flutter pub get

# Run pub upgrade
flutter pub upgrade

# Check everything
flutter doctor
```

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────┐
│     Presentation Layer          │
│  (Screens & UI Components)      │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   State Management Layer        │
│   (Provider, ChangeNotifier)    │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│   Business Logic Layer          │
│   (Providers)                   │
└────────────┬────────────────────┘
             │
┌────────────┴────────────────────┐
│    Data Access Layer            │
│  (Firebase, Firestore)          │
└─────────────────────────────────┘
```

## Code Style Guide

### Naming Conventions

**Variables and Functions**
```dart
// camelCase for variables and functions
String userName;
void sendMessage() {}
final messageController = TextEditingController();
```

**Classes and Types**
```dart
// PascalCase for classes
class UserModel {}
class ChatProvider extends ChangeNotifier {}
```

**Constants**
```dart
// camelCase for constants
const double paddingSmall = 8.0;
const String appTitle = 'Flash Chat';
```

**Files**
```dart
// snake_case for files
user_model.dart
auth_provider.dart
chat_list_screen.dart
```

### Dart Formatting

```bash
# Format all files
flutter format .

# Format specific file
flutter format lib/main.dart

# Check without formatting
dart format --line-length=80 lib/
```

### Linting

```bash
# Run analysis
flutter analyze

# Check specific file
flutter analyze lib/main.dart
```

## File Organization

### Screens Structure

```
screens/
├── auth/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── welcome_screen.dart
│   └── splash_screen.dart
└── chat/
    ├── chat_list_screen.dart
    ├── chat_detail_screen.dart
    └── widgets/
        ├── message_bubble.dart
        └── chat_list_item.dart
```

### Best Practices

1. **One Screen per File**
   - Each screen is its own file
   - Avoid combining multiple screens

2. **Reusable Widgets**
   - Extract common UI into widgets
   - Keep widgets in `widgets/` subfolder
   - Single responsibility principle

3. **State Management**
   - Use Provider for global state
   - Local state in StatefulWidget
   - Clear separation of concerns

## Development Workflow

### 1. Feature Development

```bash
# Create feature branch
git checkout -b feature/user-profile

# Develop feature
flutter run

# Test changes
flutter test

# Format code
flutter format .

# Commit changes
git add .
git commit -m "feat: add user profile feature"

# Push to GitHub
git push origin feature/user-profile

# Create Pull Request on GitHub
```

### 2. Running the App

```bash
# Run on connected device/emulator
flutter run

# Run with specific build type
flutter run --debug
flutter run --release
flutter run --profile

# Run with verbose logging
flutter run -v

# Run specific file
flutter run -t lib/main_dev.dart
```

### 3. Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/providers/auth_provider_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 4. Debugging

```bash
# Run with verbose output
flutter run -v

# Enable VM service on port 8181
flutter run --vm-service-port=8181

# Attach debugger to running app
flutter attach

# Use DevTools
flutter pub global activate devtools
devtools
```

## Firebase Configuration

### Firestore Security Rules

Create `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Chats collection
    match /chats/{chatId} {
      allow read, write: if request.auth.uid in resource.data.participantIds;
      
      // Messages subcollection
      match /messages/{messageId} {
        allow read, write: if request.auth.uid in get(/databases/$(database)/documents/chats/$(chatId)).data.participantIds;
      }
    }
  }
}
```

## Common Issues & Solutions

### Issue: Firebase Initialization Error
**Solution:**
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run
```

### Issue: Hot Reload Not Working
**Solution:**
```bash
# Stop app
# Press 'q' in terminal

# Run again
flutter run

# Try hot restart instead
# Press 'R' in terminal
```

### Issue: Dependency Conflicts
**Solution:**
```bash
# Update pub cache
flutter pub cache repair

# Get fresh dependencies
flutter pub get

# Upgrade to latest compatible versions
flutter pub upgrade
```

## Performance Optimization

### 1. Widget Building
```dart
// Bad: Rebuilds entire list
children: snapshot.data!.map((item) => Container(...)).toList()

// Good: Use ListView.builder
ListView.builder(
  itemBuilder: (context, index) => Container(...),
  itemCount: items.length,
)
```

### 2. State Management
```dart
// Bad: Rebuilds entire widget
build(context) {
  return Consumer<Provider>(
    builder: (context, provider, _) {
      return Text(provider.data);
    },
  );
}

// Good: Use selector for specific data
build(context) {
  return Selector<Provider, String>(
    selector: (context, provider) => provider.data,
    builder: (context, data, _) => Text(data),
  );
}
```

### 3. Image Optimization
```dart
// Always specify size
Image.network(
  url,
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Run `flutter test`
- [ ] Run `flutter analyze`
- [ ] Run `flutter format .`
- [ ] Test on multiple devices/screen sizes
- [ ] Update `README.md` if needed
- [ ] Tag release on GitHub
- [ ] Build APK/IPA

## Useful Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Docs](https://dart.dev/guides)
- [Firebase Docs](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Firestore Docs](https://cloud.google.com/firestore/docs)

## Questions?

Create an issue or contact the maintainers!