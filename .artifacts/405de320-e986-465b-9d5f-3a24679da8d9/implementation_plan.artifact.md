# Implementation Plan: Bouncing Heart and Star Buttons

Add a "bounce/jump" animation to the save (heart) button and the rating (star) buttons on the product details page.

## Proposed Changes

### Details Feature

#### [MODIFY] [details_widgets.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/widgets/details_widgets.dart)
- Add a new `BouncingIconButton` widget. This widget will use an `AnimationController` and `ScaleTransition` to create a bounce effect when the button is pressed.

#### [MODIFY] [details.dart](file:///C:/Users/Grandiose/Documents/Woodyz/lib/features/auth/presentation/pages/details.dart)
- Replace the standard `IconButton` for the heart (save) button in the `appBar` with the new `BouncingIconButton`.
- Replace the star icons in the "Write a Review" section with `BouncingIconButton` to ensure each star bounces when selected.

## Verification Plan

### Manual Verification
- Navigate to a product's details page.
- Tap the heart button and verify it performs a bounce/scale animation.
- Scroll down to the "Write a Review" section.
- Tap different star ratings and verify that each star bounces when pressed.
