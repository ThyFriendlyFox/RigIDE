import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/editor_providers.dart';

class EditorArea extends ConsumerWidget {
  const EditorArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openedTabs = ref.watch(openedTabsProvider);
    final activeTabIndex = ref.watch(activeTabIndexProvider);
    
    return Container(
      color: AppColors.editorBackground,
      child: Column(
        children: [
          // Tab bar
          Container(
            height: 35,
            color: AppColors.darkSurface,
            child: Row(
              children: [
                ...openedTabs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tab = entry.value;
                  return _EditorTab(
                    filename: tab.name,
                    isActive: index == activeTabIndex,
                    isModified: tab.isModified,
                    onTap: () => ref.read(activeTabIndexProvider.notifier).state = index,
                    onClose: () {
                      ref.read(openedTabsProvider.notifier).closeTab(index);
                      // Adjust active tab index if necessary
                      if (activeTabIndex >= openedTabs.length - 1) {
                        ref.read(activeTabIndexProvider.notifier).state = 
                            (openedTabs.length - 2).clamp(0, openedTabs.length - 1);
                      }
                    },
                  );
                }),
              ],
            ),
          ),
          
          // Editor content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: activeTabIndex < openedTabs.length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // File path indicator
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            openedTabs[activeTabIndex].path,
                            style: TextStyle(
                              color: AppColors.editorForeground.withOpacity(0.6),
                              fontSize: 12,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                        
                        // File content (editable)
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                              text: openedTabs[activeTabIndex].content,
                            ),
                            maxLines: null,
                            expands: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: AppColors.editorForeground,
                              fontSize: 14,
                              fontFamily: 'Courier',
                              height: 1.4,
                            ),
                            onChanged: (newContent) {
                              ref.read(openedTabsProvider.notifier)
                                  .updateTabContent(activeTabIndex, newContent);
                            },
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        'No file open',
                        style: TextStyle(
                          color: AppColors.editorForeground.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
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
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const _EditorTab({
    required this.filename,
    required this.isActive,
    required this.isModified,
    this.onTap,
    this.onClose,
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
        onTap: widget.onTap,
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
                  onTap: widget.onClose,
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