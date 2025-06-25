# 🎯 FlutterCon App

A beautiful Flutter conference app showcasing sessions, speakers, and schedule with advanced favoriting functionality.

## ✨ Features

- **📅 Conference Schedule** - View sessions organized by timeslots
- **👥 Speaker Profiles** - Detailed speaker information and bios
- **❤️ Favorites System** - Save your favorite sessions with persistence
- **🎨 Beautiful UI** - Gradient backgrounds and smooth animations
- **📱 Responsive Design** - Works on mobile, tablet, and desktop
- **🔄 Auto-deployment** - Continuous deployment to GitHub Pages

## 🚀 Live Demo

Visit the live app: `https://<your-username>.github.io/fluttercon_app/`

## 🛠️ Development Setup

### Prerequisites
- Flutter SDK (managed via FVM)
- Dart SDK
- Web browser for testing

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd fluttercon_app
   ```

2. **Setup FVM (recommended)**
   ```bash
   dart pub global activate fvm
   fvm install
   fvm use
   ```

3. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

4. **Run the app**
   ```bash
   # For web
   fvm flutter run -d chrome
   
   # For mobile (with simulator/device connected)
   fvm flutter run
   ```

## 🏗️ Architecture

This app follows clean architecture principles with:

- **Modular Structure** - Organized by features (`dashboard`, `details`, `shared`)
- **Riverpod State Management** - Reactive state management
- **Service Layer** - Data persistence and API abstraction
- **Provider Pattern** - Clean separation of concerns
- **Responsive Widgets** - Adaptive UI components

## 📦 Key Dependencies

- `flutter_riverpod` - State management
- `shared_preferences` - Local data persistence
- Asset-based data loading (JSON files)

## 🚀 Deployment

This app automatically deploys to GitHub Pages using GitHub Actions.

**Setup Instructions:**
1. Enable GitHub Pages in repository settings
2. Set source to "GitHub Actions"
3. Push to main branch
4. See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions

## 🎨 Features Showcase

### Favorites System
- **Animated heart button** with elastic bounce effects
- **Persistent storage** using SharedPreferences
- **Smart sorting** - favorites appear first in timeslots
- **Gradient backgrounds** for favorited sessions
- **Dedicated favorites screen** with beautiful empty state

### UI/UX Highlights
- **Smooth animations** for all interactions
- **Snackbar confirmations** with emojis
- **Badge notifications** showing favorites count
- **Responsive design** for all screen sizes

## 📱 Screenshots

- Dashboard with session cards and gradient backgrounds
- Animated favorite buttons with heart icons
- Beautiful favorites screen with empty state
- Session detail pages with full speaker information

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Flutter and deployed with GitHub Actions**
