import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class PerformanceService {
  static PerformanceService? _instance;
  static PerformanceService get instance => _instance ??= PerformanceService._();
  
  PerformanceService._();
  
  bool _isInitialized = false;
  Timer? _memoryMonitorTimer;
  
  // Performance metrics
  int _frameDropCount = 0;
  double _avgFrameTime = 0.0;
  List<double> _frameTimes = [];
  
  static Future<void> initialize() async {
    await instance._initialize();
  }
  
  Future<void> _initialize() async {
    if (_isInitialized) return;
    
    // Start performance monitoring in debug mode
    if (kDebugMode) {
      _startFrameMonitoring();
      _startMemoryMonitoring();
    }
    
    _isInitialized = true;
    developer.log('PerformanceService initialized', name: 'Performance');
  }
  
  void _startFrameMonitoring() {
    // Monitor frame rendering performance
    WidgetsBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
      for (final timing in timings) {
        final frameTime = timing.totalSpan.inMicroseconds / 1000.0; // Convert to milliseconds
        _frameTimes.add(frameTime);
        
        // Keep only last 60 frame times (1 second at 60fps)
        if (_frameTimes.length > 60) {
          _frameTimes.removeAt(0);
        }
        
        // Calculate average frame time
        _avgFrameTime = _frameTimes.reduce((a, b) => a + b) / _frameTimes.length;
        
        // Count frame drops (frames that take longer than 16.67ms at 60fps)
        if (frameTime > 16.67) {
          _frameDropCount++;
        }
        
        // Log performance warnings
        if (frameTime > 33.33) { // 2 frames dropped
          developer.log(
            'Frame drop detected: ${frameTime.toStringAsFixed(2)}ms',
            name: 'Performance',
            level: 900, // Warning level
          );
        }
      }
    });
  }
  
  void _startMemoryMonitoring() {
    // Monitor memory usage every 10 seconds
    _memoryMonitorTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkMemoryUsage();
    });
  }
  
  Future<void> _checkMemoryUsage() async {
    try {
      // This is a simplified memory check
      // In a real implementation, you'd use platform-specific methods
      const channel = MethodChannel('performance/memory');
      final memoryInfo = await channel.invokeMethod('getMemoryInfo');
      
      if (memoryInfo != null) {
        final usedMemory = memoryInfo['used'] as int?;
        final totalMemory = memoryInfo['total'] as int?;
        
        if (usedMemory != null && totalMemory != null) {
          final memoryUsagePercent = (usedMemory / totalMemory) * 100;
          
          if (memoryUsagePercent > 80) {
            developer.log(
              'High memory usage: ${memoryUsagePercent.toStringAsFixed(1)}%',
              name: 'Performance',
              level: 900,
            );
            
            // Suggest garbage collection
            _suggestGarbageCollection();
          }
        }
      }
    } catch (e) {
      // Ignore errors in memory monitoring
      developer.log('Memory monitoring error: $e', name: 'Performance');
    }
  }
  
  void _suggestGarbageCollection() {
    // Force garbage collection if memory usage is high
    // Note: This should be used sparingly as it can cause frame drops
    if (kDebugMode) {
      developer.log('Suggesting garbage collection', name: 'Performance');
    }
  }
  
  // Public API for performance metrics
  
  /// Returns the current average frame time in milliseconds
  double get averageFrameTime => _avgFrameTime;
  
  /// Returns the number of dropped frames since initialization
  int get frameDropCount => _frameDropCount;
  
  /// Returns whether the app is currently performing well
  bool get isPerformingWell {
    return _avgFrameTime < 16.67 && _frameDropCount < 10;
  }
  
  /// Logs a custom performance marker
  void logPerformanceMarker(String name, {int? duration, Map<String, dynamic>? data}) {
    if (kDebugMode) {
      final message = duration != null 
          ? '$name completed in ${duration}ms'
          : '$name marker';
      
      developer.log(
        message,
        name: 'Performance',
        level: 800, // Info level
      );
      
      if (data != null) {
        developer.log('Data: $data', name: 'Performance');
      }
    }
  }
  
  /// Times a function execution
  Future<T> timeFunction<T>(String name, Future<T> Function() function) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await function();
      stopwatch.stop();
      logPerformanceMarker(name, duration: stopwatch.elapsedMilliseconds);
      return result;
    } catch (e) {
      stopwatch.stop();
      logPerformanceMarker('$name (error)', duration: stopwatch.elapsedMilliseconds);
      rethrow;
    }
  }
  
  /// Disposes the performance service
  void dispose() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;
    _isInitialized = false;
  }
} 