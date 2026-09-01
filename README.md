<div align="center">
  <h1>✨ Digital Kundali</h1>
  <p><strong>Astronomical Precision Meets AI-Powered Astrological Guidance</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Architecture-Service%20Oriented-success" alt="Architecture" />
    <img src="https://img.shields.io/badge/UI-Responsive-orange" alt="Responsive" />
  </p>
</div>

<br />

## 📖 Overview

**Digital Kundali** is a premium, cross-platform mobile application built with Flutter. It revolutionizes the way users interact with Vedic astrology by combining **real orbital mechanics** and **AI-driven insights**. The application eschews mystical jargon in favor of grounded, plain-English readings tailored for career, relationships, and personal growth.

With a focus on luxury aesthetics and seamless user experience, Digital Kundali offers a fluid onboarding journey, highly secure authentication, and robust birth profile management.

---

## ✨ Key Features

### 🎨 Premium User Experience
*   **Dynamic Onboarding Flow**: A seamlessly choreographed, swipe-driven introductory experience featuring dynamic page indicators and smooth cross-fading overlays.
*   **Curated Aesthetics**: A meticulously designed interface utilizing a sophisticated palette (Gold, Off-White, Obsidian) alongside elegant typography (Georgia & Inter).
*   **Micro-interactions**: Subtle tactile feedback and state-driven animations for intuitive navigation.

### 🔐 Robust Security & Authentication
*   **Secure Session Management**: Token-based authentication flow ensuring secure access to personal data.
*   **Isolated Data Architecture**: Local caching of birth profiles is strictly bound to the authenticated `user_id`, guaranteeing cross-account data privacy on shared devices.

### 📊 Advanced Profile Management
*   **Multi-Profile Support**: Seamlessly create, manage, and switch between multiple astrological birth profiles.
*   **Real-time Synchronization**: Instantaneous bidirectional syncing with the backend architecture, featuring intelligent limit-handling and validation.

---

## 🏗️ Technical Architecture

The application follows a **Service-Oriented Architecture** ensuring clear separation of concerns, scalability, and maintainability.

### Tech Stack
*   **Frontend Framework**: Flutter (Dart)
*   **Networking**: `http` (RESTful API Integration)
*   **Persistent Storage**: `shared_preferences` (Secure Local Caching)
*   **UI/UX Dependencies**: 
    *   `flutter_screenutil` (Adaptive and responsive layout rendering)
    *   `flutter_svg` (High-performance vector rendering)
    *   `google_fonts` (Dynamic typography injection)

### Directory Structure

```text
lib/
├── core/
│   ├── services/       # Business logic & API communication (AuthService, ProfileService)
│   └── constants/      # App-wide theme variables, API endpoints, and configuration
├── screens/
│   ├── splash/         # Entry point and intelligent routing
│   ├── onboarding/     # Complex PageView controllers and dynamic overlays
│   ├── authentication/ # Login, Registration, and Token validation
│   ├── home/           # Main Dashboard and stateful navigation
│   └── kundali/        # Birth chart visualization and AI-insight rendering
├── widgets/            # Modular, reusable UI components (Buttons, Cards, Inputs)
└── main.dart           # Application root and dependency initialization
```



---


