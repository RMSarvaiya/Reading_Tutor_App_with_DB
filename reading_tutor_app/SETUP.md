# Quick Setup Guide - Reading Tutor App

## Step-by-Step Installation

### 1. Install Flutter

#### Windows
1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
2. Extract ZIP file to a location (e.g., `C:\src\flutter`)
3. Add Flutter to PATH:
    - Search "Environment Variables" in Windows
    - Edit PATH variable
    - Add `C:\src\flutter\bin`
4. Run `flutter doctor` in Command Prompt

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or download from flutter.dev
cd ~/development
unzip ~/Downloads/flutter_macos_xxx.zip
export PATH="$PATH:`pwd`/flutter/bin"
```

#### Linux
```bash
cd ~/development
tar xf ~/Downloads/flutter_linux_xxx.tar.xz
export PATH="$PATH:$HOME/development/flutter/bin"
```

### 2. Setup Development Environment

#### Android Studio (Recommended)
1. Download from https://developer.android.com/studio
2. Install Android Studio
3. Open Android Studio
4. Go to Plugins → Install "Flutter" and "Dart" plugins
5. Restart Android Studio
6. Configure Android SDK (SDK Manager)
7. Create Android Virtual Device (AVD Manager)

#### VS Code (Alternative)
1. Download from https://code.visualstudio.com/
2. Install "Flutter" extension
3. Install "Dart" extension
4. Press Ctrl+Shift+P → "Flutter: New Project"

### 3. Setup This Project

```bash
# Navigate to project directory
cd reading_tutor_app

# Get dependencies
flutter pub get

# Check everything is working
flutter doctor

# Run the app
flutter run
```

### 4. Run on Different Platforms

#### Android Emulator
```bash
# List available devices
flutter devices

# Run on Android
flutter run -d android
```

#### iOS Simulator (Mac only)
```bash
# Open simulator
open -a Simulator

# Run on iOS
flutter run -d ios
```

#### Chrome (Web)
```bash
flutter run -d chrome
```

#### Physical Device

**Android:**
1. Enable Developer Options on phone
2. Enable USB Debugging
3. Connect phone via USB
4. Run `flutter run`

**iOS (Mac only):**
1. Connect iPhone via USB
2. Trust computer on iPhone
3. Open Xcode and sign app
4. Run `flutter run`

## Common Issues & Solutions

### Issue: "Flutter not found"
**Solution:** Add Flutter to PATH environment variable

### Issue: "Android license not accepted"
```bash
flutter doctor --android-licenses
```
Accept all licenses

### Issue: "No devices found"
**Solution:**
- Start emulator/simulator
- Enable USB debugging on physical device
- Run `flutter devices` to verify

### Issue: Build fails
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "SDK version error"
**Solution:** Update Flutter
```bash
flutter upgrade
```

## Verify Installation

Run this command and fix any issues:
```bash
flutter doctor -v
```

Expected output:
```
[✓] Flutter (Channel stable)
[✓] Android toolchain
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device
```

## Running the App

### Development Mode
```bash
# Hot reload enabled
flutter run
```

### Release Mode
```bash
# Optimized performance
flutter run --release
```

### Debug Mode
```bash
# With debugging tools
flutter run --debug
```

## Building APK (Android)

```bash
# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle

# Find built file
# APK: build/app/outputs/flutter-apk/app-release.apk
```

## Building iOS App (Mac only)

```bash
# Build iOS app
flutter build ios

# Or open in Xcode
open ios/Runner.xcworkspace
```

## Project Files Overview

```
reading_tutor_app/
├── android/          # Android native code
├── ios/              # iOS native code  
├── lib/              # Dart application code
│   ├── main.dart     # Entry point
│   ├── models/       # Data models
│   └── screens/      # UI screens
├── test/             # Unit tests
├── pubspec.yaml      # Dependencies
└── README.md         # Documentation
```

## Next Steps

1. ✅ Install Flutter
2. ✅ Setup IDE
3. ✅ Get project dependencies
4. ✅ Run app
5. 🎉 Start learning!

## Useful Commands

```bash
# Check Flutter version
flutter --version

# Update Flutter
flutter upgrade

# Clean build files
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run

# Hot reload (while app running)
Press 'r'

# Hot restart (while app running)
Press 'R'

# Quit (while app running)
Press 'q'
```

## Getting Help

- Flutter Documentation: https://flutter.dev/docs
- Flutter Community: https://flutter.dev/community
- Stack Overflow: Tag `flutter`
- GitHub Issues: Report bugs

## Ready to Start!

Once everything is set up, just run:

```bash
cd reading_tutor_app
flutter run
```

The app will launch and you can start using the Reading Tutor!

---

**Need help?** Check the troubleshooting section above or visit Flutter's official documentation.
