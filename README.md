# CHITRAL SHOP — Futuristic 3D Multi-Vendor Marketplace
**Developer credit: By Rahmat**

A high-performance, futuristic 3D marketplace launching in Chitral, Pakistan. Built to celebrate and trade authentic handcrafted mountain heritage—including traditional Chitrali Pakol caps, hand-spun Patti wool Chugha shawls, wild Chilgoza pine nuts, mountain flora honey, and untreated Hindu Kush gemstones.

---

## 1. Visual & Interactive Identity
- **Futuristic Dark Palette**: Deep navy (`#070B19`, `#0D142E`), electric cyan (`#00F0FF`), neon violet (`#8B5CF6`), and gold accents (`#FBBF24`).
- **Flowing Animated Backgrounds**: Custom canvas painters rendering glowing orbs and floating micro-particles.
- **3D Tilt Perspective Cards (`Tilt3DCard`)**: Matrix4 perspective transforms (`entry(3, 2, 0.0015)`) responding to touch drag gestures with specular lighting reflections.
- **Micro-Interactions**: Haptic ripple feedback, animated cart badges, and glowing borders.

---

## 2. Dynamic Trending Engine (Real Purchase Signals)
Products rise to the top based on a mathematically documented scoring formula:

$$\text{Score} = 35\% \cdot \ln(1 + \text{Orders}_{7d}) + 25\% \cdot \ln(1 + \text{Units}) + 15\% \cdot \text{BuyerRatio} + 10\% \cdot \text{ConvRate} + 10\% \cdot \text{RatingQuality} + 5\% \cdot \ln(1 + \text{Engagement}) - \text{Penalty}$$

- **Anti-Sybil Protection**: Dampens repeat orders from identical user IDs.
- **Return & Cancellation Penalty**: Deducts points for fraudulent or refunded purchases.
- **Stock Depletion Fallback**: Suppresses out-of-stock items from top trending slots.

---

## 3. Multi-Vendor & Admin Architecture
- **Multi-Vendor Dashboard (`SellerDashboardScreen`)**: Real-time sales statistics, inventory tracking, and new craft listing submissions.
- **Marketplace Super Admin (`AdminDashboardScreen`)**: Role-based access control, artisan shop verification workflows, and trending engine health monitoring.
- **Location Selector**: Native dropdown serving Chitral Town, Booni, Drosh, Kalash Valley, and Garam Chashma.
- **Cart & Checkout**: Real-time quantity adjustments, free Chitral delivery calculations, and confirmation alerts.

---

## 4. Appwrite Backend Integration (`AppwriteService`)
- **Source of Truth**: Appwrite cloud project (`chitral-shop-prod`) with `chitral_marketplace_db`.
- **Collections**: `products`, `orders`, `shops`, `reviews`, and `trending_metrics`.
- **Authentication**: Email/Password sessions, Google OAuth2, password recovery, and secure session management.
- **Realtime**: Live subscriptions on product stock and verified order trends.

---

## 5. Project Structure

```
├── flutter_project/                   # Complete Flutter + Riverpod + Appwrite Codebase
│   ├── pubspec.yaml                   # Riverpod 2.5, Appwrite 12.0
│   └── lib/
│       ├── core/
│       │   ├── constants/app_colors.dart
│       │   ├── services/appwrite_service.dart
│       │   └── widgets/
│       │       ├── animated_background.dart
│       │       └── tilt_3d_card.dart
│       └── features/
│           ├── auth/screens/          # Login, SignUp, ForgotPassword
│           ├── marketplace/           # Models, Providers, TrendingEngine, HomeScreen, ProductDetail, Cart
│           ├── seller/screens/        # Seller Dashboard & Inventory Management
│           └── admin/screens/         # Super Admin Panel
├── app/                               # Native Android Deployment (Streaming Emulator)
│   ├── src/main/kotlin/               # Jetpack Compose 3D Marketplace by Rahmat
│   └── src/main/res/                  # Adaptive Icons & Drawables
└── metadata.json                      # AI Studio Platform Metadata
```
