import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/activity_bar.dart';
import '../widgets/sidebar.dart';
import '../widgets/editor_area.dart';
import '../widgets/status_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Row(
                children: [
                  // Activity Bar (left side)
                  const ActivityBar(),
                  
                  // Sidebar (file explorer, search, etc.)
                  const Sidebar(),
                  
                  // Main editor area
                  const Expanded(
                    child: EditorArea(),
                  ),
                ],
              ),
            ),
            
            // Status bar (bottom)
            const StatusBar(),
          ],
        ),
      ),
    );
  }
} 