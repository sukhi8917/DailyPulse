import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedEmoji;
  final ValueChanged<String> onSelected;

  MoodSelector({this.selectedEmoji, required this.onSelected});

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😄', 'score': 5},
    {'emoji': '🙂', 'score': 4},
    {'emoji': '😐', 'score': 3},
    {'emoji': '😕', 'score': 2},
    {'emoji': '😞', 'score': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: moods.map((m) {
        final emoji = m['emoji'] as String;
        final isSelected = selectedEmoji == emoji;
        return GestureDetector(
          onTap: () => onSelected(emoji),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(isSelected ? 12 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Colors.transparent,
            ),
            child: Text(emoji, style: TextStyle(fontSize: isSelected ? 34 : 28)),
          ),
        );
      }).toList(),
    );
  }
}
