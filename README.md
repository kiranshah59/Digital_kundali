# Digital Kundali

A modern, beautifully designed Flutter application offering personalized astrological readings, birth charts, and AI-powered life analysis based on precise astronomical data.

## 🌟 Features

*   **Dynamic Onboarding Experience:** 
    *   Smooth, interactive swipe transitions.
    *   Static, overlay-based bottom navigation with clickable page indicators.
    *   Automatic splash screen transitioning.
*   **Authentication & Security:** 
    *   Secure Login and Sign-Up flows.
    *   Input validation and token-based session management.
    *   Secure local caching for persistent login states.
*   **Birth Profile Management:** 
    *   Create and manage multiple birth profiles.
    *   Isolated local storage caching tied specifically to the logged-in user account.
    *   Integration with backend APIs for real-time validation and limit handling.
*   **Modern UI/UX:** 
    *   Premium design aesthetics using curated color palettes (Gold/Off-White/Black).
    *   Custom SVG icons and elegant typography (Georgia/Inter).

## 🛠️ Tech Stack

*   **Framework:** [Flutter](https://flutter.dev/) (Dart)
*   **State Management:** Local StatefulWidgets & Singleton Services
*   **API & Networking:** `http` package for backend communication
*   **Local Storage:** `shared_preferences` for isolated caching
*   **UI Helpers:** `flutter_screenutil` (responsive sizing), `flutter_svg` (vector graphics), `google_fonts`

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.16 or higher)
*   Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kiranshah59/Digital_kundali.git
   ```
2. Navigate to the project directory:
   ```bash
   cd digital_kundali_app
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📁 Project Structure

*   `lib/core/services/` - Contains the business logic, API calls, and local storage handlers (e.g., `AuthService`, `ProfileService`).
*   `lib/screens/` - Contains all the UI screens divided by features:
    *   `/authentication` - Login and Sign Up screens.
    *   `/onboarding` - The dynamic PageView onboarding flow and splash screen.
    *   `/home` - Dashboard and main user interface.
    *   `/kundali` - Birth chart detail and input screens.
*   `lib/widgets/` - Reusable UI components.

## ⚙️ Backend Integration Note
The app expects the backend to scope birth profile limits locally to the `user_id` rather than globally across the database. Ensure the backend API routes correctly validate tokens and user scope.
