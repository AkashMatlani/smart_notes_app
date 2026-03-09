📝 Smart Notes App

Smart Notes is a Flutter application for creating, editing, and managing notes efficiently. The app works fully offline, supports smooth pagination, caching, and includes an AI-powered summary generator.


Example: Notes List Screen

🎯 Objective

This project demonstrates:

Clean and scalable Flutter architecture

Offline storage using Hive

Efficient caching strategy

Smooth pagination for large datasets

AI-powered summary generation

Proper state management with Riverpod

📂 Folder Structure
lib/
├── core/
│   ├── constants/
│   │   └── app_strings.dart       # App-wide constants
│   └── services/
│       └── ai_service.dart        # AI summary generator
├── features/
│   └── notes/
│       ├── data/
│       │   ├── datasource/
│       │   │   └── note_local_datasource.dart
│       │   └── models/
│       │       └── note_model.dart
│       ├── domain/
│       │   └── note.dart
│       └── presentation/
│           ├── providers/
│           │   └── notes_provider.dart
│           ├── screens/
│           │   ├── notes_list_screen.dart
│           │   └── note_editor_screen.dart
│           └── widgets/
│               └── note_tile.dart
└── main.dart
✅ Explanation

core – Shared constants, services, and utilities

data – Local database and models

domain – Business entities

presentation – Screens, widgets, state management

🗃 Offline Storage & Caching

Local Database: Hive is used to persist notes offline.

Caching:

Notes are loaded into memory for fast access.

Updates (create/edit/delete) refresh the cache.

AI-generated summaries are cached in memory to avoid repeated API calls.

This ensures the UI is fast and responsive, even with large datasets.

📄 Pagination

Loads 10 notes at a time initially.

When scrolling near the bottom, the next 10 notes are loaded.

Smooth scrolling with ScrollController and NotesNotifier.

Efficient memory usage ensures smooth UI even with 500+ notes.

Scalable: Can handle 1000+ notes without performance issues.

✏️ Create / Edit / Delete Notes

Create: Tap the + button → opens editor.

Edit: Tap an existing note → opens editor with pre-filled data.

Delete: Tap the trash icon on a note.

Optional Tags: Stored as a list of strings.

🤖 AI Feature – Summary Generator

Feature: Summarizes a note in 1–2 sentences.

Implementation: AIService handles requests with:

Request queue to avoid 429 rate limits

Exponential backoff retries (2,4,8…s)

Local in-memory cache

Fallback: If API fails, a simple local summarizer returns a truncated note.

Usage: User writes a long note → taps Generate Summary → summary replaces the content.

🧩 State Management

Riverpod is used for:

Notes list state

Pagination and caching

AI summaries

Why Riverpod: Clean, reactive, testable, and easy to scale.

⚡ Performance Considerations

Pagination: Only fetches a subset to prevent large rebuilds.

Caching: Keeps data in memory for fast access, avoiding repeated Hive reads.

Scalability: Clean architecture allows scaling to thousands of notes or swapping the database or AI provider.

🖌 UI & Fonts

Font: Poppins (Bold & Regular)

Material design for cards, FAB, and inputs

Smooth animations with scrolling

🔧 Setup Instructions

Clone the repository:

git clone https://github.com/AkashMatlani/smart_notes_app.git
cd smart_notes_app

Install dependencies:

flutter pub get

Add OpenAI API key in .env:

OPENAI_API_KEY=your_api_key_here

Run the app:

flutter run

Build release APK:

flutter build apk --release
