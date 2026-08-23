# Task - Supabase Migration (Woodyz 2.0)

- [ ] Update Data Models
    - [ ] Refactor `User`, `Customer`, `Artisan` to match `profiles` table
    - [ ] Refactor `Product` to match `products` and `product_images` tables
- [ ] Implement Supabase Auth
    - [ ] Update `AuthProvider.login` to use Supabase Auth
    - [ ] Update `AuthProvider.signup` (Artisan & Customer) to use Supabase Auth + Profiles insert
    - [ ] Implement session persistence using Supabase's built-in listener
- [ ] Implement Supabase Data Fetching
    - [ ] Update `ProductsProvider.fetchData` for product feed
    - [ ] Update `ProductsProvider.addProduct` with image upload to `product-images` bucket
    - [ ] Update `ProductsProvider.fetchArtisanData`
    - [ ] Update `ProductsProvider.saveProduct` / `unsaveProduct` using `favorites` table
- [ ] UI Integration & Cleanup
    - [ ] Update screens to handle UUIDs (String)
    - [ ] Remove legacy `http` calls and PHP URL constants
    - [ ] Verify functionality
