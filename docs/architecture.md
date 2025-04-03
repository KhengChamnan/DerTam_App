# Tourism App - Architecture Documentation

## Architecture Overview

The Tourism App follows a layered architecture pattern with clear separation of concerns:

```
┌─────────────────┐
│     UI Layer    │ Screens, Widgets
├─────────────────┤
│   State Layer   │ Providers
├─────────────────┤
│ Repository Layer│ Firebase Repositories, API Services
├─────────────────┤
│   Data Layer    │ Models, DTOs
└─────────────────┘
```

## Detailed Architecture

### 1. UI Layer

The UI layer consists of:
- **Screens**: Full-page interfaces (`lib/ui/screens`)
- **Widgets**: Reusable components (`lib/ui/widgets`)

This layer is responsible for displaying data and capturing user input, but contains minimal business logic.

### 2. State Management Layer

Provider pattern is used for state management:
- **AuthServiceProvider**: Manages user authentication state
- **PlaceProvider**: Manages tourist places data
- **TripProvider**: Manages trip planning functionality
- **BudgetProvider**: Handles budget tracking
- **FavoriteProvider**: Manages user favorites
- **ChatbotProvider**: Handles chatbot interaction

Providers act as intermediaries between the UI and repository layers, processing business logic and providing data to the UI.

### 3. Repository Layer

Repositories handle data operations:
- **PlaceFirebaseRepository**: Manages tourist place data in Firestore
- **TripFirebaseRepository**: Handles trip data storage and retrieval
- **FavoriteFirebaseRepository**: Manages user favorites in Firebase

These repositories abstract the data source implementation details from the rest of the application.

### 4. Data Layer

Contains data models and DTOs:
- Models represent the core business entities
- Data Transfer Objects (DTOs) facilitate data transformation

### 5. External Services Integration

- **Firebase Authentication**: User authentication
- **Cloud Firestore**: NoSQL database for storing application data
- **Firebase Storage**: Storage for images and other files
- **Map Services**: Integration with Google Maps
- **Chatbot API**: External API for chatbot functionality

## Data Flow

1. User interacts with UI components
2. UI components notify Providers of actions
3. Providers process business logic and call Repositories
4. Repositories interact with data sources (Firebase, APIs)
5. Data flows back through the same layers in reverse order
6. UI updates to reflect the new state

## Dependencies Injection

Dependencies are injected using the Provider package:
- Services and repositories are instantiated in the main.dart file
- Providers consume these dependencies
- UI components access providers using Provider.of or Consumer widgets

## File Organization

- **Feature-based organization**: Files are organized by feature rather than by type
- **Clear import paths**: Relative imports are used for clarity
- **Separation of concerns**: Each file has a single responsibility

## Testing Strategy

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test interactions between components
- **Widget Tests**: Test UI components
- **Repository Tests**: Test data layer with mock data sources

## Security Considerations

- **Authentication**: Firebase Authentication for secure user management
- **Data Validation**: Both client-side and server-side validation
- **API Security**: Secure API endpoints with proper authentication
- **Environment Variables**: Sensitive information stored in environment variables 