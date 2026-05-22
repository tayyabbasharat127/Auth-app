# Auth App - Flutter Assignment

## Project Title
Multi-Screen Flutter Authentication App with Course API CRUD Integration

## Student Information
- **Name:** Tayyab Basharat
- **Student ID:** SE-221048

## Branch
- `feature/course-api-integration`

## API Used
This project uses the JSONPlaceholder REST API for course data.

- Base URL: `https://jsonplaceholder.typicode.com`
- Course endpoint used: `/posts`
- Documentation followed: `https://jsonplaceholder.typicode.com/guide`

JSONPlaceholder uses `posts` fields as fake course data:

- `id` -> Course ID
- `title` -> Course title
- `body` -> Course description
- `userId` -> Course owner/user ID

JSONPlaceholder accepts `POST`, `PUT`, and `DELETE` requests, but it does not permanently save changes on the server. The app updates its local UI state after successful API responses.

## CRUD Features
- **Read:** Fetches courses using `GET /posts`
- **Create:** Adds a course using `POST /posts`
- **Update:** Edits course details using `PUT /posts/{id}`
- **Delete:** Removes a course using `DELETE /posts/{id}`
- Shows loading indicators during API work
- Shows retry/error UI when fetching fails
- Shows confirmation before deleting a course
- Pre-fills the edit form with the selected course data

## Architecture
- `CourseService` keeps REST API logic separate from UI
- `CourseModel` maps JSONPlaceholder data into app-friendly course data
- `DashboardScreen` handles course list state, loading, success, and errors
- `CourseFormScreen` is reused for adding and editing courses
- Existing authentication, validation, navigation, and session restore features are preserved

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

## Existing Auth Features
- Registration with validation
- Login with validation
- Remember Me using SharedPreferences
- Dashboard navigation
- Detail screen
- Logout

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Flutter SDK >= 3.0.0.

## Screenshots

Existing screenshots are included in the repository under `lib/Screenshots/`.

| Register | Login | Dashboard | Detail |
|----------|-------|-----------|--------|
| ![Register](lib/Screenshots/register.png.png) | ![Login](lib/Screenshots/login.png.png) | ![Dashboard](lib/Screenshots/dashboard.png.png) | ![Detail](lib/Screenshots/detail.png.png) |
