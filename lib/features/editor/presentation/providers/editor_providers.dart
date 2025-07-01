import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model for an opened file tab
class EditorTab {
  final String name;
  final String path;
  final String content;
  final bool isModified;

  const EditorTab({
    required this.name,
    required this.path,
    required this.content,
    this.isModified = false,
  });

  EditorTab copyWith({
    String? name,
    String? path,
    String? content,
    bool? isModified,
  }) {
    return EditorTab(
      name: name ?? this.name,
      path: path ?? this.path,
      content: content ?? this.content,
      isModified: isModified ?? this.isModified,
    );
  }
}

// Provider for managing opened tabs
final openedTabsProvider = StateNotifierProvider<OpenedTabsNotifier, List<EditorTab>>((ref) {
  return OpenedTabsNotifier();
});

// Provider for the currently active tab index
final activeTabIndexProvider = StateProvider<int>((ref) => 0);

class OpenedTabsNotifier extends StateNotifier<List<EditorTab>> {
  OpenedTabsNotifier() : super([
    // Default welcome tab
    const EditorTab(
      name: 'Welcome',
      path: 'welcome',
      content: '''Welcome to RigIDE

A high-performance mobile IDE for iOS and Android

Features:
• Code editor with syntax highlighting
• File explorer
• Git integration
• Terminal emulator
• Language Server Protocol support

Click on a file in the explorer to open it!''',
    ),
  ]);

  int openFile(String name, String path, String content) {
    // Check if file is already open
    final existingIndex = state.indexWhere((tab) => tab.path == path);
    if (existingIndex != -1) {
      // File already open, return the existing tab index
      return existingIndex;
    }

    // Add new tab
    state = [...state, EditorTab(name: name, path: path, content: content)];
    return state.length - 1; // Return the new tab index
  }

  void closeTab(int index) {
    if (state.length <= 1) return; // Keep at least one tab
    state = [
      ...state.take(index),
      ...state.skip(index + 1),
    ];
  }

  void updateTabContent(int index, String content) {
    if (index < 0 || index >= state.length) return;
    
    final updatedTab = state[index].copyWith(
      content: content,
      isModified: true,
    );
    
    state = [
      ...state.take(index),
      updatedTab,
      ...state.skip(index + 1),
    ];
  }
}

// Provider for getting sample file content
final fileContentProvider = Provider.family<String, String>((ref, filePath) {
  // This is mock data - in a real IDE you'd read from the file system
  switch (filePath) {
    case 'lib/main.dart':
      return '''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app/app.dart';
import 'core/services/performance_service.dart';
import 'core/utils/platform_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize performance optimizations
  await _initializePerformanceOptimizations();
  
  // Initialize core services
  await _initializeCoreServices();
  
  runApp(
    const ProviderScope(
      child: RigIDEApp(),
    ),
  );
}

Future<void> _initializePerformanceOptimizations() async {
  // Enable hardware acceleration for Android
  if (PlatformUtils.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  }
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

Future<void> _initializeCoreServices() async {
  // Initialize performance monitoring
  await PerformanceService.initialize();
  
  // TODO: Initialize other core services
  // - File system service
  // - Git service
  // - Language server service
  // - Settings service
}''';
    case 'README.md':
      return '''# RigIDE - Mobile IDE

A high-performance mobile IDE for iOS and Android, inspired by VSCode and Cursor.

## 🏗️ Architecture

### Core Technologies

- **Flutter 3.19+** - Cross-platform UI framework with custom rendering
- **Dart** - Primary language for performance and productivity
- **Native Modules** - iOS (Swift) and Android (Kotlin) for performance-critical operations
- **Language Server Protocol (LSP)** - Code intelligence and IntelliSense
- **Tree-sitter** - Fast incremental parsing for syntax highlighting
- **libgit2** - Native Git operations

### Performance Optimizations

- Custom text editor with efficient syntax highlighting
- Virtual scrolling for large files
- Incremental compilation and analysis
- Memory-efficient file handling
- Native file system access
- Background processing for code analysis

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.19+
- Xcode 15+ (for iOS development)
- Android Studio with Android SDK 33+
- Dart SDK 3.3+

### Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/your-username/rigide.git
cd rigide

# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Run on macOS for testing
flutter run -d macos
\`\`\`

## 📁 Project Structure

\`\`\`
rigide/
├── lib/                    # Flutter application code
│   ├── core/              # Core utilities and services
│   ├── features/          # Feature-based modules
│   ├── ui/                # UI components and themes
│   └── main.dart          # Application entry point
├── ios/                   # iOS native code
├── android/               # Android native code
├── plugins/               # Custom native plugins
├── assets/                # Static assets
└── test/                  # Test files
\`\`\`''';
    case 'pubspec.yaml':
      return '''name: rigide
description: RigIDE - A high-performance mobile IDE for iOS and Android
publish_to: 'none'

version: 0.1.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: ">=3.19.0"

dependencies:
  flutter:
    sdk: flutter
  
  # UI and State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # File System Operations
  path_provider: ^2.1.2
  path: ^1.8.3
  
  # Storage
  shared_preferences: ^2.2.2
  
  # Utils
  uuid: ^4.3.3
  
  # Icons and Fonts
  cupertino_icons: ^1.0.2
  material_design_icons_flutter: ^7.0.7296
  
  # HTTP
  http: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  
  # Linting
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true''';
    case '.gitignore':
      return '''# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Symbolication related
app.*.symbols

# Obfuscation related
app.*.map.json

# Android Studio will place build artifacts here
/android/app/debug
/android/app/profile
/android/app/release''';
    default:
      return '''// File: $filePath

This is a sample file content for demonstration.
In a real IDE, this would be the actual file content loaded from the file system.

File path: $filePath
File type: ${filePath.split('.').last.toUpperCase()}

You can edit this content and see live changes in your mobile IDE!''';
  }
}); 