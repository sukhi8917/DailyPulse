import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import '../../models/mood_entry.dart';
import 'dart:collection';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _local = LocalStorageService();
  bool _loading = true;
  List<MoodEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final e = await _local.loadEntries();
    setState(() { _entries = e; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());
    final total = _entries.length;
    final positive = _entries.where((e) => e.score >= 4).length;
    final neutral = _entries.where((e) => e.score == 3).length;
    final negative = _entries.where((e) => e.score <= 2).length;
    final mostCommonEmoji = _mostCommonEmoji(_entries);

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12),
          Text('Total entries: $total'),
          Text('Positive: $positive'),
          Text('Neutral: $neutral'),
          Text('Negative: $negative'),
          SizedBox(height: 12),
          Text('Most common mood: ${mostCommonEmoji ?? "—"}', style: TextStyle(fontSize: 22)),
          SizedBox(height: 12),
          ElevatedButton(onPressed: _load, child: Text('Refresh')),
        ],
      ),
    );
  }

  String? _mostCommonEmoji(List<MoodEntry> list) {
    if (list.isEmpty) return null;
    final freq = HashMap<String, int>();
    for (var e in list) freq[e.emoji] = (freq[e.emoji] ?? 0) + 1;
    String best = list.first.emoji;
    int bestCount = 0;
    freq.forEach((k, v) {
      if (v > bestCount) {
        best = k;
        bestCount = v;
      }
    });
    return best;
  }
}
