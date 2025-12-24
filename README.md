# Recipe App - Flutter Application

A complete Flutter Recipe Application built with clean architecture, BLoC state management, and SQLite local storage.

## Features

- ✅ **Recipe Management**: Create, read, update, and delete recipes
- ✅ **Recipe Types**: Filter recipes by type (Breakfast, Lunch, Dinner, Dessert, etc.)
- ✅ **Dynamic Forms**: Add ingredients and steps dynamically
- ✅ **Persistent Storage**: SQLite database for offline data persistence
- ✅ **Responsive Design**: Works on all screen sizes and orientations
- ✅ **Material Design**: Clean, modern UI following Google's guidelines
- ✅ **Sample Data**: Pre-populated with 5 sample recipes

## Tech Stack

- **Language**: Dart
- **Framework**: Flutter (latest stable)
- **State Management**: BLoC (flutter_bloc)
- **Local Storage**: SQLite (sqflite)
- **Architecture**: Clean Architecture

## Getting Started

### Installation

1. Navigate to the project directory:
   ```bash
   cd recipeapptest
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                          # App entry point and main app widget
├── core/                              # Core utilities
│   ├── constants/app_constants.dart
│   ├── theme/app_theme.dart
│   └── utils/json_helper.dart
├── data/                              # Data layer
│   ├── models/                        # Data models
│   ├── local/sqlite_helper.dart       # Database
│   └── repositories/                  # Repository pattern
├── bloc/recipe/                       # BLoC state management
│   ├── recipe_bloc.dart
│   ├── recipe_event.dart
│   └── recipe_state.dart
└── presentation/                      # UI layer
    ├── pages/                         # Screen pages
    └── widgets/                       # Reusable widgets
```

## Testing

```bash
flutter test
flutter analyze
```

All tests pass with no issues!
