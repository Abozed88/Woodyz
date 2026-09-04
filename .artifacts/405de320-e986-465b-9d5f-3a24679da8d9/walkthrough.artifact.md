# Walkthrough: Profile Settings Pages

I have populated the `Account & Security`, `Help`, and `About` pages with relevant content and integrated them into the app's navigation.

## Changes Made

### Auth Feature (Presentation)

#### [Account & Security](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/account&security.dart)
- Displays current user info (Email, User ID).
- Integrated **Password Management** linking to the `ChangePassword` screen.
- Added placeholders for **Security Toggles** (Biometric, 2FA).
- Added a **Delete Account** section with a confirmation dialog.

#### [Help & Support](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/help.dart)
- Added an **FAQ Section** with expandable tiles covering common woodcraft marketplace questions.
- Integrated a **Search Bar** placeholder for help articles.
- Added **Contact Support** cards for Email and Live Chat.

#### [About Woodyz](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/about.dart)
- Styled with the app's "Western" font and woodcraft-themed iconography.
- Includes a **Mission Statement** detailing the app's goal of connecting artisans with customers.
- Added tiles for **Legal Links** (Terms of Service, Privacy Policy).

#### [Profile Integration](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/profile_widgets.dart)
- Linked the "Account & Security" and "Help & Support" tiles to their respective pages.
- Added a new "About Woodyz" tile to the settings list.

## Verification Results

### Manual Verification
- Verified that all tiles in the Profile settings correctly navigate to the new pages.
- Verified that the "Change Password" link within Account Security works as expected.
- Verified that the FAQ tiles in the Help page correctly expand and collapse.
