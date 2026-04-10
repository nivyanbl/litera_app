# Litera - Book Management Platform

A modern Flutter application for managing book products, categories, and inventory through an intuitive admin dashboard. Built with Material 3 design principles and GetX state management for seamless user experience.

## Overview

Litera is a comprehensive book management platform that provides separate interfaces for administrators and users. The application enables efficient product management, inventory tracking, file handling, and catalog organization with real-time updates and robust form validation.

## Features

### 👨‍💼 Admin Features

- **Product Management**
  - Create, read, update, and delete book products
  - Detailed product forms with comprehensive field validation
  - Real-time inventory tracking
  - Category-based product organization

- **File Management**
  - Upload and manage product cover images (JPG, PNG, max 2 MB)
  - PDF file upload for book content (max 10 MB recommended)
  - File size validation and user warnings
  - Preview functionality for uploaded files

- **Dashboard & Analytics**
  - Product listing with advanced search capabilities
  - Filtering by category and stock status
  - Multiple sorting options for better data organization
  - Visual product cards with quick action buttons

- **Inventory Control**
  - Monitor stock levels in real-time
  - Update pricing and availability
  - Track product categories
  - Manage publication details and metadata

### 👤 User Features

- **Browse Catalog** _(when user module is enabled)_
  - View available book products
  - Filter and search functionality
  - Product details and information
  - User account management

---

## User Roles

### 👨‍💼 Admin

Administrators have full control over the platform:

- **Manage Products**: Create, edit, and delete book listings
- **Handle Files**: Upload images and PDF content
- **Control Inventory**: Track and update stock levels
- **Organize Content**: Manage categories and product metadata
- **Access Analytics**: View product and inventory information

### 👤 User

Users interact with the platform as customers (when enabled):

- **Browse Products**: View available books
- **Search & Filter**: Find books by category or keywords
- **View Details**: Access complete product information
- **Account Management**: Manage user profile and preferences

---

## User Journey

### Step-by-Step User Flow

1. **Login**
   - Enter email and password
   - Access user dashboard

2. **Browse Books**
   - View catalog with all available books
   - See book covers, titles, and basic info

3. **Filter & Search**
   - Filter by category, author, or price
   - Search for specific books or keywords
   - Sort by newest, popular, or price

4. **View Book Details**
   - Click on a book to see full details
   - Read description, author info, and reviews
   - Check availability and pricing

5. **Manage Account**
   - Update profile information
   - Change password
   - View order/wishlist history
   - Manage preferences

---

## Tech Stack

- **Framework**: Flutter 3.13+
- **State Management**: GetX 4.6+
- **Design System**: Material 3
- **Local Storage**: SharedPreferences 2.2+
- **File Handling**: file_picker 6.1+, image_picker 1.0+
- **Date/Time**: intl 0.19+
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
   git clone https://github.com/nivyanbl/litera_app.git
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

## Demo Accounts

### 👨‍💼 Admin Account

Use these credentials to access the admin dashboard:

```
Email:    bos@litera.com
Password: litera123
```

| Field        | Credential       |
| ------------ | ---------------- |
| **Email**    | `bos@litera.com` |
| **Password** | `litera123`      |

### 👤 User Account

Use these credentials to access the user/customer interface:

```
Email:    user@litera.com
Password: user123
```

| Field        | Credential        |
| ------------ | ----------------- |
| **Email**    | `user@litera.com` |
| **Password** | `user123`         |

---


## Important Notes

### File Upload Limits

- **Images**: Maximum 2 MB (JPG, PNG formats)
- **PDFs**: Recommended maximum 10 MB
- **Validation**: Occurs automatically on file selection

### Form Validation

- All fields marked with `*` are required
- Price must be a positive number in Rupiah format
- PDF file is mandatory for new products
- Category selection is required for all products

### Localization & Formatting

- **Date Format**: `dd MMM yyyy` (Indonesian locale)
- **Currency**: Indonesian Rupiah (Rp)
- **Language**: Indonesian

---

**Last Updated**: April 2026  
**Version**: 1.0.0  
**License**: All Rights Reserved
