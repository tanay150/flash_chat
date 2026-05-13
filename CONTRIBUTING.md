# Contributing to Flash Chat

Thank you for your interest in contributing to Flash Chat! We welcome contributions from the community.

## How to Contribute

### 1. Fork the Repository
- Click the "Fork" button on GitHub
- Clone your fork locally:
  ```bash
  git clone https://github.com/YOUR_USERNAME/flash_chat.git
  cd flash_chat
  ```

### 2. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
# or for bug fixes
git checkout -b fix/bug-description
```

### 3. Make Changes
- Follow the [code style guide](#code-style-guide)
- Keep commits atomic and focused
- Write clear commit messages

### 4. Test Your Changes
```bash
flutter format .
flutter analyze
flutter test
flutter run
```

### 5. Commit and Push
```bash
git add .
git commit -m "feat: brief description of changes"
git push origin feature/your-feature-name
```

### 6. Create a Pull Request
- Go to GitHub and create a PR
- Provide a clear title and description
- Reference any related issues

## Code Style Guide

### Naming Conventions

**Variables & Functions** (camelCase)
```dart
String userName;
void sendMessage() {}
final messageController = TextEditingController();
```

**Classes** (PascalCase)
```dart
class UserModel {}
class AuthProvider extends ChangeNotifier {}
```

**Constants** (camelCase)
```dart
const double paddingSmall = 8.0;
const String appTitle = 'Flash Chat';
```

**Files** (snake_case)
```
user_model.dart
auth_provider.dart
chat_list_screen.dart
```

### Formatting

```bash
# Format code
flutter format .

# Run analysis
flutter analyze

# Fix issues
dart fix --apply
```

### Code Quality Checklist

- [ ] Follows naming conventions
- [ ] No unused imports
- [ ] No dead code
- [ ] Proper error handling
- [ ] Added null safety where applicable
- [ ] Code formatted properly
- [ ] Tests pass
- [ ] No analyzer warnings

## Widget Structure

### Good Widget Example

```dart
class MyWidget extends StatefulWidget {
  const MyWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize resources
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
```

### Best Practices

1. **Always use const where possible**
   ```dart
   const SizedBox(height: 16) // Good
   SizedBox(height: 16)       // Avoid
   ```

2. **Use null safety**
   ```dart
   String? name;  // Nullable
   String name;   // Non-nullable (requires initialization)
   ```

3. **Proper error handling**
   ```dart
   try {
     // Do something
   } on SpecificException catch (e) {
     // Handle specific error
   } catch (e) {
     // Handle generic error
   }
   ```

4. **Resource cleanup**
   ```dart
   @override
   void dispose() {
     controller.dispose();
     super.dispose();
   }
   ```

## Bug Reports

### Before Creating an Issue

- [ ] Check existing issues
- [ ] Verify the bug exists in latest version
- [ ] Gather error messages and logs

### Bug Report Template

```markdown
## Description
Brief description of the bug.

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen.

## Actual Behavior
What actually happens.

## Screenshots
If applicable, add screenshots.

## Environment
- Flutter version: 
- Device/Emulator:
- Platform: iOS/Android

## Additional Context
Any other context.
```

## Feature Requests

### Feature Request Template

```markdown
## Description
Clear description of the feature.

## Use Case
Why this feature is needed.

## Proposed Solution
How you think it should work.

## Alternatives
Other solutions you've considered.

## Additional Context
Any other context or examples.
```

## Pull Request Guidelines

### Before Creating a PR

- [ ] Branch from `main`
- [ ] Code passes `flutter analyze`
- [ ] Code formatted with `flutter format .`
- [ ] Updated documentation if needed
- [ ] Added tests for new features
- [ ] Tested on multiple screen sizes

### PR Title Format

```
feat: add new feature
fix: resolve bug description
docs: update documentation
refactor: improve code structure
test: add test coverage
chore: update dependencies
```

### PR Description

Include:
- What changes were made
- Why the changes were made
- How to test the changes
- Screenshots/videos if applicable
- Closes #ISSUE_NUMBER

## Development Setup

```bash
# Install dependencies
flutter pub get

# Run development version
flutter run

# Run tests
flutter test

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

## Questions?

- Check existing issues and discussions
- Read the [DEVELOPMENT.md](DEVELOPMENT.md)
- Open a GitHub discussion

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Respect others' opinions and work
- No harassment or discrimination

Thank you for contributing! 🙏
