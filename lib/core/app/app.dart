import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../routing/app_router.dart';
import '../../features/editor/presentation/screens/main_screen.dart';

class RigIDEApp extends ConsumerWidget {
  const RigIDEApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'RigIDE',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          // Disable font scaling for consistent IDE experience
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      
      // Initial route
      home: const MainScreen(),
      
      // TODO: Add proper routing when needed
      // onGenerateRoute: AppRouter.generateRoute,
    );
  }
} 