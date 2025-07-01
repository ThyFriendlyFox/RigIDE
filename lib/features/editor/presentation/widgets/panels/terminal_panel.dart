import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';

// Provider for terminal output
final terminalOutputProvider = StateNotifierProvider<TerminalOutputNotifier, List<String>>((ref) {
  return TerminalOutputNotifier();
});

class TerminalOutputNotifier extends StateNotifier<List<String>> {
  TerminalOutputNotifier() : super([
    'RigIDE Terminal v1.0.0',
    'Type "help" for available commands',
    '',
  ]);

  void addOutput(String output) {
    state = [...state, output];
  }

  void executeCommand(String command) {
    // Add the command to output
    state = [...state, '\$ $command'];
    
    // Process the command
    switch (command.trim().toLowerCase()) {
      case 'help':
        addOutput('Available commands:');
        addOutput('  help     - Show this help message');
        addOutput('  clear    - Clear terminal output');
        addOutput('  pwd      - Print working directory');
        addOutput('  ls       - List files in current directory');
        addOutput('  flutter  - Flutter commands (flutter --version, flutter run, etc.)');
        break;
      case 'clear':
        state = [];
        break;
      case 'pwd':
        addOutput('/Users/user/Projects/RigIDE');
        break;
      case 'ls':
        addOutput('android/  ios/  lib/  macos/  pubspec.yaml  README.md');
        break;
      case 'flutter --version':
        addOutput('Flutter 3.32.5 • channel stable');
        addOutput('Framework • revision fcf2c11572');
        addOutput('Engine • revision dd93de6fb1');
        addOutput('Tools • Dart 3.8.1 • DevTools 2.45.1');
        break;
      case 'flutter run':
        addOutput('Launching lib/main.dart on macOS in debug mode...');
        addOutput('✓ Built build/macos/Build/Products/Debug/RigIDE.app');
        break;
      default:
        if (command.trim().isNotEmpty) {
          addOutput('bash: $command: command not found');
        }
        break;
    }
    
    // Add empty line for spacing
    if (command.trim().isNotEmpty) {
      addOutput('');
    }
  }

  void clear() {
    state = [];
  }
}

class TerminalPanel extends ConsumerStatefulWidget {
  const TerminalPanel({super.key});

  @override
  ConsumerState<TerminalPanel> createState() => _TerminalPanelState();
}

class _TerminalPanelState extends ConsumerState<TerminalPanel> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _executeCommand() {
    final command = _inputController.text;
    ref.read(terminalOutputProvider.notifier).executeCommand(command);
    _inputController.clear();
    
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final terminalOutput = ref.watch(terminalOutputProvider);
    
    return Container(
      color: const Color(0xFF1E1E1E), // Darker terminal background
      child: Column(
        children: [
          // Terminal header
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D30),
              border: Border(
                bottom: BorderSide(color: AppColors.panelBorder, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal,
                  size: 16,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Terminal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Clear button
                GestureDetector(
                  onTap: () => ref.read(terminalOutputProvider.notifier).clear(),
                  child: const Icon(
                    Icons.clear_all,
                    size: 16,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          
          // Terminal output
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Output area
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: terminalOutput.length,
                      itemBuilder: (context, index) {
                        final line = terminalOutput[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            line,
                            style: TextStyle(
                              color: line.startsWith('\$') 
                                  ? Colors.green.shade300 
                                  : Colors.white,
                              fontSize: 13,
                              fontFamily: 'Courier',
                              height: 1.3,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Input area
                  Row(
                    children: [
                      Text(
                        '\$ ',
                        style: TextStyle(
                          color: Colors.green.shade300,
                          fontSize: 13,
                          fontFamily: 'Courier',
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _inputController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Courier',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onSubmitted: (_) => _executeCommand(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 