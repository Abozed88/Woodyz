# Implementation Plan - Fix RLS Update Error

Resolve the `PostgrestException` (RLS violation) occurring when updating product availability.

## User Review Required

> [!IMPORTANT]
> The RLS error `new row violates row-level security policy` usually means the user no longer has permission to see/check the row after the update.
>
> **Action for User:** Please verify in your Supabase Dashboard that your **SELECT** policy allows you to see products where `is_available = false` if you are the owner.
>
> Example SQL fix for your dashboard:
> ```sql
> -- Allow artisans to see their own products regardless of availability
> CREATE POLICY "Artisans can see all their own products"
> ON products FOR SELECT
> TO authenticated
> USING (auth.uid() = artisan_id);
> ```

## Proposed Changes

### Domain Layer

#### [MODIFY] [product_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/product_entity.dart)
- Add `toUpdateJson()` method.
- This method will return a Map **excluding** `id`, `artisan_id`, and `created_at`.
- This prevents RLS from thinking we are trying to change the owner or ID of the product.

### Data Layer

#### [MODIFY] [products_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/presentation/providers/products_provider.dart)
- Update `updateProduct(Product p)` to use `p.toUpdateJson()` instead of `p.toJson()`.

## Verification Plan

### Manual Verification
- **Edit Flow**: Change `isAvailable` to `false` in the Edit screen and save.
- **Success**: The product should save successfully without the Postgres error.
- **Data Check**: Verify in Supabase that the `is_available` column is now `false` for that record.
