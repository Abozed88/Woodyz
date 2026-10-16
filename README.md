# Woodyz 🪵✨

**Woodyz** is a Flutter marketplace app that connects woodcraft artisans with customers who appreciate handcrafted wood furniture and products. Artisans showcase and manage their creations; customers discover, save, review, and contact the makers directly.

> *Crafted with passion.*

Woodyz does not process payments. When a customer is ready to buy, **Request to Order** opens the artisan's Instagram account so the two can agree on price, shipping, and payment directly.

---

## 📖 Table of Contents

- [What's New](#-whats-new-in-this-version)
- [Features](#-features)
- [How It Works](#-how-it-works)
- [Tech Stack](#%EF%B8%8F-tech-stack)
- [Project Structure](#-project-structure)
- [Data Model](#-data-model)
- [Getting Started](#-getting-started)
- [Security](#-security)
- [Known Limitations](#-known-limitations)
- [Screenshots](#-screenshots)

---

## 🆕 What's New in This Version

This version replaces the earlier PHP/MySQL backend with **Supabase** and adds a full set of account, product, and safety features.

| Area | Before | Now |
|------|--------|-----|
| Backend | PHP API + MySQL on localhost | Supabase (Auth, PostgreSQL, Storage) |
| Authentication | Custom PHP login | Supabase Auth with persistent sessions, password reset by email, optional two-factor authentication |
| Sign up | Single form | Two-step sign up with role-specific details (Customer or Artisan) |
| Browsing | Basic product list | Infinite scrolling feed, text search, 9 categories, and price/location/category filters |
| Product page | Description and save option | Image gallery, specifications, ratings and reviews, artisan card, report option |
| Artisan tools | Upload | Upload with multiple images, edit, delete, and 2FA check before publishing |
| Account | — | Profile editing, avatar change, light/dark/system theme, change password, delete account |
| Safety | — | Report products and artisans, Community Guidelines, Terms, Privacy Policy |

---

## 🚀 Features

### For everyone
- **Email and password authentication** powered by Supabase, with the session restored automatically when the app reopens.
- **Two-step sign up** with a progress indicator: basic details first, then role-specific details and a profile photo.
- **Password recovery**: a reset link is sent by email and opens the app directly on the Change Password screen.
- **Profile management**: edit your information inline, change your avatar, and log out with confirmation.
- **Appearance settings**: light theme, dark theme, or follow the device setting. The choice is remembered.
- **Account & Security**: view account info, change password, enable or disable two-factor authentication (authenticator app), and permanently delete the account.
- **Help & Support**: FAQ and an *Email Us* button that pre-fills the app version, device model, and OS version.
- **About & legal pages**: Terms of Service, Privacy Policy, and Community Guidelines.

### 🛍️ For customers
Navigation: **Home · Explore · Saved · Profile**

- **Home feed**: the latest products from all artisans, loaded 20 at a time with infinite scrolling.
- **Explore**: search by product name, jump into a category (Furniture, Decor, Bedroom, Bowls, Kitchenware, Outdoor, Art, Toys, Others), or combine **filters** for price range, artisan location, and category.
- **Product details**: image gallery with full-screen view, category, availability badge, price, specifications, description, and last-updated date.
- **Ratings and reviews**: read all reviews and leave your own star rating and comment.
- **Saved**: bookmark products to a personal favorites list.
- **Artisan profile**: view an artisan's bio, address, skills, and full product list.
- **Request to Order**: opens the artisan's Instagram to complete the deal.
- **Report**: flag a product or artisan (inappropriate content, spam or misleading, harassment, intellectual property violation, or other).

### 🔨 For artisans
Navigation: **My Store · Upload · Profile**

- **My Store**: your own products in the same grid customers see.
- **Upload a product**: main image plus up to 5 additional images, name, description, category, availability status (*Unavailable*, *In Stock*, *On Demand*, *In Production*), stock quantity, availability toggle, and price.
- **Edit and delete**: update product details at any time, or delete a product together with its images, reviews, and favorites.
- **Two-factor check on upload**: if 2FA is enabled, a 6-digit code is required before a product is published.
- **Artisan profile**: Instagram username, bio, business address, and skills (chip-based selection).

---

## 🔄 How It Works

```
Sign up / Log in  →  Role detected  →  Customer home  or  Artisan home
```

**Customer journey**

1. Browse the home feed, or search and filter in Explore.
2. Open a product and review images, specifications, and reviews.
3. Save it, write a review, or report it if needed.
4. Tap **Request to Order** to contact the artisan on Instagram.

**Artisan journey**

1. Create an artisan account with your Instagram, bio, address, and skills.
2. Open the **Upload** tab and add images and product details.
3. Verify with your 2FA code (if enabled) and publish.
4. Manage products from **My Store**: edit or delete at any time.

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart SDK ^3.9.2), Material 3 |
| Backend | [Supabase](https://supabase.com): Authentication, PostgreSQL, Storage, database function |
| State management | `provider` (theme), plus service classes for auth and products |
| Key packages | `supabase_flutter`, `provider`, `image_picker`, `url_launcher`, `flutter_secure_storage`, `lottie`, `qr_flutter`, `device_info_plus`, `package_info_plus` |
| Fonts | Western (logo and titles), Saira (interface) |
| Platforms | Android (primary target); web and Windows project files are included |

---

## 📂 Project Structure

```
lib/
├── main.dart                  # Supabase initialization and app startup
├── app.dart                   # MaterialApp, themes, entry page
├── config/
│   └── env.dart               # Supabase URL and key (not committed, see Getting Started)
├── core/
│   ├── theme/                 # Colors, light/dark themes, theme provider
│   └── widgets/               # Reusable widgets, e.g. validated text field
└── features/
    ├── auth/
    │   ├── domain/entities/   # User, Customer, Artisan models
    │   └── presentation/
    │       ├── providers/     # AuthProvider (login, sign up, 2FA, profile, delete)
    │       ├── pages/         # Customer and shared pages
    │       │   └── artisan/   # Artisan pages (upload, edit, sign up details)
    │       └── widgets/       # Page-specific widgets and dialogs
    ├── home/
    │   └── presentation/pages/ # Customer and artisan home with bottom navigation
    └── products/
        ├── domain/entities/   # Product and review models
        └── presentation/providers/ # ProductsProvider (feed, search, favorites, reviews, reports)

assets/
├── animations/                # Lottie: loading, success, empty state
├── fonts/                     # Western, Saira
├── icons/                     # Logo and social icons
└── images/                    # Backgrounds and placeholders
```

---

## 🗄️ Data Model

The app expects these Supabase tables and storage buckets.

| Table | Purpose |
|-------|---------|
| `profiles` | All users: id, username, full name, avatar URL, role, phone, location, bio |
| `artisans` | Artisan extras: bio, skills, address, rating, Instagram username |
| `products` | Artisan, title, description, price, stock, category, material, availability status, availability flag, rating summary, timestamps |
| `product_images` | Product, image URL, storage path, primary-image flag |
| `product_reviews` | Product, user, rating, review text, date |
| `favorites` | User and product pairs (the Saved list) |
| `reports` | Reporter, reported item, item type, reason |

| Storage bucket | Content |
|----------------|---------|
| `avatars` | Profile photos |
| `product-images` | Product photos, grouped by artisan |

**Database function:** `delete_user()` is called by the app to delete the signed-in user's account. Example definition:

```sql
create or replace function public.delete_user()
returns void
language sql
security definer
set search_path = public
as $$
  delete from auth.users where id = auth.uid();
$$;
```

Make sure your Row Level Security policies allow each role to read and write only what it should.

---

## ⚡ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) with Dart 3.9.2 or newer
- Android Studio or VS Code with the Flutter extension, and an Android emulator or device
- A free [Supabase](https://supabase.com) project

### 1. Clone the project
```bash
git clone --branch woodyz2 https://github.com/Abozed88/woodyz.git
cd woodyz
flutter pub get
```

### 2. Set up Supabase
1. Create the tables and storage buckets listed in [Data Model](#%EF%B8%8F-data-model), and add the `delete_user()` function.
2. In **Authentication → URL Configuration**, add this redirect URL so password-reset emails open the app:
   ```
   io.supabase.woodyz://login-callback
   ```
3. Enable **Multi-Factor Authentication (TOTP)** in your Supabase Auth settings to use two-factor authentication.

### 3. Add your keys
The keys file is excluded from version control. Create `lib/config/env.dart`:

```dart
class Secrets {
  static const String supabase_url = 'https://YOUR-PROJECT.supabase.co';
  static const String supabase_anon_key = 'YOUR-PUBLIC-ANON-KEY';
}
```

Use only the public anon/publishable key. Never put a service-role key in the app.

### 4. Run
```bash
flutter run
```

### Build a release APK
```bash
flutter build apk --release
```

---

## 🔒 Security

- Authentication, sessions, and password recovery are handled by Supabase Auth; the app never stores passwords.
- Optional two-factor authentication using any authenticator app. Artisans with 2FA enabled must verify before publishing a product.
- Account deletion permanently removes the user through a server-side function.
- `lib/config/env.dart` is git-ignored so project keys are not committed.

---

## ⚠️ Known Limitations

- There is no in-app payment, cart, or order tracking; ordering happens through Instagram.
- Products with the status **Unavailable** are hidden from every feed, including the artisan's own **My Store**. The separate availability toggle only affects the *Available / Sold Out* badge.
- The location filter in Explore offers cities (Sidon, Tyre, Byblos, Zahle) that differ from the regions offered at sign-up, so some filter choices may return no results.
- Google sign-in is not implemented, even though the package is installed.
- The included widget test is the default Flutter template and does not test the app.

---

## 📸 Screenshots

<details>
<summary>Earlier build (replace with screenshots of the current version)</summary>

<img width="499" height="602" alt="Screenshot 2026-06-19 201926" src="https://github.com/user-attachments/assets/c96177c9-a0e4-44d2-b8f1-c75549e9234d" />
<img width="499" height="609" alt="Screenshot 2026-06-19 202446" src="https://github.com/user-attachments/assets/21226309-9165-4761-9540-4b2c7731c5f6" />
<img width="497" height="605" alt="Screenshot 2026-06-19 202423" src="https://github.com/user-attachments/assets/24bb0311-5291-491a-b02c-3e9f3e55805e" />
<img width="502" height="608" alt="Screenshot 2026-06-19 202410" src="https://github.com/user-attachments/assets/b77d501e-aedf-4fb9-bce5-2f2a734fc08c" />
<img width="500" height="608" alt="Screenshot 2026-06-19 202322" src="https://github.com/user-attachments/assets/cf1e30ce-493f-479c-96ca-78e061358fe3" />
<img width="503" height="610" alt="Screenshot 2026-06-19 202252" src="https://github.com/user-attachments/assets/bf23c613-6018-42de-9c90-fe9245e00014" />
<img width="499" height="599" alt="Screenshot 2026-06-19 202227" src="https://github.com/user-attachments/assets/4ea5a0db-3242-4523-8d38-a282f821d132" />
<img width="500" height="602" alt="Screenshot 2026-06-19 202206" src="https://github.com/user-attachments/assets/262c2f98-6843-416d-9f28-8292a2b4de38" />
<img width="499" height="610" alt="Screenshot 2026-06-19 202128" src="https://github.com/user-attachments/assets/53017911-7ffb-4111-9c28-eb9cc1aaa57d" />
<img width="495" height="608" alt="Screenshot 2026-06-19 202105" src="https://github.com/user-attachments/assets/4dab70fd-a185-42e2-9ea5-62b520ac88b5" />
<img width="498" height="605" alt="Screenshot 2026-06-19 201958" src="https://github.com/user-attachments/assets/6c127842-a123-4968-a52a-8da0c797447b" />

</details>
