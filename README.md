# KoboltAssistant

## Overview

**KoboltAssistant** is a work-in-progress Flutter application designed to assist players and game masters in tabletop role-playing games (TTRPGs) like Dungeons & Dragons. The app provides tools for generating characters, managing game sessions, and enhancing the overall TTRPG experience. This project is being developed as a learning exercise in Flutter development and aims to deliver a modular, cross-platform solution for TTRPG enthusiasts.

The application currently includes basic functionality for generating random characters with names, races, and classes, and plans to expand into session management, dice rolling, and other utilities.

## Features

### Current Features
- **Character Generator**:
  - Generate random names, races, and classes for characters.
  - Uses the `faker` package for realistic name generation.
  - Includes predefined lists for races and classes.
- **Cross-Platform Support**:
  - Runs on Android, iOS, Windows, Linux, macOS, and web platforms.
- **Dynamic UI**:
  - Floating action button for generating characters.
  - Material design for consistent and modern UI.

### Planned Features
- **Session Management**:
  - Tools for tracking player stats, inventory, and game progress.
- **Dice Roller**:
  - Simulate dice rolls for various TTRPG mechanics.
- **Customizable Character Options**:
  - Add custom races, classes, and traits.
- **Game Master Tools**:
  - Encounter builder and NPC generator.

## Code Structure

### Main Application
- **Entry Point**: [`main.dart`](lib/main.dart) initializes the app and sets up the character generator.
- **Character Generator**:
  - Uses the `faker` package for name generation.
  - Predefined lists for races and classes are stored in the main file.

### UI Components
- **Floating Action Button**: Triggers character generation with a dice icon.
- **Material Design**: Implements Flutter's Material theme for consistent styling.

### Platform-Specific Configurations
- **Android**: [`AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml) configures app permissions and metadata.
- **iOS**: [`Main.storyboard`](ios/Runner/Base.lproj/Main.storyboard) sets up the initial view controller.
- **Windows**: [`Runner.rc`](windows/runner/Runner.rc) defines versioning and metadata.
- **Linux**: [`CMakeLists.txt`](linux/runner/CMakeLists.txt) configures the build system.
- **Web**: [`index.html`](web/index.html) sets up the web entry point.

### Localization
- **Multi-Language Support**: Planned for future updates to support multiple languages for character traits and app navigation.

## Competencies Involved

### Technical Skills
- **Flutter Development**: Building modular and scalable applications using Flutter.
- **Cross-Platform Development**: Ensuring compatibility across mobile, desktop, and web platforms.
- **State Management**: Managing app state for dynamic character generation.
- **Package Integration**: Using third-party packages like `faker` for enhanced functionality.

### Problem-Solving
- **UI/UX Design**: Creating intuitive and user-friendly interfaces.
- **Randomization Logic**: Implementing algorithms for generating random characters.
- **Platform-Specific Configurations**: Handling differences in build systems and app metadata.

### Collaboration
- **Code Organization**: Structuring the project for readability and maintainability.
- **Documentation**: Writing clear comments and a comprehensive README.

## How to Run

1. Clone the repository.
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the application:
   ```sh
   flutter run
   ```

## Status

This project is a **work-in-progress**. Current focus areas include:
- Expanding the character generator with additional traits.
- Adding session management tools.
- Implementing dice rolling functionality.

## Acknowledgments

Special thanks to the **Flutter community** for providing resources and inspiration for this project.

## Developer

- **Name**: @xmatute-
- **Version**: 0.1.0