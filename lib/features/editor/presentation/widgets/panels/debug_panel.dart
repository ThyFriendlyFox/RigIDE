import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

class DebugPanel extends ConsumerWidget {
  const DebugPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Run and debug section
          _DebugSection(
            title: 'RUN AND DEBUG',
            children: [
              _DebugAction(
                icon: Icons.play_arrow,
                title: 'Run app',
                subtitle: 'flutter run',
                onTap: () {
                  // TODO: Run the app
                },
              ),
              _DebugAction(
                icon: Icons.bug_report,
                title: 'Debug app',
                subtitle: 'flutter run --debug',
                onTap: () {
                  // TODO: Debug the app
                },
              ),
              _DebugAction(
                icon: Icons.code,
                title: 'Run tests',
                subtitle: 'flutter test',
                onTap: () {
                  // TODO: Run tests
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Variables section (when debugging)
          _DebugSection(
            title: 'VARIABLES',
            children: [
              Text(
                'No variables to display',
                style: TextStyle(
                  color: AppColors.editorForeground.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Call stack section (when debugging)
          _DebugSection(
            title: 'CALL STACK',
            children: [
              Text(
                'No call stack to display',
                style: TextStyle(
                  color: AppColors.editorForeground.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Breakpoints section
          _DebugSection(
            title: 'BREAKPOINTS',
            children: [
              Text(
                'No breakpoints set',
                style: TextStyle(
                  color: AppColors.editorForeground.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DebugSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DebugSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.panelTitle,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _DebugAction extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DebugAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_DebugAction> createState() => _DebugActionState();
}

class _DebugActionState extends State<_DebugAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.fileExplorerHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: AppColors.editorForeground,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: AppColors.editorForeground.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 