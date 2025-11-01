import 'package:flutter/material.dart';
import '../models/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodTile extends StatelessWidget {
  final MoodEntry entry;
  MoodTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().format(entry.date);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        leading: Text(entry.emoji, style: TextStyle(fontSize: 30)),
        title: Text(date),
        subtitle: entry.note.isNotEmpty ? Text(entry.note) : null,
        trailing: Text(_labelForScore(entry.score)),
      ),
    );
  }

  String _labelForScore(int s) {
    if (s >= 4) return 'Positive';
    if (s == 3) return 'Neutral';
    return 'Negative';
  }
}
