# Walkthrough - Supabase Migration (Woodyz 2.0)

I have completed the migration of the Woodyz backend from PHP/MySQL to Supabase (PostgreSQL). The app now uses Supabase Auth for identity management, PostgreSQL for data persistence, and Supabase Storage for images.

## Changes Made

### 1. Data Model Refactoring
- **Profiles**: Updated `User`, `Customer`, and `Artisan` entities to match the single `profiles` table. IDs are now `String` (UUIDs).
- **Products**: Updated the `Product` entity to match the new `products` and `product_images` schema. It now uses `title` and `imageUrl` (primary image from the join).

### 2. Supabase Auth Integration
- **Sign Up**: Rewrote the signup flow for both Customers and Artisans. It now performs a `supabase.auth.signUp` followed by an insert into the `public.profiles` table.
- **Login**: Implemented `supabase.auth.signInWithPassword`. The app automatically handles session persistence via Supabase's internal mechanism.
- **Session Management**: Updated the `Login` screen to check for existing Supabase sessions on startup.

### 3. Data Providers Migration
- **AuthProvider**: All PHP endpoints replaced with Supabase Client calls. Added avatar upload functionality using the `avatars` bucket.
- **ProductsProvider**:
    - **Fetch**: Uses Supabase joins to fetch products along with their images.
    - **Upload**: Implemented a two-step upload (insert product metadata, then upload image and link it in `product_images`).
    - **Favorites**: Migrated from the old saved products logic to the new `favorites` table with UUID/BigInt support.

### 4. UI Adjustments
- Updated all pages (`Login`, `Signup`, `Home`, `Profile`, `Details`) to work with the updated model fields and UUID identifiers.
- Fixed type mismatches and updated navigation logic to be more robust.

## Verification Results

### Static Analysis
- Fixed all critical compilation errors related to method signatures and data types.
- The project is now fully compatible with the Supabase 2.0 schema you provided.

> [!IMPORTANT]
> Since IDs have changed from `int` to `uuid`, any local cache or old database data will not be compatible. New users must sign up to be correctly registered in the new system.
