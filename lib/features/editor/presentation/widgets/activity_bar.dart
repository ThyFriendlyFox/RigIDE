import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

// Provider for selected activity
final selectedActivityProvider = StateProvider<ActivityType>((ref) => ActivityType.explorer);

enum ActivityType {
  explorer,
  search,
  sourceControl,
  debug,
  extensions,
  settings,
}

class ActivityBar extends ConsumerWidget {
  const ActivityBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivity = ref.watch(selectedActivityProvider);
    
    return Container(
      width: 48,
      color: AppColors.activityBarBackground,
      child: Column(
        children: [
          // Top activities
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _ActivityBarItem(
                  icon: Icons.folder_outlined,
                  type: ActivityType.explorer,
                  isSelected: selectedActivity == ActivityType.explorer,
                  onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.explorer,
                  tooltip: 'Explorer',
                ),
                _ActivityBarItem(
                  icon: Icons.search,
                  type: ActivityType.search,
                  isSelected: selectedActivity == ActivityType.search,
                  onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.search,
                  tooltip: 'Search',
                ),
                _ActivityBarItem(
                  icon: Icons.account_tree,
                  type: ActivityType.sourceControl,
                  isSelected: selectedActivity == ActivityType.sourceControl,
                  onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.sourceControl,
                  tooltip: 'Source Control',
                ),
                _ActivityBarItem(
                  icon: Icons.bug_report,
                  type: ActivityType.debug,
                  isSelected: selectedActivity == ActivityType.debug,
                  onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.debug,
                  tooltip: 'Debug',
                ),
                _ActivityBarItem(
                  icon: Icons.extension,
                  type: ActivityType.extensions,
                  isSelected: selectedActivity == ActivityType.extensions,
                  onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.extensions,
                  tooltip: 'Extensions',
                ),
              ],
            ),
          ),
          
          // Bottom activities
          Column(
            children: [
              _ActivityBarItem(
                icon: Icons.settings,
                type: ActivityType.settings,
                isSelected: selectedActivity == ActivityType.settings,
                onTap: () => ref.read(selectedActivityProvider.notifier).state = ActivityType.settings,
                tooltip: 'Settings',
              ),
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityBarItem extends StatefulWidget {
  final IconData icon;
  final ActivityType type;
  final bool isSelected;
  final VoidCallback onTap;
  final String tooltip;

  const _ActivityBarItem({
    required this.icon,
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_ActivityBarItem> createState() => _ActivityBarItemState();
}

class _ActivityBarItemState extends State<_ActivityBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      preferBelow: false,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.isSelected 
                  ? AppColors.activityBarForeground.withOpacity(0.1)
                  : _isHovered
                      ? AppColors.activityBarForeground.withOpacity(0.05)
                      : Colors.transparent,
              border: widget.isSelected
                  ? const Border(
                      left: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    )
                  : null,
            ),
            child: Icon(
              widget.icon,
              size: 24,
              color: widget.isSelected
                  ? AppColors.activityBarForeground
                  : AppColors.activityBarInactiveForeground,
            ),
          ),
        ),
      ),
    );
  }
} 