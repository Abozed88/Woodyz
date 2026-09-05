# Walkthrough: 2FA for Product Uploads

I have integrated Two-Factor Authentication (2FA) into the product upload process, adding an extra layer of security for artisans.

## Changes Made

### Auth Core
- **[AuthProvider](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/providers/auth_provider.dart)**: Added `isMFAEnabled()` method to efficiently check the user's multi-factor authentication status.

### User Interface
- **[MFAVerifyDialog](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/mfa_verify_dialog.dart)**: Created a new, secure dialog that prompts artisans for their 6-digit TOTP code. It features large, clear input fields and real-time verification against Supabase.

### Integration
- **[Upload Page](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/artisan/upload.dart)**: Updated the upload logic to intercept the "Upload" button press. If the artisan has 2FA enabled, the `MFAVerifyDialog` is shown. The actual product creation and image uploads only occur after a successful verification.

## Verification Results

### Manual Verification
- **2FA Disabled**: Confirmed that artisans without 2FA can upload products instantly without any interruption.
- **2FA Enabled**: Confirmed that the "Identity Verification" dialog correctly appears.
- **Security Check**: Verified that entering an incorrect code blocks the upload and shows an appropriate error message.
- **Successful Flow**: Verified that entering a valid code allows the upload to proceed and succeed.
