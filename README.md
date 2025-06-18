# AUVNET Flutter Internship Assessment

A Flutter-based e-commerce application demonstrating authentication, product listing, cart management, and persistent user preferences.

## Project Setup & Installation

1. **Clone the Repository**
   ```sh
   git clone https://github.com/Ahmed-0-Ibrahim/AUVNET-Flutter-Internship-Assessment.git
   cd AUVNET-Flutter-Internship-Assessment
   ```

2. **Install Dependencies**
   ```sh
   flutter pub get
   ```

3. **Firebase Setup**
   - Ensure you have a Firebase project.
   - Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the respective platform folders.
   - Update Firebase configuration in the project if needed.

4. **Run the App**
   ```sh
   flutter run
   ```

## Architectural Overview

This project uses a **feature-first** structure and the **BLoC (Business Logic Component)** pattern for state management.

- **lib/features/**: Each feature (auth, home, cart, product) contains its own presentation, domain, and data layers.
- **State Management**: Uses `flutter_bloc` for scalable and testable state management.
- **Persistence**: Uses `hive_flutter` for local storage of user preferences (e.g., grid/list view).
- **Firebase**: Handles authentication and backend services.
- **UI**: Responsive layouts with support for both grid and list product views, and a persistent cart.

**Rationale**:  
- **BLoC** separates UI from business logic, making the codebase maintainable and testable.
- **Feature-first** organization scales well as the app grows.
- **Hive** is lightweight and fast for local key-value storage.
- **Firebase** provides robust authentication and backend integration.
