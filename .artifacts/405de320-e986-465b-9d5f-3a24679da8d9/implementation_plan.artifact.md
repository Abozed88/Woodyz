# Implementation Plan: 2FA for Product Uploads

Require Two-Factor Authentication (2FA) verification before an artisan can upload a new product, provided they have 2FA enabled on their account.

## Proposed Changes

### Auth Feature

#### [MODIFY] [auth_provider.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/providers/auth_provider.dart)
- Add a helper method `isMFAEnabled()` to check if the user has any verified MFA factors.

#### [NEW] [mfa_verify_dialog.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/mfa_verify_dialog.dart)
- Create a reusable dialog widget that:
    - Prompts the user for a 6-digit MFA code.
    - Calls `verifyMFA` from `AuthProvider`.
    - Returns `true` if verification is successful.

#### [MODIFY] [upload.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/artisan/upload.dart)
- Update the `_handleUpload` method:
    - Before calling `ProductsProvider().addProduct`, check if the user has MFA enabled.
    - If enabled, show the `MFAVerifyDialog`.
    - Only proceed with the upload if MFA verification succeeds or if MFA is not enabled.

## Verification Plan

### Manual Verification
1. **With 2FA Disabled**:
    - Log in as an artisan without 2FA.
    - Attempt to upload a product.
    - Verify that the upload proceeds immediately as before.
2. **With 2FA Enabled**:
    - Enable 2FA in **Account & Security**.
    - Attempt to upload a product.
    - Verify that a dialog pops up asking for the 6-digit code.
    - Enter an invalid code; verify the upload is blocked and an error is shown.
    - Enter a valid code; verify the product is successfully uploaded.
