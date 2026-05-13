# Flash Chat - Development Guide

## 🏗️ Architecture Overview

This guide explains the architecture and structure of the Flash Chat application.

### State Management with Provider

We use the Provider package for state management. This ensures:
- Clean separation of concerns
- Easy testing
- Reactive UI updates
- Single source of truth

### Data Flow

```
UI (Screens) 
    ↓
Consumers (Provider.watch)
    ↓
Providers (State Management)
    ↓
Firestore (Database)
```

## 📂 Folder Structure Explanation

### `/lib/main.dart`
- Application entry point
- Firebase initialization
- Provider setup
- Root navigation

### `/lib/screens/`
- **auth/** - Authentication screens
  - `splash_screen.dart` - Loading/intro screen
  - `login_screen.dart` - User login
  - `signup_screen.dart` - User registration
- **chat/** - Chat screens
  - `chat_list_screen.dart` - List of all chats
  - `chat_detail_screen.dart` - Individual chat conversation

### `/lib/models/`
Data models for app entities:
- `user_model.dart` - User data structure
- `message_model.dart` - Message data structure
- `chat_model.dart` - Chat data structure

Each model includes:
- Constructor
- `toMap()` - Convert to Firestore format
- `fromFirestore()` - Convert from Firestore
- `copyWith()` - Create modified copies

### `/lib/providers/`
State management classes:
- `auth_provider.dart` - Authentication logic
  - User login/signup
  - Profile management
  - Logout functionality
- `chat_provider.dart` - Chat logic
  - Message sending/receiving
  - Chat creation
  - Real-time streams

### `/lib/utils/`
Reusable utilities:
- `colors.dart` - Color constants and theme
- `constants.dart` - App-wide constants
- `validators.dart` - Input validation (future)

## 🔄 Common Workflows

### Adding a New Screen

1. Create file in `/lib/screens/[category]/new_screen.dart`
2. Extend `StatefulWidget` or `StatelessWidget`
3. Use `Consumer<Provider>` to access state
4. Add navigation in appropriate place

### Adding a New Feature

1. Create data model in `/lib/models/`
2. Add provider logic in `/lib/providers/`
3. Create UI screens in `/lib/screens/`
4. Add navigation between screens
5. Update Firestore rules if needed

### Working with Firestore

```dart
// Create
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .set(userModel.toMap());

// Read (single)
final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .get();
final user = UserModel.fromFirestore(doc);

// Update
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .update({'username': newUsername});

// Delete
await FirebaseFirestore.instance
    .collection('users')
    .doc(userId)
    .delete();

// Real-time Stream
Stream<List<ChatModel>> getChats(String userId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ChatModel.fromFirestore(doc))
          .toList());
}
```

## 🧪 Testing

### Unit Tests
```dart
test('UserModel.fromFirestore creates correct object', () {
  // Arrange
  final testData = {...};
  
  // Act
  final user = UserModel.fromFirestore(testData);
  
  // Assert
  expect(user.uid, 'test-uid');
});
```

### Widget Tests
```dart
testWidgets('LoginScreen shows error on invalid email', (tester) async {
  await tester.pumpWidget(const LoginScreen());
  
  await tester.enterText(find.byType(TextField), 'invalid');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  expect(find.byType(SnackBar), findsOneWidget);
});
```

## 🔐 Security Best Practices

1. **Never commit sensitive data**
   - Firebase config files
   - API keys
   - Passwords

2. **Use environment variables**
   ```dart
   const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
   ```

3. **Validate input on client and server**
4. **Use Firebase Security Rules**
5. **Enable HTTPS for all API calls**

## 🐛 Debugging Tips

### Enable Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### Check Firestore Data
- Use Firebase Console
- Set breakpoints in providers
- Use `print()` for quick debugging
- Use Flutter's built-in debugger

### Common Issues

**Issue**: App crashes on startup
- **Solution**: Check Firebase initialization in `main.dart`

**Issue**: Messages not appearing
- **Solution**: Check Firestore security rules, verify user is authenticated

**Issue**: Provider not updating UI
- **Solution**: Ensure using `Consumer` or `watch`, check `notifyListeners()`

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

## 🚀 Performance Tips

1. **Use streams for real-time data**
   ```dart
   StreamBuilder(
     stream: provider.getChatsStream(),
     builder: (context, snapshot) {
       // Build UI
     },
   )
   ```

2. **Implement pagination for large lists**
   ```dart
   .limit(10) // Only fetch 10 at a time
   ```

3. **Use `const` constructors**
   ```dart
   const SizedBox(height: 16) // Immutable widgets
   ```

4. **Lazy load images**
   ```dart
   Image.network(
     url,
     cacheHeight: 200,
     cacheWidth: 200,
   )
   ```

## 📞 Need Help?

- Check existing issues on GitHub
- Read Flutter documentation
- Ask on Flutter community channels
- Create a detailed issue with reproduction steps
