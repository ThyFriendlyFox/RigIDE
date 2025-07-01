import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

class StatusBar extends ConsumerWidget {
  final VoidCallback? onTerminalToggle;
  final bool isTerminalVisible;
  
  const StatusBar({
    super.key,
    this.onTerminalToggle,
    this.isTerminalVisible = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 24,
      color: AppColors.statusBarBackground,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Left side items
          const _StatusBarItem(
            icon: Icons.account_tree,
            text: 'main',
            tooltip: 'Git branch',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            icon: Icons.sync_problem,
            text: '0',
            tooltip: 'Sync changes',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            icon: Icons.error_outline,
            text: '0',
            tooltip: 'Errors',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            icon: Icons.warning,
            text: '0',
            tooltip: 'Warnings',
          ),
          
          const Spacer(),
          
          // Terminal toggle button
          GestureDetector(
            onTap: onTerminalToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isTerminalVisible 
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.terminal,
                    size: 14,
                    color: isTerminalVisible 
                        ? AppColors.primary 
                        : AppColors.statusBarForeground,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Terminal',
                    style: TextStyle(
                      color: isTerminalVisible 
                          ? AppColors.primary 
                          : AppColors.statusBarForeground,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Right side items
          const _StatusBarItem(
            text: 'UTF-8',
            tooltip: 'File encoding',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            text: 'LF',
            tooltip: 'Line endings',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            text: 'Dart',
            tooltip: 'Language mode',
          ),
          const SizedBox(width: 16),
          const _StatusBarItem(
            text: 'Ln 1, Col 1',
            tooltip: 'Cursor position',
          ),
        ],
      ),
    );
  }
}

class _StatusBarItem extends StatefulWidget {
  final IconData? icon;
  final String text;
  final String tooltip;

  const _StatusBarItem({
    this.icon,
    required this.text,
    required this.tooltip,
  });

  @override
  State<_StatusBarItem> createState() => _StatusBarItemState();
}

class _StatusBarItemState extends State<_StatusBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            // TODO: Handle status bar item tap
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.statusBarForeground.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 14,
                    color: AppColors.statusBarForeground,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: AppColors.statusBarForeground,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 