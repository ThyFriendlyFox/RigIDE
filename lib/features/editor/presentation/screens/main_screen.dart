import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/activity_bar.dart';
import '../widgets/sidebar.dart';
import '../widgets/editor_area.dart';
import '../widgets/status_bar.dart';
import '../widgets/panels/terminal_panel.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _isTerminalVisible = false;
  
  void _toggleTerminal() {
    setState(() {
      _isTerminalVisible = !_isTerminalVisible;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: Column(
                children: [
                  // Top row with activity bar, sidebar, and editor
                  Expanded(
                    flex: _isTerminalVisible ? 7 : 10,
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
                  
                  // Terminal panel (when visible)
                  if (_isTerminalVisible)
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.panelBorder, width: 1),
                          ),
                        ),
                        child: const TerminalPanel(),
                      ),
                    ),
                ],
              ),
            ),
            
            // Status bar (bottom)
            StatusBar(
              onTerminalToggle: _toggleTerminal,
              isTerminalVisible: _isTerminalVisible,
            ),
          ],
        ),
      ),
    );
  }
} 