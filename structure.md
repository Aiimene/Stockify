# MedBox - Mobile App Structure Documentation

## Overview

**MedBox** is a Flutter mobile application for managing medical tasks and patient appointments. The app follows **Clean Architecture** principles with clear separation of concerns across data, logic, and presentation layers.

### Key Features
- ✅ Task management (Create, Read, Update, Delete)
- ✅ Patient appointment tracking
- ✅ Urgency level classification (Low, Medium, High)
- ✅ Task filtering by urgency
- ✅ Multi-language support (Arabic, English, French)
- ✅ Local SQLite database storage
- ✅ Cross-platform support (iOS, Android, Linux, Windows)

---

## Architecture Pattern

The application implements **Clean Architecture** with the following layers:


```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI Screens, Widgets, Themes)          │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         Logic Layer                     │
│  (Cubits - State Management)            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         Data Layer                      │
│  (Models, Repositories, Database)       │
└─────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── data/                    # Data Layer
│   ├── databases/          
│   │   └── dbhelper.dart           # SQLite database helper
│   ├── models/             
│   │   ├── Result.dart             # Generic result wrapper
│   │   └── task.dart               # Task entity model
│   └── repositories/       
│       └── task_repository.dart    # Task data operations
│
├── l10n/                    # Localization
│   ├── app_ar.arb                  # Arabic translations
│   ├── app_en.arb                  # English translations
│   ├── app_fr.arb                  # French translations
│   ├── app_localizations.dart      # Base localization class
│   ├── app_localizations_ar.dart   # Arabic localization
│   ├── app_localizations_en.dart   # English localization
│   └── app_localizations_fr.dart   # French localization
│
├── logic/                   # Business Logic Layer
│   └── cubits/             
│       └── tasks_cubit.dart        # Task state management
│
├── presentation/            # Presentation Layer
│   ├── screens/            
│   │   └── tasks/          
│   │       └── tasks_screen.dart   # Main tasks screen
│   ├── themes/             
│   │   └── constants.dart          # Theme constants
│   └── widgets/            
│       ├── confirmation_dialog.dart # Reusable confirmation dialog
│       ├── progress_button.dart     # Custom progress button
│       └── snack_bars.dart          # Snackbar utilities
│
├── src/                     # Source utilities (currently empty)
│
└── main.dart                # Application entry point
```

---

## Layer Details

### 1. Data Layer (`/data`)

Handles all data operations, persistence, and data models.

#### **Databases** (`/data/databases`)
- **`dbhelper.dart`**: SQLite database helper singleton
  - Database name: `medbox_tasks.db`
  - Table: `tasks`
  - Schema: id, patientName, date, urgency, type
  - CRUD operations for tasks
  - Automatic database initialization

#### **Models** (`/data/models`)
- **`task.dart`**: Core Task entity
  ```dart
  - id: int?
  - patientName: String
  - date: DateTime
  - urgency: Urgency (enum: low, medium, high)
  - type: String
  ```
  - Includes serialization methods (`toMap()`, `fromMap()`)

- **`Result.dart`**: Generic result wrapper
  ```dart
  - state: bool
  - message: String
  ```

#### **Repositories** (`/data/repositories`)
- **`task_repository.dart`**: Data access abstraction
  - `getAll()`: Fetch all tasks
  - `insert(Task)`: Create new task
  - `update(Task)`: Update existing task
  - `delete(int)`: Delete task by ID

---

### 2. Logic Layer (`/logic`)

Manages application state and business logic using **BLoC pattern**.

#### **Cubits** (`/logic/cubits`)
- **`tasks_cubit.dart`**: Task state management
  - **State**: `TasksState`
    - `tasks`: List of tasks
    - `loading`: Loading indicator
    - `error`: Error message
    - `filter`: Current urgency filter
  
  - **Operations**:
    - `loadTasks()`: Load all tasks
    - `addTask(Task)`: Add new task
    - `updateTask(Task)`: Update task
    - `deleteTask(int)`: Delete task
    - `filterByUrgency(Urgency?)`: Filter tasks by urgency

---

### 3. Presentation Layer (`/presentation`)

Handles UI components, screens, and user interactions.

#### **Screens** (`/presentation/screens`)
- **`tasks_screen.dart`**: Main application screen
  - Task list view with filtering
  - Add/Edit task dialog
  - Delete task functionality
  - Real-time state updates via BlocBuilder

#### **Themes** (`/presentation/themes`)
- **`constants.dart`**: Theme configuration
  - Colors, typography, spacing constants

#### **Widgets** (`/presentation/widgets`)
Reusable UI components:
- **`confirmation_dialog.dart`**: Generic confirmation dialog
- **`progress_button.dart`**: Button with loading state
- **`snack_bars.dart`**: Snackbar utilities for notifications

---

### 4. Localization (`/l10n`)

Multi-language support for Arabic, English, and French.

**Supported Languages**:
- 🇸🇦 Arabic (`ar`) - Default locale
- 🇬🇧 English (`en`)
- 🇫🇷 French (`fr`)

**Localized Strings**:
- UI labels (Tasks, Filter, Urgency levels)
- Button text (Save, Cancel, Change)
- Form labels (Patient name, Task type, Date)
- Status messages (No tasks, Error messages)

**Implementation**:
- Uses Flutter's built-in localization system
- ARB (Application Resource Bundle) files
- Auto-generated localization classes

---

### 5. Application Entry Point (`main.dart`)

**Initialization Flow**:
1. **`init_my_app()`**: Setup function
   - Initializes sqflite_ffi for Linux/Windows support
   - Registers `TaskRepository` with GetIt (dependency injection)
   - Ensures Flutter bindings

2. **`main()`**: Entry point
   - Calls initialization
   - Runs `MainApp`

3. **`MainApp`**: Root widget
   - Sets up `MultiBlocProvider` for state management
   - Configures localization delegates
   - Sets Arabic as default locale
   - Navigates to `TasksScreen`

---

## State Management

### BLoC Pattern (Cubit)

The app uses **flutter_bloc** for state management:

```dart
TasksCubit (extends Cubit<TasksState>)
    ↓
TasksState {
  - tasks: List<Task>
  - loading: bool
  - error: String?
  - filter: Urgency?
}
    ↓
UI (BlocBuilder/BlocProvider)
```

**Benefits**:
- Clear separation of business logic and UI
- Predictable state changes
- Easy testing
- Time-travel debugging support

---

## Dependency Injection

Uses **GetIt** service locator pattern:

```dart
GetIt.instance.registerLazySingleton<TaskRepository>(
  () => TaskRepository()
);
```

**Registered Services**:
- `TaskRepository`: Singleton instance for data operations

---

## Database Schema

**Table**: `tasks`

| Column       | Type    | Constraints           |
|--------------|---------|-----------------------|
| id           | INTEGER | PRIMARY KEY AUTOINCREMENT |
| patientName  | TEXT    | NOT NULL              |
| date         | TEXT    | NOT NULL (ISO 8601)   |
| urgency      | TEXT    | NOT NULL (low/medium/high) |
| type         | TEXT    | NOT NULL              |

---

## Key Dependencies

### Core Flutter Packages
- `flutter_bloc`: State management
- `sqflite`: SQLite database
- `sqflite_common_ffi`: Desktop platform support
- `get_it`: Dependency injection
- `flutter_localizations`: Internationalization
- `path`: Path manipulation

---

## Data Flow

### Adding a Task
```
User Input (UI)
    ↓
TasksScreen._showTaskDialog()
    ↓
TasksCubit.addTask(task)
    ↓
TaskRepository.insert(task)
    ↓
TaskDBHelper.insertTask(map)
    ↓
SQLite Database
    ↓
TasksCubit.loadTasks()
    ↓
UI Update (BlocBuilder)
```

### Filtering Tasks
```
User Selection (Dropdown)
    ↓
TasksCubit.filterByUrgency(urgency)
    ↓
Filter _all tasks list
    ↓
Emit new state with filtered tasks
    ↓
UI Update (BlocBuilder)
```

---

## UI Components

### Main Screen (`TasksScreen`)
- **AppBar**: Title with localization
- **Urgency Filter**: Dropdown to filter tasks
- **Task List**: Scrollable list of tasks
- **Task Tile**: Shows patient name, type, date, urgency
- **Actions**: Edit (tap), Delete (icon button)
- **FAB**: Floating action button to add tasks

### Task Dialog
- **Patient Name**: Text input field
- **Task Type**: Text input field (test, consultation, etc.)
- **Date Picker**: Date selection
- **Urgency Dropdown**: Low/Medium/High selection
- **Actions**: Cancel, Save buttons

---

## Design Patterns Used

1. **Clean Architecture**: Layer separation
2. **Repository Pattern**: Data access abstraction
3. **Singleton Pattern**: Database helper
4. **Service Locator**: GetIt dependency injection
5. **BLoC Pattern**: State management
6. **Factory Pattern**: Model creation from maps

---

## Platform Support

- ✅ iOS
- ✅ Android
- ✅ Linux (with sqflite_ffi)
- ✅ Windows (with sqflite_ffi)
- ⚠️ macOS (requires sqflite_ffi setup)
- ⚠️ Web (requires alternative to sqflite)

---

## Best Practices Implemented

1. **Separation of Concerns**: Clear layer boundaries
2. **Single Responsibility**: Each class has one purpose
3. **Dependency Inversion**: Repositories abstract data sources
4. **Internationalization**: Multi-language support from start
5. **Type Safety**: Strong typing with Dart
6. **Error Handling**: Try-catch blocks with error state
7. **Code Reusability**: Shared widgets and utilities
8. **State Immutability**: Cubit state is immutable with copy methods

---

## Future Enhancement Opportunities

- [ ] Add unit and widget tests
- [ ] Implement task reminders/notifications
- [ ] Add task categories and tags
- [ ] Implement search functionality
- [ ] Add data export/import features
- [ ] Implement cloud sync
- [ ] Add user authentication
- [ ] Create data analytics/reports
- [ ] Add dark mode theme
- [ ] Implement task priority sorting

---

## Development Guidelines

### Adding a New Feature

1. **Model**: Define data structure in `/data/models`
2. **Database**: Add table/queries in `/data/databases`
3. **Repository**: Add data operations in `/data/repositories`
4. **Cubit**: Create state management in `/logic/cubits`
5. **UI**: Build screens/widgets in `/presentation`
6. **Localization**: Add strings to ARB files

### File Naming Conventions
- Snake case for files: `tasks_screen.dart`
- Pascal case for classes: `TasksScreen`
- Camel case for variables: `patientName`

---

## License & Credits

**Application**: MedBox - Medical Task Management
**Architecture**: Clean Architecture with BLoC
**Platform**: Flutter
**Database**: SQLite

---

*Documentation generated: December 2025*

