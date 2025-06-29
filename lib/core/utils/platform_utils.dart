import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
  
  static String get operatingSystem {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystem;
  }
  
  static String get operatingSystemVersion {
    if (kIsWeb) return 'N/A';
    return Platform.operatingSystemVersion;
  }
  
  /// Returns whether the device supports high refresh rate displays
  static bool get supportsHighRefreshRate {
    // Most modern Android devices support high refresh rate
    // iOS devices from iPhone 13 Pro onwards support ProMotion (120Hz)
    return isAndroid || isIOS;
  }
  
  /// Returns whether the device supports hardware acceleration
  static bool get supportsHardwareAcceleration {
    return isMobile;
  }
  
  /// Returns whether the device supports multiple windows/tabs
  static bool get supportsMultiWindow {
    // Android supports split screen, iOS supports slide over/split view
    return isMobile;
  }
  
  /// Returns whether the device has a physical keyboard
  static bool get hasPhysicalKeyboard {
    // This is a best guess - on mobile, most users don't have physical keyboards
    // This could be enhanced with actual detection logic
    return isDesktop;
  }
  
  /// Returns the recommended number of isolates for background processing
  static int get recommendedIsolateCount {
    // Conservative approach for mobile devices to preserve battery
    if (isMobile) return 2;
    if (isDesktop) return 4;
    return 1;
  }
  
  /// Returns whether the device supports file system watching
  static bool get supportsFileSystemWatching {
    return !isWeb;
  }
  
  /// Returns whether the device supports native terminal
  static bool get supportsNativeTerminal {
    return !isWeb;
  }
} 