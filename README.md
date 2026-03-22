# ✈️ ANIMA — The Aero Club
### Flutter App

A fully-featured club management app for ANIMA Aero Club — built with Flutter, beautiful dark/light theme, Lottie animations, and full backend integration scope.

---

## 🚀 Quick Setup

### 1. Prerequisites
- Flutter SDK ≥ 3.10.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code with Flutter plugin

### 2. Clone & Install
```bash
cd anima_aero_club
flutter pub get
```

### 3. Add Your Lottie File
Place your `Aero plane.lottie` file at:
```
assets/lottie/airplane.lottie
```
Then update references in `auth_screen.dart` and `home_screen.dart`:
```dart
// Replace Lottie.network(...) with:
Lottie.asset('assets/lottie/airplane.lottie', ...)
```

### 4. Add Fonts
Download **Bebas Neue** from Google Fonts and place at:
```
assets/fonts/BebasNeue-Regular.ttf
```

### 5. Run
```bash
flutter run
```

---

## 📱 Features

### 🔐 Auth System
| Role | Email | Password | Permissions |
|------|-------|----------|-------------|
| Admin | admin@anima.aero | admin123 | Full access |
| R&D | rd@anima.aero | rd123 | Publish research |
| Treasurer | treasurer@anima.aero | treas123 | Manage expenses |
| Member | member@anima.aero | member123 | View + upload gallery |

### 🏠 Home Dashboard
- Personalized welcome with role badge
- Live weather/conditions bar  
- Club stats: publications, expenses, projects, gallery count
- Recent R&D publications preview
- Aircraft carousel

### 🔬 R&D Section
- Publish research papers with title, abstract, full content
- Tag-based filtering
- Role-protected publishing (R&D team + Admin only)
- Full paper detail view

### 💰 Treasury
- Expense tracking with categories
- Pie chart breakdown by category
- Category filtering
- Role-protected entry (Treasurer + Admin only)
- INR formatting

### ✈️ Aircraft Projects  
- Add planes with name, type, description, specs table
- Multiple image URLs per project
- Status badges (Active / Testing / In Build / Retired)
- Swipeable image gallery in detail view

### 🖼️ Gallery
- Grid photo gallery with staggered animations
- Tag filtering
- Photo detail dialog
- Long-press to delete (owner or admin)
- FAB upload button

### 🌗 Theme
- Seamless dark/light toggle
- Persisted in SharedPreferences
- Full system UI sync (status bar, nav bar)
- All colors from CSS-variable-style system

---

## 🔧 Backend Integration

Edit `lib/services/api_service.dart`:

```dart
static const String BASE_URL = 'https://your-backend.com/api/v1';
```

The `ApiService` class is fully wired with Dio. To switch from local storage to backend:

1. In `AuthProvider`, replace the `login()`/`signup()` bodies with `ApiService().login(...)` calls
2. In `DataProvider`, replace SharedPreferences reads/writes with `ApiService().*` calls
3. The REST API spec is documented at the bottom of `api_service.dart`

### Expected Endpoints
```
POST   /api/v1/auth/login
POST   /api/v1/auth/signup
POST   /api/v1/auth/logout

GET    /api/v1/publications
POST   /api/v1/publications
DELETE /api/v1/publications/:id

GET    /api/v1/expenses
POST   /api/v1/expenses
DELETE /api/v1/expenses/:id

GET    /api/v1/projects
POST   /api/v1/projects
DELETE /api/v1/projects/:id

GET    /api/v1/gallery
POST   /api/v1/gallery
DELETE /api/v1/gallery/:id
POST   /api/v1/uploads/image
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `lottie` | Lottie animations |
| `animate_do` | Fade/slide/zoom animations |
| `flutter_staggered_animations` | Staggered list/grid animations |
| `fl_chart` | Expense pie chart |
| `google_fonts` | Outfit font |
| `shared_preferences` | Local persistence |
| `dio` | HTTP client (backend-ready) |
| `hive_flutter` | Local DB (optional) |
| `font_awesome_flutter` | Extended icons |
| `shimmer` | Loading skeletons |
| `intl` | Date & number formatting |

---

## 🗂️ Project Structure

```
lib/
├── main.dart                  # App entry point
├── theme/
│   └── app_theme.dart         # Dark & light themes + colors
├── models/
│   └── models.dart            # AppUser, RDPublication, Expense, etc.
├── providers/
│   ├── auth_provider.dart     # Login/signup state
│   ├── data_provider.dart     # All club data state
│   └── theme_provider.dart    # Dark/light toggle
├── services/
│   └── api_service.dart       # Backend HTTP layer (Dio)
├── widgets/
│   └── app_widgets.dart       # GlowButton, GlassCard, StatCard, etc.
└── screens/
    ├── auth_screen.dart        # Login + Signup
    ├── main_shell.dart         # Bottom nav + drawer
    ├── home_screen.dart        # Dashboard
    ├── rd_screen.dart          # R&D publications
    ├── treasury_screen.dart    # Expenses + chart
    ├── projects_screen.dart    # Aircraft projects
    └── gallery_screen.dart     # Photo gallery
```

---

## ✨ Design System

- **Font**: Bebas Neue (display) + Outfit (body)
- **Dark bg**: `#0A0E1A` → `#0D1628` → `#111827`
- **Light bg**: `#F0F7FF` → `#DBEAFE`
- **Accent**: Cyan `#00D4FF` · Orange `#FF6B35` · Purple `#7C3AED` · Gold `#F59E0B`
- **Cards**: Glassmorphism with animated star background (dark mode)
- **Animations**: FadeInUp/Down/Left/Right, staggered lists, scale, slide transitions

---

*Built with ❤️ for ANIMA Aero Club, Guwahati*
