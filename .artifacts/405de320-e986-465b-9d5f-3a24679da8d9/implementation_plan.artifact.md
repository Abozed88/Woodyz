# Implementation Plan: Profile Settings Pages

Fill the `Account & Security`, `Help`, and `About` pages with relevant content and functionality based on the Woodyz app's domain.

## Proposed Changes

### Auth Feature (Presentation)

#### [MODIFY] [account&security.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/account&security.dart)
- Create a `SecurityPage` widget.
- Add sections for:
    - **Password Management**: Link to the `ChangePassword` screen.
    - **Security Settings**: Toggles for biometric login (placeholder) and 2FA.
    - **Account Actions**: "Delete Account" button with a confirmation dialog.
    - **Session Info**: Display the current user's email and role.

#### [MODIFY] [help.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/help.dart)
- Create a `HelpPage` widget.
- Add an **FAQ Accordion** with questions like:
    - "How do I contact an artisan?" (Answer: Use the Instagram link on their profile).
    - "How do I report a product?" (Answer: Use the report icon on the product details page).
    - "What is Woodyz?" (Answer: A platform for handcrafted wood products).
- Add a **Contact Us** button that triggers an email or opens a contact dialog.

#### [MODIFY] [about.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/about.dart)
- Create an `AboutPage` widget.
- Add:
    - **App Logo & Version**: Current version (v1.0.0).
    - **Mission Statement**: "Woodyz is dedicated to bringing the soul of woodcraft into your home by connecting passionate artisans with discerning customers."
    - **Legal Links**: Buttons for "Terms of Service" and "Privacy Policy" (placeholders).
    - **Credits**: Acknowledgments for the team/technologies used (Supabase, Flutter).

#### [MODIFY] [profile_widgets.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/profile_widgets.dart)
- Link the tiles in the `Preferences` widget to the new pages.

## Verification Plan

### Manual Verification
- Navigate to the Profile page.
- Click on "Account & Security" and verify the content.
- Click on "Help & Support" and verify the FAQ and contact options.
- (Optional) Add an "About" tile to `Preferences` to test that page as well.
