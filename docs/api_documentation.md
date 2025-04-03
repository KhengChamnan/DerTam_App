# API Documentation

This document outlines the external APIs and services used in the Tourism App, along with their integration details.

## 1. Firebase Authentication API

Used for user authentication and management.

### Integration Points

- **Services**: Email/Password, Google Sign-In, Facebook Sign-In
- **Implementation**: Located in the Auth Provider (`lib/ui/providers/auth_provider.dart`)

### Key Methods

```dart
// Sign in with email and password
Future<UserCredential> signInWithEmailAndPassword(String email, String password);

// Sign up with email and password
Future<UserCredential> createUserWithEmailAndPassword(String email, String password);

// Sign in with Google
Future<UserCredential> signInWithGoogle();

// Sign in with Facebook
Future<UserCredential> signInWithFacebook();

// Sign out
Future<void> signOut();
```

## 2. Cloud Firestore API

Used for storing and retrieving application data.

### Collections

| Collection Name | Description | Schema |
|-----------------|-------------|--------|
| `users` | User profiles | `uid`, `name`, `email`, `photoUrl` |
| `places` | Tourist destinations | `id`, `name`, `description`, `location`, `images`, `rating` |
| `trips` | User trip plans | `id`, `userId`, `name`, `startDate`, `endDate`, `places`, `budget` |
| `favorites` | User favorite places | `id`, `userId`, `placeId` |

### Integration Points

- **Place Repository**: `lib/data/repository/firebase/place_firebase_repository.dart`
- **Trip Repository**: `lib/data/repository/firebase/trip_firebase_repository.dart`
- **Favorite Repository**: `lib/data/repository/firebase/favorite_firebase_repository.dart`

## 3. Firebase Storage API

Used for storing images and other media files.

### Storage Structure

- `/users/{userId}/profile.jpg` - User profile pictures
- `/places/{placeId}/{index}.jpg` - Place images
- `/trips/{tripId}/{index}.jpg` - Trip-related images

### Integration Points

- Image upload functionality in `lib/upload` directory

## 4. Google Maps API

Used for maps, location services, and navigation.

### Features Used

- Map display
- Geocoding (converting addresses to coordinates)
- Directions (route planning)
- Place search

### API Key Configuration

- Android: Configured in `android/app/src/main/AndroidManifest.xml`
- iOS: Configured in `ios/Runner/AppDelegate.swift`

### Integration Points

- Map screens and widgets in `lib/ui/screens` and `lib/ui/widgets`

## 5. Chatbot API

Used for the travel assistant chatbot feature.

### Endpoint

```
https://eee6-45-119-135-16.ngrok-free.app/chat
```

### Request Format

```json
{
  "message": "string",
  "userId": "string"
}
```

### Response Format

```json
{
  "response": "string",
  "suggestions": ["string"]
}
```

### Integration Points

- Chatbot Provider: `lib/ui/providers/chatbot_provider.dart`

## 6. Rate Limiting and Quotas

| API | Daily Limit | Rate Limit |
|-----|-------------|------------|
| Firebase Auth | Unlimited (free tier) | 100 req/min |
| Firestore | 50K reads, 20K writes, 20K deletes | N/A |
| Firebase Storage | 5GB storage, 1GB downloads | N/A |
| Google Maps | 200 requests/day (free tier) | 50 req/s |
| Chatbot API | 1000 requests/day | 10 req/s |

## 7. Error Handling

All API calls are wrapped in try-catch blocks with appropriate error handling:

```dart
try {
  // API call
} catch (e) {
  // Error handling logic
  if (e is FirebaseAuthException) {
    // Handle auth errors
  } else if (e is FirebaseException) {
    // Handle Firebase errors
  } else {
    // Handle other errors
  }
}
```

## 8. Authentication Flow

1. User provides credentials (email/password, Google, Facebook)
2. Auth Provider calls Firebase Authentication
3. On successful authentication, a user record is created/updated in Firestore
4. Auth tokens are stored securely for subsequent API calls

## 9. Data Sync Strategy

- Real-time updates using Firestore streams for frequently changing data
- Cached data with periodic refreshes for relatively static data
- Offline support with local data persistence

## 10. Security Considerations

- All API keys are stored in environment variables
- Firebase Security Rules restrict access to data based on user authentication
- HTTPS is used for all API communications
- API requests are authenticated where possible
- User input is validated before making API calls 