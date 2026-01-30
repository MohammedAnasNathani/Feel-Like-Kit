# Feel Like 💩 Kit

A body-first self-calming app designed to help users regulate their nervous system in moments of distress.

**Version:** 1.5 (Smart Logic Upgrade)  
**Platform:** iOS & Android  
**Framework:** Flutter

---

## Features

### Core Functionality
- **Mood Check-in:** 6 feeling states with intensity levels
- **Smart Tool Selection:** Personalized recommendations based on mood
- **Body-First Approach:** Sensory tools, breathing, grounding, movement
- **Optional Add-Ons:** Visualization, thought check, journaling
- **Eli Guide:** Contextual support character throughout the journey
- **Crisis Resources:** Always accessible safety options

### V1.5 Smart Logic
- Mood-based tool recommendations
- Dynamic add-on routing
- Eli's contextual messages per mood/screen
- Hundreds of unique session paths

---

## Getting Started

### Prerequisites
- Flutter SDK 3.x stable
- For iOS: macOS with Xcode
- For Android: Android SDK

### Installation
```bash
# Clone repository
git clone https://github.com/MohammedAnasNathani/Feel-Like-Kit.git

# Navigate to project
cd feel_like_kit

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

---

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── providers/                # State management
├── screens/                  # All 17 screens (S0-S16)
├── services/                 # Smart routing & storage
├── theme/                    # Colors, typography, theming
└── widgets/                  # Reusable components
```

---

## App Flow

```
S0 Disclaimer → S1 Feeling → S2 Intensity → [S3 Safety] → S4 Tools → 
S5 Use Tool → S6 Breathing → S7 Grounding → S8 Add-Ons → 
[S9-S12 Optional] → S13 Sustain → S14 Reflect → S15 Completion
```

---

## Design Principles

- One decision per screen
- No scrolling during Calm Mode
- Large tap targets (48px+)
- Calm, non-clinical language
- Offline-only operation
- No accounts or backend required

---

## License

Proprietary - STL Mental Health

---

## Support

For issues or questions, contact the development team.
