# Implementation Plan - Detailed Product View

This plan outlines the updates to the Product Details page to include all attributes from the database schema, improving transparency and information depth for users.

## User Review Required

> [!NOTE]
> I will be updating the `Product` model to include the `updated_at` field and ensuring that "Material" and "Availability" are clearly visible.

## Proposed Changes

### 1. Data Model Enhancement

#### [MODIFY] [product_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/product_entity.dart)
- Add `updatedAt` field.
- Update `fromJson` to map `updated_at` from Supabase.

### 2. UI Refactoring

#### [MODIFY] [details.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/details.dart)
- Add an "Availability" badge next to the title or category.
- Add a "Specifications" section for the `material`.
- Improve the layout to include all timestamps (`created_at`, `updated_at`) at the bottom.

#### [MODIFY] [details_widgets.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/details_widgets.dart)
- Update `Widget1` (renaming it to `ProductSpecsGrid` for clarity) to display a grid of key attributes:
    - **Stock**
    - **Material**
    - **Created**
    - **Updated**

## Verification Plan

### Manual Verification
1. **Product View**: Open a product and verify that Material, Stock, and both timestamps are visible and correctly formatted.
2. **Theme Consistency**: Ensure the new fields are readable in both Light and Dark modes.
3. **Null Safety**: Verify that if `material` or `updated_at` is null, the app handles it gracefully (showing "N/A" or "Not specified").
