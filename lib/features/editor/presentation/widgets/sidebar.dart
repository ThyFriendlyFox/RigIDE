import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import 'activity_bar.dart';
import 'panels/explorer_panel.dart';
import 'panels/search_panel.dart';
import 'panels/source_control_panel.dart';
import 'panels/debug_panel.dart';
import 'panels/extensions_panel.dart';
import 'panels/settings_panel.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivity = ref.watch(selectedActivityProvider);
    
    return Container(
      width: 300,
      color: AppColors.fileExplorerBackground,
      child: Column(
        children: [
          // Panel header
          Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.panelBorder,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  _getPanelTitle(selectedActivity),
                  style: const TextStyle(
                    color: AppColors.panelTitle,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // Panel actions will go here
              ],
            ),
          ),
          
          // Panel content
          Expanded(
            child: _buildPanelContent(selectedActivity),
          ),
        ],
      ),
    );
  }
  
  String _getPanelTitle(ActivityType activity) {
    switch (activity) {
      case ActivityType.explorer:
        return 'EXPLORER';
      case ActivityType.search:
        return 'SEARCH';
      case ActivityType.sourceControl:
        return 'SOURCE CONTROL';
      case ActivityType.debug:
        return 'DEBUG';
      case ActivityType.extensions:
        return 'EXTENSIONS';
      case ActivityType.settings:
        return 'SETTINGS';
    }
  }
  
  Widget _buildPanelContent(ActivityType activity) {
    switch (activity) {
      case ActivityType.explorer:
        return const ExplorerPanel();
      case ActivityType.search:
        return const SearchPanel();
      case ActivityType.sourceControl:
        return const SourceControlPanel();
      case ActivityType.debug:
        return const DebugPanel();
      case ActivityType.extensions:
        return const ExtensionsPanel();
      case ActivityType.settings:
        return const SettingsPanel();
    }
  }
} 