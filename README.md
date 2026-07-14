# Music Practice Companion App

Practice smarter, every day.

An iOS app that helps musicians structure their practice sessions, stay on tempo, and build consistent practice habits — with progress synced across devices in real time.

## Project Overview

Music Practice Companion is a multi-feature iOS app built with Swift and SwiftUI. It combines the core tools a musician needs during a practice session — a precision metronome, session tracking, and streak-based habit building — in a single app.

Practice data is stored in Firebase (Firestore) and synced across devices, so progress follows the user whether they practise from their phone or tablet. The metronome and streak-tracking logic are implemented from scratch without external libraries, with careful handling of timing accuracy and concurrency.

### Key Features

- **Custom metronome** - precise timing built on AVFoundation, implemented without external libraries 
- **Streak tracking** - daily practice streaks to build consistent habits, computed and persisted across sessions
- **Cross-device sync** - real-time practice data storage with Firebase Firestore
- **User accounts** - authentication via Firebase Auth
- **Modular SwiftUI architecture** - reusable views with centralised state management
- **Custom recorder** - recording, allowing musicians to listen to their playing and identify strengths and weaknesses 

## Tech Stack

| Layer            | Technology                        |
| ---------------- | --------------------------------- |
| UI               | Swift, SwiftUI                    |
| Audio            | AVFoundation                      |
| Auth & database  | Firebase (Auth, Firestore)        |
| Dependencies     | CocoaPods                         |
| Testing          | XCTest (unit & UI test targets)   |

## Running Locally

Requires Xcode and CocoaPods.

```bash
git clone https://github.com/CtrlAltDiscreet/Music-Practice-Companion-App.git
cd Music-Practice-Companion-App
pod install
open "Music Practice Companion App.xcworkspace"
```

Firebase setup: add your own `GoogleService-Info.plist` (from the [Firebase console](https://console.firebase.google.com)) to the app target, then build and run on a simulator or device.

## Author

Hayden Kua
