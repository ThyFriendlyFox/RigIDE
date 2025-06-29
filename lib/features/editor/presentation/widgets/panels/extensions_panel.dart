import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

class ExtensionsPanel extends ConsumerWidget {
  const ExtensionsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search extensions',
              hintStyle: TextStyle(
                color: AppColors.editorForeground.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.editorForeground.withOpacity(0.7),
              ),
            ),
            style: TextStyle(
              color: AppColors.editorForeground,
              fontSize: 14,
            ),
          ),
        ),
        
        // Extension categories
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _ExtensionCategory(
                title: 'Installed',
                isSelected: true,
                onTap: () {
                  // TODO: Show installed extensions
                },
              ),
              const SizedBox(width: 16),
              _ExtensionCategory(
                title: 'Popular',
                isSelected: false,
                onTap: () {
                  // TODO: Show popular extensions
                },
              ),
              const SizedBox(width: 16),
              _ExtensionCategory(
                title: 'Recommended',
                isSelected: false,
                onTap: () {
                  // TODO: Show recommended extensions
                },
              ),
            ],
          ),
        ),
        
        // Extensions list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ExtensionItem(
                name: 'Dart',
                description: 'Rich support for the Dart programming language',
                author: 'Dart Code',
                isInstalled: true,
                rating: 4.5,
                downloads: '2.5M',
              ),
              _ExtensionItem(
                name: 'Flutter',
                description: 'Flutter support and debugger for Flutter projects',
                author: 'Dart Code',
                isInstalled: true,
                rating: 4.8,
                downloads: '1.8M',
              ),
              _ExtensionItem(
                name: 'Git Lens',
                description: 'Supercharge Git within your IDE',
                author: 'GitKraken',
                isInstalled: false,
                rating: 4.6,
                downloads: '12M',
              ),
              _ExtensionItem(
                name: 'Material Icon Theme',
                description: 'Material Design icons for your file explorer',
                author: 'Philipp Kief',
                isInstalled: false,
                rating: 4.7,
                downloads: '8.2M',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExtensionCategory extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ExtensionCategory({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.primary
                : AppColors.editorForeground.withOpacity(0.8),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ExtensionItem extends StatefulWidget {
  final String name;
  final String description;
  final String author;
  final bool isInstalled;
  final double rating;
  final String downloads;

  const _ExtensionItem({
    required this.name,
    required this.description,
    required this.author,
    required this.isInstalled,
    required this.rating,
    required this.downloads,
  });

  @override
  State<_ExtensionItem> createState() => _ExtensionItemState();
}

class _ExtensionItemState extends State<_ExtensionItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.fileExplorerHover
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.panelBorder.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Extension icon placeholder
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.extension,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Extension info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: AppColors.editorForeground,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.author,
                        style: TextStyle(
                          color: AppColors.editorForeground.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Install/Uninstall button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Install/uninstall extension
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isInstalled
                        ? AppColors.darkSurface
                        : AppColors.primary,
                    foregroundColor: widget.isInstalled
                        ? AppColors.editorForeground
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    widget.isInstalled ? 'Uninstall' : 'Install',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              widget.description,
              style: TextStyle(
                color: AppColors.editorForeground.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Stats
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating.toString(),
                      style: TextStyle(
                        color: AppColors.editorForeground.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // Downloads
                Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: 14,
                      color: AppColors.editorForeground.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.downloads,
                      style: TextStyle(
                        color: AppColors.editorForeground.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 