import 'package:flutter/material.dart';
class ThemeToggle extends StatelessWidget {
  final ThemeMode currentMode;
  final Function(ThemeMode) onChanged;

  const ThemeToggle({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          icon: Icon(Icons.computer_outlined),
          label: Text('System'),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_outlined),
          label: Text('Light'),
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_outlined),
          label: Text('Dark'),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        onChanged(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
        selectedForegroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
