# Tourism App - Project Documentation

## Overview
This project is called DERTAM – Tourism Mobile Application, which involves
the design and implementations of a mobile application aimed to enhancing the travel
experience for tourist explore new destinations, hidden popular places, also including
the nearby places such as hotel, restaurants that rally help for user, trip planning, budget
management and AI powered chatbot that assist user anywhere anytime.
We know that in nowadays tourism field is a significant in our country that have
a lot of attractions places for tourist and technology is worldwide so digital solutions
play a vital role in providing seamless and efficient experience for users. DEREAM
focuses on creating a great mobile app that covers all popular places in Cambodia. This
application is secure and very easy to use. It acts like a very interactive platform that
makes people exploring new destination an easy task. It lets you plan trips however you
like. Even inside trip plan you have an easy UI to manage your budget. This application
also carries a desirable feature with AI chatbot, it is an important feature that will really
help you to get what you need. The main objective of DEREAM is to be a smart
companion for travel, making great use of new technology like Flutter, Dart and
Firebase and also leverage AI chatbot.

## Project Structure

### Core Files
- `lib/main.dart` - Entry point of the application, initializes Firebase and sets up the provider architecture
- `lib/firebase_options.dart` - Firebase configuration for different platforms

### Directories
- `lib/ui` - User interface components
  - `screens` - Application screens
  - `widgets` - Reusable UI components
  - `providers` - State management (Provider pattern)
- `lib/data` - Data layer
  - `repository` - Data repositories
  - `dummy_data` - Mock data for testing
- `lib/models` - Data models for the application
- `lib/utils` - Utility functions and helper classes
- `lib/config` - Configuration files and constants
- `lib/theme` - Theming related files (colors, text styles, etc.)
- `lib/upload` - File upload related functionality

## Features
- User authentication (Firebase Auth)
- Tourist place discovery and browsing
- Trip planning and management
- Favorites system
- Budget tracking
- Chatbot integration for travel assistance
- Google Maps integration for location services

## Technologies Used
- Flutter/Dart - Cross-platform UI framework
- Firebase - Backend services
  - Firebase Auth - Authentication
  - Cloud Firestore - Database
  - Firebase Storage - File storage
- Provider - State management
- Google Maps - Location and mapping services
- API integration for chatbot services

## Dependencies
Major dependencies include:
- `firebase_core`, `firebase_auth`, `cloud_firestore`
- `provider` for state management
- `google_maps_flutter` for maps functionality
- `http` for API calls
- `flutter_dotenv` for environment variables
- `image_picker` and `firebase_storage` for image handling

## Setup Instructions
1. Clone the repository
2. Ensure you have Flutter installed (version 3.5.0 or later)
3. Run `flutter pub get` to install dependencies
4. Configure Firebase:
   - Create a new Firebase project
   - Add applications (Android, iOS) to your Firebase project
   - Download and place the configuration files
   - Enable required Firebase services (Authentication, Firestore, Storage)
5. Set up your `.env` file with required API keys
6. Run `flutter run` to start the application

## Architecture
The application follows a clean architecture pattern with:
- UI layer (screens, widgets)
- Business logic layer (providers)
- Data layer (repositories)
- External services (Firebase, APIs)

## Contributing Guidelines
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License
[Your license information here]

## Contact
[Your contact information here] 