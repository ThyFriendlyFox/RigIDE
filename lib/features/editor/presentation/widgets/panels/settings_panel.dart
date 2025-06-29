import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';

class SettingsPanel extends ConsumerWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SettingsSection(
          title: 'Appearance',
          children: [
            _SettingsItem(
              title: 'Theme',
              subtitle: 'Choose your preferred theme',
              child: _ThemeSelector(),
            ),
            _SettingsItem(
              title: 'Font Size',
              subtitle: 'Adjust editor font size',
              child: _FontSizeSlider(),
            ),
            _SettingsItem(
              title: 'Font Family',
              subtitle: 'Choose editor font family',
              child: _FontFamilyDropdown(),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _SettingsSection(
          title: 'Editor',
          children: [
            _SettingsItem(
              title: 'Tab Size',
              subtitle: 'Number of spaces for tab indentation',
              child: _TabSizeSelector(),
            ),
            _SettingsItem(
              title: 'Word Wrap',
              subtitle: 'Enable word wrapping in editor',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update word wrap setting
                },
              ),
            ),
            _SettingsItem(
              title: 'Show Line Numbers',
              subtitle: 'Display line numbers in editor',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update line numbers setting
                },
              ),
            ),
            _SettingsItem(
              title: 'Auto Save',
              subtitle: 'Automatically save changes',
              child: _ToggleSwitch(
                value: false,
                onChanged: (value) {
                  // TODO: Update auto save setting
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _SettingsSection(
          title: 'Git',
          children: [
            _SettingsItem(
              title: 'Auto Fetch',
              subtitle: 'Automatically fetch remote changes',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update auto fetch setting
                },
              ),
            ),
            _SettingsItem(
              title: 'Show Git Status',
              subtitle: 'Show Git status in file explorer',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update git status setting
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _SettingsSection(
          title: 'Performance',
          children: [
            _SettingsItem(
              title: 'Enable Performance Monitoring',
              subtitle: 'Monitor app performance metrics',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update performance monitoring setting
                },
              ),
            ),
            _SettingsItem(
              title: 'High Refresh Rate',
              subtitle: 'Use high refresh rate display',
              child: _ToggleSwitch(
                value: true,
                onChanged: (value) {
                  // TODO: Update high refresh rate setting
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.panelTitle,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.editorForeground,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.editorForeground.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          child,
        ],
      ),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return DropdownButton<ThemeMode>(
      value: themeMode,
      onChanged: (ThemeMode? newValue) {
        if (newValue != null) {
          ref.read(themeModeProvider.notifier).state = newValue;
        }
      },
      dropdownColor: AppColors.darkSurface,
      items: const [
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text('Light', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text('Dark', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text('System', style: TextStyle(color: AppColors.editorForeground)),
        ),
      ],
    );
  }
}

class _FontSizeSlider extends StatefulWidget {
  @override
  State<_FontSizeSlider> createState() => _FontSizeSliderState();
}

class _FontSizeSliderState extends State<_FontSizeSlider> {
  double _fontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${_fontSize.toInt()}px',
          style: TextStyle(
            color: AppColors.editorForeground.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Slider(
            value: _fontSize,
            min: 10.0,
            max: 24.0,
            divisions: 14,
            onChanged: (value) {
              setState(() {
                _fontSize = value;
              });
              // TODO: Update font size setting
            },
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}

class _FontFamilyDropdown extends StatefulWidget {
  @override
  State<_FontFamilyDropdown> createState() => _FontFamilyDropdownState();
}

class _FontFamilyDropdownState extends State<_FontFamilyDropdown> {
  String _fontFamily = 'JetBrainsMono';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _fontFamily,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _fontFamily = newValue;
          });
          // TODO: Update font family setting
        }
      },
      dropdownColor: AppColors.darkSurface,
      items: const [
        DropdownMenuItem(
          value: 'JetBrainsMono',
          child: Text('JetBrains Mono', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: 'FiraCode',
          child: Text('Fira Code', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: 'Courier',
          child: Text('Courier', style: TextStyle(color: AppColors.editorForeground)),
        ),
      ],
    );
  }
}

class _TabSizeSelector extends StatefulWidget {
  @override
  State<_TabSizeSelector> createState() => _TabSizeSelectorState();
}

class _TabSizeSelectorState extends State<_TabSizeSelector> {
  int _tabSize = 2;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _tabSize,
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            _tabSize = newValue;
          });
          // TODO: Update tab size setting
        }
      },
      dropdownColor: AppColors.darkSurface,
      items: const [
        DropdownMenuItem(
          value: 2,
          child: Text('2 spaces', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: 4,
          child: Text('4 spaces', style: TextStyle(color: AppColors.editorForeground)),
        ),
        DropdownMenuItem(
          value: 8,
          child: Text('8 spaces', style: TextStyle(color: AppColors.editorForeground)),
        ),
      ],
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withOpacity(0.3),
      inactiveThumbColor: AppColors.editorForeground.withOpacity(0.6),
      inactiveTrackColor: AppColors.editorForeground.withOpacity(0.2),
    );
  }
} 