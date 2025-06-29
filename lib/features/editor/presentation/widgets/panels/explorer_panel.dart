import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

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
                  isSelected: true,
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

class _FileTreeItem extends StatefulWidget {
  final String name;
  final FileType type;
  final int level;
  final bool isExpanded;
  final bool isSelected;
  final List<_FileTreeItem> children;

  const _FileTreeItem({
    required this.name,
    required this.type,
    required this.level,
    this.isExpanded = false,
    this.isSelected = false,
    this.children = const [],
  });

  @override
  State<_FileTreeItem> createState() => _FileTreeItemState();
}

class _FileTreeItemState extends State<_FileTreeItem> {
  bool _isHovered = false;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
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
                // TODO: Open file
              }
            },
            child: Container(
              padding: EdgeInsets.only(
                left: 8.0 + (widget.level * 16),
                right: 8,
                top: 2,
                bottom: 2,
              ),
              color: widget.isSelected
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
                        color: widget.isSelected
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