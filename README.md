<div align="center">
  <img src="assets/images/branding/app_icon.png" alt="Waraqty logo" width="120" />

  # Waraqty | ورقتي

  **An Arabic-first worksheet and exam builder for Egyptian primary-school teachers.**

  Built with Flutter, Clean Architecture, Cubit, local-first data, and on-device PDF generation.
</div>

![Waraqty feature graphic](docs/images/waraqty-feature-graphic.png)

## Overview

Waraqty helps teachers create printable Social Studies booklets and exams without manually formatting every question. A teacher chooses a grade, selects questions from a structured bank, adjusts the document details and template, previews the result, then saves or shares the generated PDF.

The first release focuses on Egyptian Social Studies for grades 4, 5, and 6.

## Highlights

- 1,200 locally available questions across three grade levels.
- Eight question categories, including multiple choice, complete, true/false, explain, define, essay, compare, and consequences.
- Per-category question limits, unlimited mode, select-all, and clear-selection controls.
- Reorderable document sections before generation.
- Booklets with optional answers.
- Exams with a separate answer-key PDF.
- Three booklet templates and three exam templates inspired by Egyptian school papers.
- Configurable font size and document metadata.
- In-app PDF preview, local saving, and native sharing.
- Offline-first question bank with no account required.
- Arabic RTL interface with responsive layouts.
- AdMob banner and interstitial ads with UMP privacy consent support.

## User Flow

1. Select a grade.
2. Select the subject.
3. Choose a booklet or exam.
4. Browse question categories and select questions.
5. Review and reorder document sections.
6. Enter optional document or school details.
7. Choose a template and preview the PDF.
8. Save and share the generated files.

## Architecture

The project follows a feature-first Clean Architecture approach:

```text
lib/
|-- app/                         # App shell, directionality, and system UI
|-- core/
|   |-- ads/                     # AdMob and banner state management
|   |-- constants/               # Routes, strings, assets, and app constants
|   |-- enums/                   # Shared domain enums
|   |-- routing/                 # GoRouter configuration
|   |-- theme/                   # Colors, typography, spacing, and theme
|   `-- widgets/                 # Reusable app-wide widgets
`-- features/
    |-- onboarding/
    |-- paper_setup/
    |-- question_bank/
    `-- document_builder/
        |-- data/
        |-- domain/
        `-- presentation/
```

Each feature keeps presentation, domain, and data concerns separated. UI state is managed with Cubit, while repository and use-case boundaries keep the question source replaceable when the app moves from local data to a remote backend.

## Tech Stack

| Area | Technology |
| --- | --- |
| UI | Flutter, Material |
| State management | Cubit / flutter_bloc, Equatable |
| Navigation | GoRouter |
| Architecture | Feature-first Clean Architecture |
| Responsive UI | flutter_screenutil |
| Local preferences | shared_preferences |
| PDF generation | pdf, printing |
| Icons | lucide_icons_flutter |
| Ads and consent | google_mobile_ads, Google UMP |
| Branding | flutter_launcher_icons, flutter_native_splash |
| Arabic font | IBM Plex Sans Arabic |

## Getting Started

### Requirements

- Flutter SDK compatible with Dart `^3.11.4`
- Android Studio or VS Code
- Android SDK 24 or newer

### Run locally

```bash
git clone https://github.com/Marwan28/waraqty.git
cd waraqty
flutter pub get
flutter run
```

Debug builds use Google's test ad units. Production AdMob IDs are kept in the release configuration and should never be used for development clicks.

### Quality checks

```bash
flutter analyze
flutter test
```

### Build an Android App Bundle

Release signing requires a local `android/key.properties` file and a private upload keystore. Neither file should be committed.

```bash
flutter build appbundle --release
```

The generated bundle is written to:

```text
build/app/outputs/bundle/release/app-release.aab
```

## Privacy

Waraqty does not require an account. Question selections, preferences, and generated PDFs remain on the user's device. Google AdMob may process advertising-related device data according to user consent and Google's policies.

- [Privacy Policy](https://marwan28.github.io/privacy.html)
- [app-ads.txt](https://marwan28.github.io/app-ads.txt)

## Roadmap

- Add more Egyptian school subjects and grade levels.
- Move the question bank to Supabase.
- Add teacher accounts and cloud synchronization.
- Support teacher-submitted questions and moderation.
- Add smart question recommendations.
- Add saved document history and reusable presets.

## Author

Developed by [Marwan Abdelwahab](https://github.com/Marwan28).
