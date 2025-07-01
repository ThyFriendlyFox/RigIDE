import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../providers/editor_providers.dart';

class ExplorerPanel extends ConsumerWidget {
  const ExplorerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Project section
        _ExplorerSection(
          title: 'RIGIDE',
          isExpanded: true,
          children: [
            _FileTreeItem(
              name: '.vscode',
              type: FileType.folder,
              level: 0,
              isExpanded: false,
            ),
            _FileTreeItem(
              name: 'assets',
              type: FileType.folder,
              level: 0,
              isExpanded: true,
              children: [
                _FileTreeItem(
                  name: 'fonts',
                  type: FileType.folder,
                  level: 1,
                ),
                _FileTreeItem(
                  name: 'icons',
                  type: FileType.folder,
                  level: 1,
                ),
                _FileTreeItem(
                  name: 'images',
                  type: FileType.folder,
                  level: 1,
                ),
              ],
            ),
            _FileTreeItem(
              name: 'lib',
              type: FileType.folder,
              level: 0,
              isExpanded: true,
              children: [
                _FileTreeItem(
                  name: 'core',
                  type: FileType.folder,
                  level: 1,
                  isExpanded: true,
                  children: [
                    _FileTreeItem(
                      name: 'app',
                      type: FileType.folder,
                      level: 2,
                    ),
                    _FileTreeItem(
                      name: 'services',
                      type: FileType.folder,
                      level: 2,
                    ),
                    _FileTreeItem(
                      name: 'theme',
                      type: FileType.folder,
                      level: 2,
                    ),
                  ],
                ),
                _FileTreeItem(
                  name: 'features',
                  type: FileType.folder,
                  level: 1,
                ),
                _FileTreeItem(
                  name: 'main.dart',
                  type: FileType.file,
                  level: 1,
                ),
              ],
            ),
            _FileTreeItem(
              name: '.gitignore',
              type: FileType.file,
              level: 0,
            ),
            _FileTreeItem(
              name: 'pubspec.yaml',
              type: FileType.file,
              level: 0,
            ),
            _FileTreeItem(
              name: 'README.md',
              type: FileType.file,
              level: 0,
            ),
          ],
        ),
      ],
    );
  }
}

class _ExplorerSection extends StatefulWidget {
  final String title;
  final bool isExpanded;
  final List<Widget> children;

  const _ExplorerSection({
    required this.title,
    required this.isExpanded,
    required this.children,
  });

  @override
  State<_ExplorerSection> createState() => _ExplorerSectionState();
}

class _ExplorerSectionState extends State<_ExplorerSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  size: 16,
                  color: AppColors.panelTitle,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: AppColors.panelTitle,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...widget.children,
      ],
    );
  }
}

enum FileType { file, folder }

class _FileTreeItem extends ConsumerStatefulWidget {
  final String name;
  final FileType type;
  final int level;
  final bool isExpanded;
  final List<_FileTreeItem> children;

  const _FileTreeItem({
    required this.name,
    required this.type,
    required this.level,
    this.isExpanded = false,
    this.children = const [],
  });

  @override
  ConsumerState<_FileTreeItem> createState() => _FileTreeItemState();
}

class _FileTreeItemState extends ConsumerState<_FileTreeItem> {
  bool _isHovered = false;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    // Check if this file is currently selected
    final openedTabs = ref.watch(openedTabsProvider);
    final activeTabIndex = ref.watch(activeTabIndexProvider);
    
    final isSelected = activeTabIndex < openedTabs.length && 
                      openedTabs[activeTabIndex].name == widget.name;
    
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () {
              if (widget.type == FileType.folder) {
                setState(() => _isExpanded = !_isExpanded);
              } else {
                _openFile();
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 8.0 + (widget.level * 16),
                right: 8,
                top: 2,
                bottom: 2,
              ),
              color: isSelected
                  ? AppColors.fileExplorerSelection
                  : _isHovered
                      ? AppColors.fileExplorerHover
                      : Colors.transparent,
              child: Row(
                children: [
                  // Expand/collapse icon for folders
                  if (widget.type == FileType.folder)
                    Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      size: 16,
                      color: AppColors.editorForeground.withOpacity(0.6),
                    )
                  else
                    const SizedBox(width: 16),
                  
                  const SizedBox(width: 4),
                  
                  // File/folder icon
                  Icon(
                    _getIcon(),
                    size: 16,
                    color: _getIconColor(),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Name
                  Expanded(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.editorForeground
                            : AppColors.editorForeground.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Children (if folder is expanded)
        if (widget.type == FileType.folder && _isExpanded)
          ...widget.children,
      ],
    );
  }
  
  void _openFile() {
    // Build the file path based on the tree structure
    String filePath = widget.name;
    
    // Add appropriate prefixes based on context
    if (widget.level == 1 && widget.name == 'main.dart') {
      filePath = 'lib/main.dart';
    } else if (widget.level == 0) {
      filePath = widget.name;
    } else {
      // For nested files, we'll use a simple path for now
      filePath = widget.name;
    }
    
    // Get file content using the provider
    final content = ref.read(fileContentProvider(filePath));
    
    // Open the file in the editor (returns the tab index)
    final tabIndex = ref.read(openedTabsProvider.notifier).openFile(
      widget.name,
      filePath,
      content,
    );
    
    // Set this as the active tab
    ref.read(activeTabIndexProvider.notifier).state = tabIndex;
  }
  
  IconData _getIcon() {
    if (widget.type == FileType.folder) {
      return _isExpanded ? Icons.folder_open : Icons.folder;
    }
    
    // File icons based on extension
    final extension = widget.name.split('.').last.toLowerCase();
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
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Icons.image;
      case 'gitignore':
        return Icons.visibility_off;
      default:
        return Icons.insert_drive_file;
    }
  }
  
  Color _getIconColor() {
    if (widget.type == FileType.folder) {
      return AppColors.primary;
    }
    
    final extension = widget.name.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return Colors.blue;
      case 'md':
        return Colors.orange;
      case 'json':
        return Colors.yellow;
      case 'yaml':
      case 'yml':
        return Colors.purple;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return Colors.green;
      default:
        return AppColors.editorForeground.withOpacity(0.7);
    }
  }
} 