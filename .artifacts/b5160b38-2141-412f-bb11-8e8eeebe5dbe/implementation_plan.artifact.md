# Implementation Plan - Migrate Backend to Supabase (Woodyz 2.0)

This plan outlines the migration from PHP/MySQL to the user-defined Supabase 2.0 schema.

## User Review Required

> [!IMPORTANT]
> The `profiles` table now acts as the central user store. I will merge `Customer` and `Artisan` data into this single table structure.
> All IDs (User and Product) will be updated to match the PostgreSQL types (`uuid` and `bigint`).

## Proposed Changes

### 1. Data Models Refactoring

#### [MODIFY] [auth_entities.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/domain/entities/auth_entities.dart)
- Update `User.id` to `String` (for UUID).
- Add `username` and `bio` fields.
- Map `avatar_url` to existing image fields.
- Keep `Customer` and `Artisan` as subclasses for role-specific UI logic, but ensure they serialize to the single `profiles` table.

#### [MODIFY] [product_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/product_entity.dart)
- Update `artid` to `String` (UUID).
- Update `pid` to `int` (BigInt in JS is `int` in Dart/Flutter).
- Rename internal fields if necessary to match `title` (table) vs `name` (code), or update code to use `title`. I'll stick to `title` to match the DB.
- Add `isAvailable` and `material` fields.

### 2. Provider Migration

#### [MODIFY] [auth_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/providers/auth_provider.dart)
- **Sign Up**: Use `supabase.auth.signUp`. On success, insert into the `profiles` table.
- **Login**: Use `supabase.auth.signInWithPassword`. Fetch profile data from the `profiles` table upon successful auth.
- **Avatar Upload**: Use the `avatars` bucket.

#### [MODIFY] [products_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/presentation/providers/products_provider.dart)
- **Fetch Products**: Query the `products` table, joining `product_images` to get the primary image.
- **Add Product**:
    1. Insert into `products` table.
    2. Upload image(s) to `product-images` bucket.
    3. Insert image records into `product_images` table.
- **Favorites**: Update `saveProduct` and `unsaveProduct` to use the `favorites` table.

### 3. UI Updates
- Update all screens to handle `String` IDs for users.
- Ensure `username` is used where appropriate (e.g., login or profile display).

## Verification Plan

### Manual Verification
1. **Sign Up**: Register as an Artisan/Customer, verify the entry in `auth.users` and `public.profiles`.
2. **Product Upload**: Upload a product with an image, verify storage in `product-images` and records in `products`/`product_images`.
3. **Feed**: Verify the homescreen displays products from the `products` table.
4. **Favorites**: Toggle a favorite and verify the record in `favorites`.
