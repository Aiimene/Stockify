# StockiFy 📦

A comprehensive inventory and sales management Flutter application for retail businesses.

## Features

### 🏠 Dashboard
- Quick stats overview (Revenue, Orders, Products)
- Best-selling products display
- Low stock alerts
- Recent activity timeline
- Quick actions (Add Order, Add Product)

### 📊 Analytics
- Revenue trends with interactive charts
- Monthly comparisons
- Product performance metrics
- Visual data representation using FL Chart

### 🛍️ Sales Management
- Create new sales/orders with barcode scanning
- Manual product entry
- Shopping cart functionality
- Real-time inventory validation
- Order confirmation and receipt

### 📦 Product Management
- Comprehensive product listing with grid view
- Search and filter by price
- Add/Edit product details
- Image upload (Camera/Gallery)
- Barcode scanning for products
- Stock tracking
- Product details view with edit mode

### 📋 Orders
- View all orders with filtering
- Date range filtering
- Product-based filtering
- Order history with details

### 🔔 Notifications
- Low stock alerts
- Expiring product notifications
- Order notifications
- Swipe to delete
- Mark all as read functionality

### 👤 Authentication
- Welcome screen
- Login/Sign up functionality
- Form validation
- Password visibility toggles

## Tech Stack

- **Framework**: Flutter 3.9+
- **Language**: Dart
- **Dependencies**:
  - `fl_chart: ^0.69.0` - Charts and data visualization
  - `image_picker: ^1.0.7` - Camera and gallery image selection
  - `mobile_scanner: ^5.2.3` - Barcode/QR code scanning
  - `intl: ^0.19.0` - Internationalization and number formatting

## Project Structure

```
lib/
├── config/
│   └── routes.dart           # App routing configuration
├── screens/
│   ├── welcome_screen.dart   # Welcome/landing page
│   ├── login_screen.dart     # User login
│   ├── signup_screen.dart    # User registration
│   ├── main_navigation.dart  # Bottom navigation wrapper
│   ├── dashboard.dart        # Home dashboard
│   ├── analytics_screen.dart # Analytics and reports
│   ├── orders_screen.dart    # Orders management
│   ├── new_sale_screen.dart  # Create new sale
│   ├── product_list_screen.dart    # Product grid view
│   ├── add_product_screen.dart     # Add new product
│   ├── product_detail_screen.dart  # Product details
│   └── notifications_screen.dart   # Notifications center
├── widgets/
│   └── bottom_nav_bar.dart   # Custom bottom navigation
└── main.dart                 # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio with Flutter plugins

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd StockiFy/stockify
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Clean Build
If you encounter any issues, clean the build:
```bash
flutter clean
flutter pub get
flutter run
```

## Configuration

### Assets
Add your logo and product images to:
- `assets/images/logo.png`
- `assets/images/` (for product images)

Update `pubspec.yaml` to include assets:
```yaml
flutter:
  assets:
    - assets/images/
```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Permissions configured for camera and storage

#### iOS
- iOS 12.0+
- Camera usage description in Info.plist
- Photo library usage description configured

## Features in Detail

### Barcode Scanning
- Uses mobile_scanner package
- Torch toggle for low-light scanning
- Front/back camera switching
- Real-time barcode detection

### Image Handling
- Camera capture
- Gallery selection
- Multiple image support
- Preview thumbnails

### Data Persistence
Currently using in-memory data structures. Can be extended with:
- SQLite (sqflite)
- Hive
- Firebase Firestore
- REST API backend

## Navigation Structure

```
Welcome Screen
├── Login → Main Navigation
└── Sign Up → Main Navigation

Main Navigation (Bottom Nav)
├── Home (Dashboard)
├── Analytics
├── Orders
├── Products
└── Settings (Coming Soon)

Standalone Screens
├── Add Product
├── Product Detail
├── New Sale
└── Notifications
```

## Color Scheme

- **Primary**: #6366F1 (Indigo)
- **Accent**: #10B981 (Green)
- **Success**: #10B981 (Green)
- **Error**: #EF4444 (Red)
- **Warning**: #F59E0B (Amber)
- **Background**: #F5F5F5 (Light Grey)
- **Surface**: #FFFFFF (White)

## Contributing

This is a private project. For contributions or inquiries, please contact the project owner.

## License

All rights reserved.

## Support

For support, email your-email@example.com or create an issue in the repository.

---

**Note**: This app is designed for retail inventory management with a focus on cosmetics and beauty products, but can be adapted for any retail business.
