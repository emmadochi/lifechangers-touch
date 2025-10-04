# Lifechangers Touch - Flutter App

A Flutter-based mobile application for churches to share content, stream services, and provide premium features through a coin-based system.

## 🎨 Brand Colors
- **Primary:** Red (#DC2626)
- **Secondary:** Dark Blue (#1E3A8A)

## ✨ Features

### 🔐 Authentication
- User registration and login
- Social authentication (Google, Apple)
- Email verification
- Password reset functionality

### 📱 Main Features
- **Content Display**: Videos, audio, books, and messages
- **Live Streaming**: Real-time church services with chat
- **Download System**: Offline content access
- **Wallet System**: Coin-based premium content access
- **Premium Content**: Paywall and subscription features

### 🏗️ Architecture
- **State Management**: Provider pattern
- **Navigation**: GoRouter for declarative routing
- **Theme System**: Custom Material 3 theme with brand colors
- **Folder Structure**: Feature-based organization

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android NDK 27.0.12077973

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd lifechangers_touch_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📁 Project Structure

```
lib/
├── app/                          # App configuration
│   ├── routes/                   # Navigation routes
│   └── theme/                    # Theme and styling
├── core/                         # Core utilities
│   ├── constants/                # App constants
│   ├── utils/                    # Utility functions
│   └── services/                 # Core services
├── features/                     # Feature modules
│   ├── auth/                     # Authentication
│   ├── home/                     # Home screen
│   ├── media/                    # Content management
│   ├── livestream/               # Live streaming
│   ├── wallet/                   # Wallet and payments
│   ├── profile/                  # User profile
│   └── downloads/                # Download management
└── shared/                       # Shared components
    ├── widgets/                  # Reusable widgets
    ├── models/                   # Data models
    └── providers/                # State providers
```

## 🎯 Key Screens

### Authentication Screens
- Splash Screen
- Login Screen
- Registration Screen
- Forgot Password Screen
- Email Verification Screen

### Main App Screens
- Home Screen (Dashboard)
- Media Screen (Content Library)
- Connect Screen (Community)
- Profile Screen (User Settings)

### Content Screens
- Video Player
- Audio Player
- Book Reader
- Content Details
- Search Results

### Live Streaming Screens
- Livestreams List
- Active Livestream
- Stream Schedule
- Stream Chat

### Wallet & Payment Screens
- Give Screen
- Wallet Dashboard
- Coin Purchase
- Transaction History
- Earn Coins

## 🛠️ Dependencies

### Core Dependencies
- `provider` - State management
- `go_router` - Navigation
- `flutter` - UI framework

### Media & Streaming
- `video_player` - Video playback
- `audioplayers` - Audio playback
- `cached_network_image` - Image caching

### Authentication & Storage
- `firebase_auth` - Authentication
- `firebase_core` - Firebase core
- `shared_preferences` - Local storage
- `sqflite` - Database

### Network & API
- `http` - HTTP requests
- `dio` - Advanced HTTP client

### UI Enhancement
- `shimmer` - Loading animations
- `flutter_local_notifications` - Push notifications
- `in_app_purchase` - Payment processing

## 🎨 Theme System

The app uses a comprehensive theme system with:
- **Brand Colors**: Red and Dark Blue primary colors
- **Typography**: Inter font family with consistent text styles
- **Components**: Custom Material 3 components
- **Responsive Design**: Adaptive layouts for different screen sizes

## 📱 Supported Platforms

- **Android** (API 21+)
- **iOS** (iOS 11+)
- **Web** (Progressive Web App)

## 🔧 Development

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent indentation

### Testing
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter test integration_test/
```

### Code Analysis
```bash
# Analyze code
flutter analyze

# Format code
dart format .
```

## 🚀 Deployment

### Android
1. Update `android/app/build.gradle.kts` with signing config
2. Build release APK or App Bundle
3. Upload to Google Play Store

### iOS
1. Configure iOS signing in Xcode
2. Build and archive in Xcode
3. Upload to App Store Connect

## 📄 License

This project is proprietary software. All rights reserved.

## 👥 Team

- **Frontend Development**: Flutter/Dart
- **Backend Integration**: Firebase/APIs
- **UI/UX Design**: Material Design 3
- **Project Management**: Agile methodology

## 📞 Support

For technical support or questions, please contact the development team.

---

**Version**: 1.0.0  
**Last Updated**: October 2024  
**Flutter Version**: 3.8.1+  
**Dart Version**: 3.0.0+