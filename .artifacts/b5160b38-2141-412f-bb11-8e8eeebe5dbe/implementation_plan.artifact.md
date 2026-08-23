# Implementation Plan - UI Refinement & Readability Fixes

This plan addresses the color contrast issues in Light Mode and ensures the "Always Dark" requirement for onboarding is correctly implemented without breaking readability.

## User Review Required

> [!IMPORTANT]
> - **Onboarding Flow** (Login/Signup/Step 2): Will remain **Always Dark** with a dedicated dark background to avoid "white on white" issues.
> - **Main Tabs** (Home/Explore/Saved/Profile/Upload): Will follow the **System Theme** (Light/Dark) but with all hardcoded colors removed to ensure perfect readability.

## Proposed Changes

### 1. Consistent "Always Dark" Onboarding

I will ensure these pages have a dark background even if the device is in light mode:
- `lib/features/auth/presentation/pages/login.dart`
- `lib/features/auth/presentation/pages/signup.dart`
- `lib/features/auth/presentation/pages/signup_cust.dart`
- `lib/features/auth/presentation/pages/artisan/signup_art.dart`

### 2. Tab-specific Readability Fixes (System Theme)

#### [MODIFY] [profile.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/profile.dart)
- Remove the `AppTheme.darkTheme` override to allow it to follow the system theme.
- Replace hardcoded `Colors.white` and `Color.fromRGBO(...)` with `theme.colorScheme` properties.
- Fix the Settings icon color.

#### [MODIFY] [upload.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/artisan/upload.dart)
- Remove hardcoded white text and primary color RGBO calls.
- Ensure the background and text adapt correctly to the theme.

#### [MODIFY] [profile_widgets.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/profile_widgets.dart) & [upload_widgets.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/upload_widgets.dart)
- Update `PImage`, `Preferences`, `ChooseCategory`, and `NumberIndicator` to be fully theme-aware.
- Ensure `NumberIndicator` text is visible in Light mode.

### 3. Navigation Cleanup

- Verify and ensure `automaticallyImplyLeading: false` is set on all top-level Home/Artisan Home screens to remove the unintentional back button.

## Verification Plan

### Manual Verification
1. **Light Mode Check**: Toggle device to Light Mode.
   - Verify `Home`, `Explore`, `Saved`, `Profile`, and `Upload` tabs have dark text on a light background.
   - Verify `Login` and `Signup` remain dark with white text.
2. **Navigation**: Ensure no back button appears in the main app bar of the home screens.
