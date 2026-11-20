# TinyTots

**Little Steps, Big Learning!** A child-friendly Flutter app for ages 3–6.

## Run

```powershell
flutter pub get
flutter run
```

The Android implementation uses the device's built-in text-to-speech and SharedPreferences, so no third-party package or internet connection is required after installation.

## Structure

- `lib/data/alphabet_data.dart` — 26-card Kindergarten ABC dataset
- `lib/models/learning_card.dart` — reusable learning-card model
- `lib/services/` — native speech and local progress interfaces
- `lib/main.dart` — reusable screens and visual components

Future categories can add their own `LearningCard` list under `lib/data/` and reuse the flashcard, grid, progress, and completion patterns.
