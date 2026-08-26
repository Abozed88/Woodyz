# Walkthrough - Product Reviews and Ratings

I have implemented a complete system for users to rate and review products. The system includes data models, backend integration with Supabase, and UI components for displaying and submitting reviews.

## Changes Made

### 1. Domain Layer Updates
- **[product_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/product_entity.dart)**:
    - Added `averageRating` and `ratingCount` fields.
    - Updated `fromJson` to parse these values from the `products` table.
- **[review_entity.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/domain/entities/review_entity.dart)**:
    - Created a new entity to represent a product review.
    - Supports joining with the `profiles` table to display reviewer names and avatars.

### 2. Data Layer Updates
- **[products_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/products/presentation/providers/products_provider.dart)**:
    - Added `fetchReviews(int productId)`: Retrieves all reviews for a product, including reviewer profiles.
    - Added `addReview(...)`: Submits a new rating and comment to the `product_reviews` table.
    - Added `fetchProductById(int productId)`: Used to refresh the local product state after a review is submitted to show the updated average rating.

### 3. UI Enhancements (Product Details)
- **[details.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/details.dart)**:
    - **Header**: The rating indicator now shows the real average rating and the total count of reviews.
    - **Reviews List**: Added a scrollable list (under the Artisan card) showing user avatars, names, star ratings, dates, and comments.
    - **Submission Form**: Logged-in customers now see a "Write a Review" section where they can select a star rating (1-5) and write a comment.
    - **Live Updates**: The UI automatically refreshes the review list and the header rating summary immediately after a successful submission.

## Verification Plan

- **Rating Display**: Verified that `average_rating` is displayed to one decimal place (e.g., "4.5").
- **Auth Guard**: The review submission form is only visible to users logged in as `Customer`. Artisans viewing their own or others' products will not see the form.
- **Empty State**: Added a friendly message when a product has no reviews yet.
