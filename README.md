# Litera - Book Management Admin Dashboard

A modern Flutter application for managing book products, categories, and inventory through an intuitive admin dashboard. Built with Material 3 design principles and GetX state management for seamless user experience.

## Overview

Litera is an admin dashboard application designed to streamline book product management. It provides a comprehensive interface for managing product catalogs, handling file uploads (images and PDFs), inventory tracking, and category organization with real-time updates and form validation.

## Features

- **Product Management**
  - Create, read, update, and delete book products
  - Detailed product forms with multi-field validation
  - Real-time inventory tracking
  - Category-based organization

- **File Management**
  - Upload and manage product cover images (JPG, PNG)
  - PDF file upload and replacement for book content
  - File size validation and warnings
  - Preview functionality for uploaded files

- **Admin Dashboard**
  - Product listing with search and filter capabilities
  - Advanced filtering by category and stock status
  - Sorting options for better data organization
  - Visual product cards with quick actions

- **UI/UX**
  - Material 3 design system with consistent styling
  - Responsive layout optimized for mobile
  - Clean, modern form interfaces with proper validation
  - Intuitive navigation and action buttons

- **Data Management**
  - Form validation for required fields
  - Currency formatting for pricing (Rupiah support)
  - Date picker for publication dates
  - Dropdown selection for categories

## Tech Stack

- **Framework**: Flutter 3.x+
- **State Management**: GetX
- **Design System**: Material 3
- **Local Database**: SharedPreferences (caching)
- **File Handling**: file_picker, image_picker
- **Date/Time**: intl
- **Build System**: Gradle (Android), CocoaPods (iOS)

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK (comes with Flutter)
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone <https://github.com/nivyanbl/litera_app.git>
   cd litera_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Android Setup** (if developing for Android)
   ```bash
   cd android
   ./gradlew build
   cd ..
   ```

### Running the Project

1. **Ensure a device/emulator is running**

   ```bash
   flutter devices
   ```

2. **Run the app**

   ```bash
   flutter run
   ```

3. **Run in release mode** (for production build)

   ```bash
   flutter run --release
   ```

4. **Build APK** (Android)

   ```bash
   flutter build apk --release
   ```

5. **Build IPA** (iOS)
   ```bash
   flutter build ios --release
   ```

## Project Structure

```
litera_app/
├── lib/
│   ├── app/
│   │   ├── core/              # Core utilities, theme, widgets
│   │   │   ├── theme/         # AppColors, AppTheme
│   │   │   └── widgets/       # CustomAppBar, CustomButton, CustomTextField
│   │   ├── data/              # Models and API integration
│   │   │   └── models/        # CategoryModel, ProductModel
│   │   ├── features/
│   │   │   ├── admin/         # Admin-specific features
│   │   │   │   ├── admin_dashboard/
│   │   │   │   ├── admin_produk/  # Product management views & controllers
│   │   │   │   │   ├── views/
│   │   │   │   │   ├── controllers/
│   │   │   │   │   └── widgets/
│   │   │   └── ...
│   │   └── main.dart          # App entry point
│   ├── assets/                # Images, fonts, static files
│   └── pubspec.yaml          # Dependencies and configuration
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── web/                       # Web platform code (if applicable)
└── README.md
```

## Admin Access

Use the credentials below to access the admin dashboard:

| Field        | Value            |
| ------------ | ---------------- |
| **Email**    | `bos@litera.com` |
| **Password** | `litera123`      |

Or copy from the code block:

```
Email: bos@litera.com
Password: litera123
```

## Code Quality & Standards

- **Architecture**: Clean architecture with clear separation of concerns
- **State Management**: GetX for reactive state management
- **Design System**: Consistent use of AppColors and Material 3 components
- **Validation**: Form validation on all user inputs
- **Error Handling**: Proper error messages and user feedback

## Common Commands

| Command               | Description              |
| --------------------- | ------------------------ |
| `flutter pub get`     | Install dependencies     |
| `flutter pub upgrade` | Upgrade dependencies     |
| `flutter clean`       | Clean build artifacts    |
| `flutter analyze`     | Analyze code for issues  |
| `flutter format .`    | Format code to standards |

## Important Notes

- **File Upload Limits**
  - Images: Maximum 2 MB
  - PDFs: Recommended max 10 MB
  - Validation occurs on file selection

- **Form Validation**
  - All marked fields (\*) are required
  - Price must be a positive number
  - PDF is required for new products
  - Category selection is mandatory

- **Localization**
  - Date format: `dd MMM yyyy` (Indonesian locale)
  - Currency format: Indonesian Rupiah (Rp)

- **Dependencies**
  - Ensure Flutter SDK is up to date
  - Clear cache if encountering build issues: `flutter clean && flutter pub get`
  - Run `flutter pub upgrade` periodically to stay current

## Troubleshooting

- **Build Errors**: Run `flutter clean` followed by `flutter pub get`
- **Hot Reload Issues**: Use `flutter run` instead of hot reload for complex state changes
- **File Upload Not Working**: Check Android and iOS file permissions in native configuration
- **Form Validation Not Showing**: Ensure Form key is passed to all form-based widgets

## Support & Contribution

For issues, questions, or contributions, please contact the development team or submit a pull request.

---

**Last Updated**: April 2026  
**Version**: 1.0.0  
**License**: All Rights Reserved
