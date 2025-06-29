import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

class SourceControlPanel extends ConsumerWidget {
  const SourceControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Actions bar
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _ActionButton(
                icon: Icons.refresh,
                tooltip: 'Refresh',
                onTap: () {
                  // TODO: Refresh git status
                },
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.add,
                tooltip: 'Stage All Changes',
                onTap: () {
                  // TODO: Stage all changes
                },
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.commit,
                tooltip: 'Commit',
                onTap: () {
                  // TODO: Show commit dialog
                },
              ),
              const Spacer(),
              _ActionButton(
                icon: Icons.more_vert,
                tooltip: 'More Actions',
                onTap: () {
                  // TODO: Show more actions
                },
              ),
            ],
          ),
        ),
        
        // Commit message input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Message (press Ctrl+Enter to commit)',
              hintStyle: TextStyle(
                color: AppColors.editorForeground.withOpacity(0.5),
                fontSize: 12,
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
            style: TextStyle(
              color: AppColors.editorForeground,
              fontSize: 13,
            ),
            maxLines: 3,
            minLines: 1,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Changes section
        Expanded(
          child: ListView(
            children: [
              _ChangesSection(
                title: 'Changes',
                count: 3,
                children: [
                  _FileChangeItem(
                    filename: 'lib/main.dart',
                    status: GitStatus.modified,
                  ),
                  _FileChangeItem(
                    filename: 'pubspec.yaml',
                    status: GitStatus.modified,
                  ),
                  _FileChangeItem(
                    filename: 'lib/core/theme/app_colors.dart',
                    status: GitStatus.added,
                  ),
                ],
              ),
              
              _ChangesSection(
                title: 'Staged Changes',
                count: 0,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.editorForeground.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: AppColors.editorForeground.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangesSection extends StatefulWidget {
  final String title;
  final int count;
  final List<Widget> children;

  const _ChangesSection({
    required this.title,
    required this.count,
    required this.children,
  });

  @override
  State<_ChangesSection> createState() => _ChangesSectionState();
}

class _ChangesSectionState extends State<_ChangesSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  color: AppColors.editorForeground.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.title} (${widget.count})',
                  style: TextStyle(
                    color: AppColors.editorForeground.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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

enum GitStatus { added, modified, deleted, untracked, conflict }

class _FileChangeItem extends StatefulWidget {
  final String filename;
  final GitStatus status;

  const _FileChangeItem({
    required this.filename,
    required this.status,
  });

  @override
  State<_FileChangeItem> createState() => _FileChangeItemState();
}

class _FileChangeItemState extends State<_FileChangeItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // TODO: Open diff view
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          color: _isHovered
              ? AppColors.fileExplorerHover
              : Colors.transparent,
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Text(
                    _getStatusChar(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Filename
              Expanded(
                child: Text(
                  widget.filename,
                  style: TextStyle(
                    color: AppColors.editorForeground.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ),
              
              // Actions
              if (_isHovered) ...[
                GestureDetector(
                  onTap: () {
                    // TODO: Stage/unstage file
                  },
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.editorForeground.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // TODO: Discard changes
                  },
                  child: Icon(
                    Icons.undo,
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
  
  Color _getStatusColor() {
    switch (widget.status) {
      case GitStatus.added:
        return AppColors.gitAdded;
      case GitStatus.modified:
        return AppColors.gitModified;
      case GitStatus.deleted:
        return AppColors.gitDeleted;
      case GitStatus.untracked:
        return AppColors.gitAdded;
      case GitStatus.conflict:
        return AppColors.gitConflict;
    }
  }
  
  String _getStatusChar() {
    switch (widget.status) {
      case GitStatus.added:
        return 'A';
      case GitStatus.modified:
        return 'M';
      case GitStatus.deleted:
        return 'D';
      case GitStatus.untracked:
        return 'U';
      case GitStatus.conflict:
        return 'C';
    }
  }
} 