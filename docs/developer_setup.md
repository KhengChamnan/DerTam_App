# Developer Setup Guide

This guide will walk you through setting up the Tourism App development environment on your local machine.

## Prerequisites

Ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.5.0 or later)
- [Dart SDK](https://dart.dev/get-dart) (version 3.5.3 or later)
- [Git](https://git-scm.com/downloads)
- [Android Studio](https://developer.android.com/studio) (for Android development)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development, macOS only)
- [VS Code](https://code.visualstudio.com/) (recommended editor)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for Firebase integration)

## Step 1: Clone the Repository

```bash
git clone <repository-url>
cd tourism_app
```

## Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

## Step 3: Firebase Setup

### Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter a project name, e.g., "Tourism App"
4. Follow the prompts to create the project

### Configure Firebase for Flutter

1. Add Android app to your Firebase project:
   - Package name: `com.example.tourism_app` (or your actual package name)
   - Download the `google-services.json` file and place it in `android/app/`

2. Add iOS app to your Firebase project (if developing for iOS):
   - Bundle ID: `com.example.tourismApp` (or your actual bundle ID)
   - Download the `GoogleService-Info.plist` file and place it in `ios/Runner/`

3. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. Configure FlutterFire:
   ```bash
   flutterfire configure --project=<your-firebase-project-id>
   ```

## Step 4: Enable Firebase Services

In the Firebase Console:

1. **Authentication**:
   - Go to "Authentication" → "Sign-in method"
   - Enable Email/Password, Google, and Facebook authentication methods

2. **Firestore Database**:
   - Go to "Firestore Database" → "Create database"
   - Start in production mode
   - Choose a location closest to your target users

3. **Storage**:
   - Go to "Storage" → "Get started"
   - Select a location for your storage bucket

## Step 5: Environment Variables Setup

Create a `.env` file in the project root with the following variables:

```
MAPS_API_KEY=your_google_maps_api_key
CHATBOT_API_URL=your_chatbot_api_url
```

## Step 6: Google Maps API Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or use your existing Firebase project
3. Enable the Google Maps API for Android and/or iOS
4. Generate API keys and add them to:
   - Android: Add to `android/app/src/main/AndroidManifest.xml`
   - iOS: Add to `ios/Runner/AppDelegate.swift`

## Step 7: Run the App

Ensure you have a device connected or an emulator running, then:

```bash
flutter run
```

## Common Issues and Troubleshooting

### Build Errors

If you encounter build errors:
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Integration Issues

If Firebase fails to initialize:
- Ensure you've downloaded the correct Firebase configuration files
- Verify the package name/bundle ID matches your app's configuration
- Check that you've enabled the required Firebase services

### Google Maps Issues

If Google Maps fails to load:
- Verify your API key is correct
- Ensure the API key has the proper restrictions and API access enabled
- Check that the API key is correctly added to your app's configuration files

## Recommended Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Implement your changes**:
   - Follow the project's code style and architecture
   - Write tests for your code

3. **Test your changes**:
   ```bash
   flutter test
   ```

4. **Submit a pull request**:
   - Push your branch to the repository
   - Create a pull request with a detailed description of your changes 