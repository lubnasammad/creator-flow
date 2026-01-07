# Creator Flow 🎬

**Creator Flow** is a Flutter mobile application designed specifically for content creators to manage their schedules, collaborations, and workflows entirely offline. With zero internet dependency and no Firebase integration, all your data stays secure on your device.

## ✨ Features

### 📅 Schedule Management
- **Shooting Schedules**: Plan and track your content creation sessions with date, location, and notes
- **Posting Schedules**: Organize your content posting timeline across multiple platforms (Instagram, YouTube, TikTok, Facebook, Twitter)
- **Calendar Integration**: Beautiful calendar view with weekly and monthly modes using `table_calendar`
- **Quick Actions**: Fast access to add new schedules from the dashboard

### 🤝 Collaboration Management
- **Brand Collaborations**: Track paid partnerships with payment amounts, contract dates, and status tracking
- **Barter Collaborations**: Manage product exchange deals with estimated value tracking
- **Status Tracking**: Monitor collaboration progress (Pending, Active, Completed, Cancelled)

### 📊 List Views & Organization
- **Comprehensive List Screens**: View all schedules and collaborations in organized, scrollable lists
- **Platform-Specific Styling**: Visual indicators for different platforms (Instagram, YouTube, etc.)
- **Swipe to Delete**: Quick gesture-based deletion with confirmation dialogs
- **Tap to Edit**: Instant access to edit any schedule or collaboration

### 🔐 Security & Authentication
- **Secure Login System**: SHA-256 password hashing with crypto package
- **Session Management**: Persistent login using SharedPreferences
- **User Isolation**: All data is scoped to individual users

### 💾 Offline-First Architecture
- **SQLite Database**: All data stored locally using sqflite package
- **No Internet Required**: Works completely offline
- **No Firebase**: Zero cloud dependencies for maximum privacy
- **Instant Performance**: No network latency, instant data access

## 🛠️ Technology Stack

### Core Framework
- **Flutter SDK**: 3.10.4+ with Material 3 design system
- **Dart Language**: Latest stable version with strict linting

### Key Dependencies
```yaml
dependencies:
  sqflite: ^2.4.1           # SQLite database for offline storage
  path: ^1.9.1              # Path manipulation for database files
  intl: ^0.20.2             # Date/time formatting
  table_calendar: ^3.1.2    # Beautiful calendar UI component
  crypto: ^3.0.6            # SHA-256 password hashing
  shared_preferences: ^2.3.4 # Session management
```

### Development Tools
- **analysis_options.yaml**: Strict linting rules enforcing zero warnings
- **Git**: Version control with structured commit messages

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point with Material 3 theme
├── models/                        # Data models with toMap/fromMap
│   ├── user.dart
│   ├── shooting_schedule.dart
│   ├── posting_schedule.dart
│   ├── brand_collaboration.dart
│   └── barter_collaboration.dart
├── services/                      # Business logic and database services
│   ├── database_helper.dart       # SQLite initialization
│   ├── auth_service.dart          # Authentication with SHA-256
│   ├── session_manager.dart       # SharedPreferences session handling
│   ├── shooting_schedule_service.dart
│   ├── posting_schedule_service.dart
│   ├── brand_collaboration_service.dart
│   └── barter_collaboration_service.dart
├── screens/                       # UI screens
│   ├── login_screen.dart          # Login/Register with validation
│   ├── dashboard_screen.dart      # Calendar view and quick actions
│   ├── add_shooting_screen.dart   # Create/Edit shooting schedules
│   ├── add_posting_screen.dart    # Create/Edit posting schedules
│   ├── add_brand_screen.dart      # Create/Edit brand collaborations
│   ├── add_barter_screen.dart     # Create/Edit barter deals
│   ├── shooting_list_screen.dart  # View all shooting schedules
│   ├── posting_list_screen.dart   # View all posting schedules
│   ├── brand_list_screen.dart     # View all brand collaborations
│   └── barter_list_screen.dart    # View all barter collaborations
└── utils/                         # Helper utilities
    └── date_utils.dart            # Date formatting functions
```

## 💾 Database Schema

### Tables
1. **users** - User accounts with hashed passwords
   - `id` (INTEGER PRIMARY KEY)
   - `username` (TEXT UNIQUE)
   - `password_hash` (TEXT)
   - `created_at` (TEXT)

2. **shooting_schedule** - Content shooting plans
   - `id` (INTEGER PRIMARY KEY)
   - `user_id` (INTEGER, FK to users)
   - `title` (TEXT)
   - `description` (TEXT)
   - `shooting_date` (TEXT)
   - `location` (TEXT)
   - `status` (TEXT: Pending/Completed/Cancelled)
   - `created_at` (TEXT)

3. **posting_schedule** - Platform posting timelines
   - `id` (INTEGER PRIMARY KEY)
   - `user_id` (INTEGER, FK to users)
   - `title` (TEXT)
   - `description` (TEXT)
   - `post_date` (TEXT)
   - `platform` (TEXT: Instagram/YouTube/TikTok/Facebook/Twitter)
   - `status` (TEXT: Scheduled/Posted/Cancelled)
   - `created_at` (TEXT)

4. **brand_collaboration** - Paid partnerships
   - `id` (INTEGER PRIMARY KEY)
   - `user_id` (INTEGER, FK to users)
   - `brand_name` (TEXT)
   - `description` (TEXT)
   - `payment` (REAL)
   - `start_date` (TEXT)
   - `end_date` (TEXT)
   - `status` (TEXT: Pending/Active/Completed/Cancelled)
   - `created_at` (TEXT)

5. **barter_collaboration** - Product exchange deals
   - `id` (INTEGER PRIMARY KEY)
   - `user_id` (INTEGER, FK to users)
   - `brand_name` (TEXT)
   - `description` (TEXT)
   - `product_value` (REAL)
   - `start_date` (TEXT)
   - `end_date` (TEXT)
   - `status` (TEXT: Pending/Active/Completed/Cancelled)
   - `created_at` (TEXT)

All foreign keys use `ON DELETE CASCADE` to maintain referential integrity.

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK 3.10.4 or higher
- Dart SDK (comes with Flutter)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator for testing

### Steps
1. **Clone the repository**
   ```bash
   git clone https://github.com/lubnasammad/creator-flow.git
   cd creator-flow
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code analysis** (should show ZERO issues)
   ```bash
   flutter analyze
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🎨 Design System

### Material 3
- Dynamic color theming with seed color: Purple (`Colors.deepPurple`)
- Light and dark mode support
- Elevated cards with 12px border radius
- Consistent spacing: 8px, 12px, 16px, 24px
- Typography: Material 3 text styles with proper hierarchy

### Color Palette
- **Primary**: Deep Purple (brand identity)
- **Shooting**: Purple
- **Posting**: Blue
- **Brand Collab**: Orange
- **Barter Collab**: Teal

### UI Components
- Floating Action Button (FAB) with extended label
- Bottom Navigation Bar with Calendar and Lists tabs
- Modal Bottom Sheets for quick add menus
- Form validation with real-time feedback
- Date pickers with Material 3 styling
- Dismissible list items with swipe gestures

## 📱 App Flow

1. **Launch** → Check session → Dashboard or Login
2. **Login/Register** → SHA-256 hashing → Save session → Dashboard
3. **Dashboard**:
   - Calendar tab: Weekly/monthly views with schedule markers
   - Lists tab: Navigate to specific list screens
   - FAB: Quick add menu for all types
   - Quick action cards: Direct navigation to add screens
4. **Add/Edit Screens**: Form validation → Save to SQLite → Return with result
5. **List Screens**: Swipe to delete → Tap to edit → FAB to add new

## 🔒 Code Quality Standards

### Zero Warnings Policy
Every commit passes `flutter analyze` with **ZERO errors, warnings, or info messages**.

### Linting Rules
- `prefer_const_constructors` - Optimize widget rebuilds
- `prefer_single_quotes` - Consistent string formatting
- `require_trailing_commas` - Better formatting and diffs
- `prefer_final_fields` - Immutability where possible
- `unused_import` - Clean imports
- `unused_element` - No dead code

### Git Workflow
- Structured commit messages with issue references
- Each feature committed separately with `Closes #X`
- Branches: `main` (stable, production-ready code)

## 📝 License

This project is open source and available for educational purposes.

## 👥 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Ensure `flutter analyze` passes with zero issues
4. Commit changes (`git commit -m 'Add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📧 Contact

**Repository**: [github.com/lubnasammad/creator-flow](https://github.com/lubnasammad/creator-flow)

---

Built with ❤️ using Flutter and Material 3 Design
