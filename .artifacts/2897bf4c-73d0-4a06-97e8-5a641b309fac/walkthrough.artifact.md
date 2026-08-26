# Walkthrough - Artisan Data Verification & Storage Fix

I have ensured that artisan-specific data, especially the `address`, is correctly routed to and retrieved from the `artisans` table.

## Changes Made

### 1. JSON Serialization Separation
- **`User` Entity**: Added `toProfileJson()` which excludes the `address` field by default. This prevents crashes if the `profiles` table does not contain an `address` column for all users.
- **`Customer` Entity**: Overrode `toJson()` to include `address`, as customers store their delivery address in the `profiles` table.
- **`Artisan` Entity**: Continues to use `toArtisanJson()` which explicitly includes `address`, targeting the specialized `artisans` table.

### 2. Robust Sign-Up Flow
- Updated `AuthProvider.signUp` to use `toProfileJson()` when inserting into the base `profiles` table.
- Confirmed that artisan-specific data (bio, skills, address) is correctly inserted into the `artisans` table using the data gathered during the second step of signup.

### 3. Diagnostic Logging
- Added `debugPrint` statements to `AuthProvider.login` and `login.dart` (session restoration).
- These logs will output the **Raw Login Data** and the **Mapped Artisan Address** to the console, allowing you to verify in real-time that the data is being fetched correctly from the database join.

## Verification Results

### Logic Check
- [x] Verified that `Artisan.fromJson` correctly pulls `address` from the nested `artisans` object returned by Supabase joins.
- [x] Confirmed that `navigateBasedOnRole` receives a fully populated `Artisan` object.

### Manual Verification Steps
1. **Check Logs**: When you sign in as an artisan, look at the Debug Console. You should see `Raw Login Data` containing an `artisans` map, and `Mapped Artisan Address` showing the correctly retrieved address.
2. **Profile Page**: Verify that the address is displayed correctly on the profile page after sign-in.
