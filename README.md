# Auth App - Flutter Assignment

## Project Title
Multi-Screen Flutter Authentication Application

## Student Information
- **Name:** Tayyab Basharat
- **Student ID:** SE-221048

## Repository
- GitHub: `https://github.com/tayyabbasharat127/Auth-app.git`


## Project Overview
This Flutter project is a multi-screen authentication application with registration, login, dashboard, detail screen navigation, reusable validation, enum usage, and controller-based business logic separation.

The app also includes the course API CRUD extension using JSONPlaceholder for course data.

## Application Screens

### 1. Registration Screen
The registration screen contains a complete user registration form with real-time validation feedback.

Required fields:
- First Name
- Last Name
- Email Address
- Gender Selection using a dropdown menu
- Password
- Confirm Password

Password security rules:
- Minimum 6 characters
- At least 1 uppercase letter
- At least 1 special character

Validation behavior:
- Email must use a valid email format
- Confirm password must match the original password
- Errors are shown while the user fills the form
- Submit button remains disabled until the form is valid

After successful registration:
- A success message is shown
- User is navigated to the Login Screen

### 2. Login Screen
The login screen validates user credentials before allowing access to the dashboard.

Features:
- Email validation with error messages
- Password field with show/hide eye icon toggle
- Remember Me checkbox
- Basic session persistence using `SharedPreferences`

After successful login:
- User is navigated to the Dashboard Screen
- User data is passed to the dashboard

### 3. Dashboard Screen
The dashboard displays logged-in user information and course/subject data.

User information:
- User full name
- Email address
- Avatar placeholder using the user's first initial

Subject/course list:
- Mobile App Development
- Software Re-engineering
- Management Information Systems
- Database Management Systems

Functionality:
- Tap a course to open its detail screen
- Pass selected course data to the Detail Screen
- Logout button returns the user to the Login Screen
- Course list supports API-based read, create, update, and delete operations

### 4. Detail Screen
The detail screen presents selected course information.

Displayed information:
- Course name shown prominently
- Course banner/header area with placeholder icon
- Course description and objectives
- Relevant course/user ID details

## Core Development Requirements

### Form Validation
The application implements complete validation for all required input fields. Validation messages are shown in real time to provide immediate feedback.

### Custom Validator Class
Validation logic is separated from UI in `lib/utils/validators.dart`.

Validator methods include:
- Empty field validation
- Email validation
- Password validation
- Dropdown validation
- Confirm password validation

### Enum Implementation
Enums are used for:
- Gender selection
- Authentication state management
- Subject/category values

### Controller Layer Architecture
Business logic is separated from UI.

Controller/service files:
- `lib/controllers/auth_controller.dart` handles registration, login, logout, and session persistence
- `lib/services/course_service.dart` handles REST API calls for course CRUD operations

## Course API Extension
The app uses JSONPlaceholder for course API operations.

- Base URL: `https://jsonplaceholder.typicode.com`
- Endpoint: `/posts`
- Documentation followed: `https://jsonplaceholder.typicode.com/guide`

CRUD operations:
- Read courses using `GET /posts`
- Add course using `POST /posts`
- Update course using `PUT /posts/{id}`
- Delete course using `DELETE /posts/{id}`

JSONPlaceholder accepts create, update, and delete requests but does not permanently save changes on the server, so the app updates local UI state after successful responses.

## Project Structure

```text
lib/
+-- main.dart
+-- controllers/
|   +-- auth_controller.dart
+-- models/
|   +-- course_model.dart
|   +-- subject_model.dart
|   +-- user_model.dart
+-- screens/
|   +-- course_form_screen.dart
|   +-- dashboard_screen.dart
|   +-- detail_screen.dart
|   +-- login_screen.dart
|   +-- register_screen.dart
+-- services/
|   +-- course_service.dart
+-- utils/
|   +-- validators.dart
+-- widgets/
    +-- app_text_field.dart
```

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Flutter SDK >= 3.0.0.

## Screenshots

### Course API Screens

| Course Dashboard | Course Details |
|------------------|----------------|
| ![Course Dashboard](lib/Screenshots/course_api_run.png) | ![Course Details](lib/Screenshots/Course_details.png) |

### Authentication Screens

| Register | Login | Dashboard | Detail |
|----------|-------|-----------|--------|
| ![Register](lib/Screenshots/register.png.png) | ![Login](lib/Screenshots/login.png.png) | ![Dashboard](lib/Screenshots/dashboard.png.png) | ![Detail](lib/Screenshots/detail.png.png) |

## Submission Checklist
- Complete Flutter project source code
- GitHub repository link included
- Student name and ID included
- Screenshots included
- Project runs without errors

---

## Extension: Offline Cache, State Management & Repository Pattern

### Branch
`feature/offline-cache-and-state-manangement`

---

### Tools and Packages Used

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.2 | State management — `ChangeNotifier` + `Consumer` |
| `hive_flutter` | ^1.1.0 | Local persistent storage for offline course cache |
| `connectivity_plus` | ^6.0.0 | Runtime network connectivity detection |

---

### Architecture

This extension adopts a clean, layered architecture:

```
UI Layer  (Screens / Widgets)
    ↓  Consumer<CourseProvider>
State Layer  (CourseProvider — ChangeNotifier)
    ↓  calls
Repository Layer  (CourseRepository)
    ↓                          ↓
API Service               Local DataSource
(CourseService — HTTP)    (CourseLocalDataSource — Hive)
```

**File structure added:**

```text
lib/
+-- local/
|   +-- course_local_datasource.dart   ← Hive read/write helpers
+-- repositories/
|   +-- course_repository.dart         ← decides API vs cache
+-- providers/
    +-- course_provider.dart           ← ChangeNotifier state machine
```

**Separation of concerns:**
- `CourseService` — HTTP only, no knowledge of caching or UI
- `CourseLocalDataSource` — Hive box operations, no business logic
- `CourseRepository` — single decision point: online → API → cache; offline → cache
- `CourseProvider` — UI state (`CourseStatus` enum), optimistic mutations, search filter
- `DashboardScreen` — pure UI, reads state via `Consumer<CourseProvider>`

---

### Offline Support

When the app loads courses:

1. **Online path** — fetches from `JSONPlaceholder`, stores the result in Hive (`Box<dynamic>` as JSON string), returns fresh data.
2. **Offline path** — detects no connectivity via `connectivity_plus`, reads the Hive cache and returns stale data immediately.
3. **Fallback** — if online but the API request throws, the repository silently falls back to cache instead of propagating an error.

The `CourseProvider` sets an `isOffline` flag after each load. The dashboard displays a persistent orange banner when data is served from cache, with a **Retry** button that re-triggers synchronisation once the user regains connectivity.

Hive is initialised in `main()` before `runApp` so the box is always ready before the first widget build.

---

### State Management

`CourseProvider` (`ChangeNotifier`) manages the following states via a `CourseStatus` enum:

| State | Meaning |
|-------|---------|
| `initial` | Provider just created, no load attempted |
| `loading` | Fetch in progress |
| `success` | Courses loaded, list is non-empty |
| `empty` | Load succeeded but list is empty |
| `error` | Load failed and no cache available |

All CRUD actions use **optimistic UI updates**:
- The list is mutated immediately so the UI responds without waiting for the network.
- If the API call fails, the change is rolled back and an error snackbar is shown.
- `_busyCourseId` tracks which individual card shows its loading spinner.

`CourseProvider` is registered at the app root in `MultiProvider` inside `MyApp`, making it available to all routes without prop drilling.

---

### UX Improvements

- **Pull-to-refresh** — `RefreshIndicator` on the course list calls `loadCourses()`.
- **Live search / filter** — a `TextField` above the list filters courses by title or description in real time without additional API calls.
- **Offline banner** — orange bar at the top of the dashboard when serving cached data, with a Retry button.
- **Empty state** — dedicated illustration + message when no courses exist or no search results match.
- **Per-card busy indicator** — individual spinner on a card during edit/delete so other cards remain interactive.

---

### Screenshots

| Feature | Screenshot |
|---------|------------|
| Course Dashboard | ![Course Dashboard](lib/Screenshots/course_api_run.png) |
| Course Details | ![Course Details](lib/Screenshots/Course_details.png) |
