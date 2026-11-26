# BlogHub Authors

**BlogHub Authors** is a dedicated mobile application designed specifically for authors of the BlogHub publishing platform. While general readers interact through the Laravel-powered BlogHub website, this mobile app serves exclusively as an author workspace to draft, publish, and manage content, view reader feedback, and track performance on the go.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** [Dart](https://dart.dev/)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Routing:** [go_router](https://pub.dev/packages/go_router)
- **Backend API:** Laravel REST API *(Planned for subsequent phases)*

---

## 🚀 Main Features

Designed exclusively for authors:

- **Authentication:** Author Login and Registration.
- **Author Dashboard:** High-level overview of author activity, statistics, and post status.
- **Post Management:** Create, edit, and delete blog posts.
- **Comments:** View reader comments and engagement on published articles.
- **Profile:** Manage author bio, credentials, and profile details.
- **Settings:** Configure application preferences and account settings.

---

## 📌 Project Status & Roadmap

> **Current Status:** `Phase 1 - Frontend only (dummy data)`  
> All views and workflows currently utilize mock/dummy data. No backend or API connection is active yet.

### Development Roadmap

1. **Phase 1: Frontend Only (Dummy Data)** *(In Progress)*
   - Build all screens and user interface components.
   - Set up responsive layouts, theme, navigation, and state models using dummy data.
2. **Phase 2: Authentication & Laravel REST API Integration**
   - Connect to the existing Laravel REST API endpoints.
   - Implement secure token storage and session management.
3. **Phase 3: Testing & Quality Assurance**
   - Comprehensive unit testing for business logic and state providers.
   - Widget and integration testing for author workflows.
4. **Phase 4: Release & Deployment**
   - Build, optimize, and distribute application for mobile platforms.

---

## 📁 Folder Structure Overview

The project adheres to a **feature-first** architecture to keep code modular and prepare cleanly for future API integration:

```text
lib/
├── core/                  # Core configurations, constants, theme, and router
│   ├── constants/         # App-wide constants and strings
│   ├── routes/            # go_router configuration
│   ├── services/          # API clients and network services (Phase 2)
│   └── theme/             # Styling, colors, and typography
├── features/              # Feature-first modules
│   ├── auth/              # Login, register, and auth state
│   ├── dashboard/         # Author dashboard & statistics
│   ├── posts/             # Post listing, creation, editing, and deletion
│   ├── comments/          # Comments viewing screens and widgets
│   ├── profile/           # Author profile view and edit
│   └── settings/          # Application settings
├── shared/                # Shared widgets, models, and utilities across features
│   ├── models/            # Common domain models
│   └── widgets/           # Reusable UI components
└── main.dart              # Application entry point
```
*(Note: This tree outline will be maintained and updated as directory modules are created.)*

---

## 🏁 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:

- **Flutter SDK:** `>=3.0.0` ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Dart SDK:** Included with Flutter SDK
- **IDE:** Android Studio, VS Code, or IntelliJ IDEA with the Flutter/Dart extensions installed
- A running Android emulator, iOS simulator, or connected physical device

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd untitled
   ```

2. **Install project dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 📐 Contribution and Coding Rules

To maintain high code quality and maintainability across all phases:

- **Feature-First Structure:** Always place screens, controllers/providers, and widgets inside their respective feature folder under `lib/features/<feature_name>/`.
- **One Widget per File:** Every reusable or distinct widget must reside in its own dedicated file. Avoid multiple widget definitions in a single file.
- **Naming Conventions:**
  - **Files & Folders:** Use `snake_case` (e.g., `create_post_screen.dart`, `author_profile_card.dart`).
  - **Classes & Widgets:** Use `PascalCase` (e.g., `CreatePostScreen`, `PostProvider`).
  - **Variables & Functions:** Use `camelCase` (e.g., `fetchAuthorPosts`, `selectedPostId`).
  - **Constants:** Use `lowerCamelCase` or `SCREAMING_SNAKE_CASE` (consistent with Dart style guide).
- **API Readiness:** Keep dummy data models and services isolated so they can be seamlessly swapped with Laravel API client implementations in Phase 2.
