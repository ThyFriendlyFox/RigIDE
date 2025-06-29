import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

class SearchPanel extends ConsumerWidget {
  const SearchPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: AppColors.editorForeground.withOpacity(0.5),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: AppColors.editorForeground.withOpacity(0.7),
              ),
            ),
            style: TextStyle(
              color: AppColors.editorForeground,
              fontSize: 13,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Replace input
          TextField(
            decoration: InputDecoration(
              hintText: 'Replace',
              hintStyle: TextStyle(
                color: AppColors.editorForeground.withOpacity(0.5),
              ),
              suffixIcon: Icon(
                Icons.find_replace,
                color: AppColors.editorForeground.withOpacity(0.7),
              ),
            ),
            style: TextStyle(
              color: AppColors.editorForeground,
              fontSize: 13,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Search options
          Row(
            children: [
              _SearchOptionButton(
                icon: Icons.text_fields,
                tooltip: 'Match Case',
                isActive: false,
              ),
              const SizedBox(width: 8),
              _SearchOptionButton(
                icon: Icons.text_format,
                tooltip: 'Match Whole Word',
                isActive: false,
              ),
              const SizedBox(width: 8),
              _SearchOptionButton(
                icon: Icons.code,
                tooltip: 'Use Regular Expression',
                isActive: false,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Results section
          Text(
            'No results found',
            style: TextStyle(
              color: AppColors.editorForeground.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchOptionButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isActive;

  const _SearchOptionButton({
    required this.icon,
    required this.tooltip,
    required this.isActive,
  });

  @override
  State<_SearchOptionButton> createState() => _SearchOptionButtonState();
}

class _SearchOptionButtonState extends State<_SearchOptionButton> {
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
            // TODO: Toggle search option
          },
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.primary.withOpacity(0.3)
                  : _isHovered
                      ? AppColors.editorForeground.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
              border: widget.isActive
                  ? Border.all(color: AppColors.primary, width: 1)
                  : null,
            ),
            child: Icon(
              widget.icon,
              size: 16,
              color: widget.isActive
                  ? AppColors.primary
                  : AppColors.editorForeground.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
} 