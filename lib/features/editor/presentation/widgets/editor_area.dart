import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';

class EditorArea extends ConsumerWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.editorBackground,
      child: Column(
        children: [
          // Tab bar
          Container(
            height: 35,
            color: AppColors.darkSurface,
            child: const Row(
              children: [
                _EditorTab(
                  filename: 'main.dart',
                  isActive: true,
                  isModified: true,
                ),
                _EditorTab(
                  filename: 'README.md',
                  isActive: false,
                  isModified: false,
                ),
              ],
            ),
          ),
          
          // Editor content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message (temporary)
                  Text(
                    'Welcome to RigIDE',
                    style: TextStyle(
                      color: AppColors.editorForeground,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A high-performance mobile IDE for iOS and Android',
                    style: TextStyle(
                      color: AppColors.editorForeground.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Features:',
                    style: TextStyle(
                      color: AppColors.editorForeground,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...['Code editor with syntax highlighting', 'File explorer', 'Git integration', 'Terminal emulator', 'Language Server Protocol support']
                      .map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '• $feature',
                              style: TextStyle(
                                color: AppColors.editorForeground.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorTab extends StatefulWidget {
  final String filename;
  final bool isActive;
  final bool isModified;

  const _EditorTab({
    required this.filename,
    required this.isActive,
    required this.isModified,
  });

  @override
  State<_EditorTab> createState() => _EditorTabState();
}

class _EditorTabState extends State<_EditorTab> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // TODO: Switch to this tab
        },
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.editorBackground
                : _isHovered
                    ? AppColors.darkSurface.withOpacity(0.8)
                    : Colors.transparent,
            border: widget.isActive
                ? null
                : const Border(
                    bottom: BorderSide(
                      color: AppColors.panelBorder,
                      width: 1,
                    ),
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // File icon (placeholder)
              Icon(
                _getFileIcon(widget.filename),
                size: 16,
                color: AppColors.editorForeground.withOpacity(0.8),
              ),
              const SizedBox(width: 8),
              
              // Filename
              Text(
                widget.filename,
                style: TextStyle(
                  color: widget.isActive
                      ? AppColors.editorForeground
                      : AppColors.editorForeground.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
              
              // Modified indicator
              if (widget.isModified) ...[
                const SizedBox(width: 4),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
              
              // Close button
              if (_isHovered) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Close tab
                  },
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.editorForeground.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getFileIcon(String filename) {
    final extension = filename.split('.').last;
    switch (extension) {
      case 'dart':
        return Icons.code;
      case 'md':
        return Icons.description;
      case 'json':
        return Icons.data_object;
      case 'yaml':
      case 'yml':
        return Icons.settings;
      default:
        return Icons.insert_drive_file;
    }
  }
} 