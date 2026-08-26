# Implementation Plan - Product Reviews and Ratings

Implement a system for users to rate and review products. Reviews will be stored in the `product_reviews` table, and the average rating will be reflected in the `products` table.

## User Review Required

> [!NOTE]
> The database is expected to handle the calculation of `average_rating` and `rating_count` on the `products` table (via triggers or other means). We will fetch and display these values.

## Proposed Changes

### Domain Layer

#### [MODIFY] [product_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/product_entity.dart)
- Add `double averageRating` and `int ratingCount` fields.
- Update `fromJson` to parse these fields from the database.

#### [NEW] [review_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/review_entity.dart)
- Define a `Review` class with fields: `id`, `productId`, `userId`, `rating`, `review`, `createdAt`, `updatedAt`, and `User? user` (to display the reviewer's info).

### Data Layer

#### [MODIFY] [products_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/presentation/providers/products_provider.dart)
- Add `fetchReviews(int productId)` to get reviews for a specific product, including reviewer profiles.
- Add `addReview(int productId, String userId, double rating, String review)` to submit a new review to Supabase.

### Presentation Layer

#### [MODIFY] [details.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/details.dart)
- Update the rating indicator in the header to use `widget.p.averageRating` and show `widget.p.ratingCount`.
- Add a "Reviews" section below the Artisan card.
- Implement a review submission form (or dialog) accessible only to customers.
- Display a list of reviews with reviewer avatars, names, ratings, and comments.

## Verification Plan

### Automated Tests
- None requested.

### Manual Verification
- **Submission**: Log in as a customer, submit a review with a rating (1-5) and a comment. Verify it appears in the list.
- **Display**: Verify the `average_rating` in the product header updates after submitting a review (may require a refresh or provider update).
- **Profile Link**: Ensure review thumbnails/names display correctly.
