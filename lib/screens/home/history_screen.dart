import 'package:flutter/material.dart';
import '../../models/mood_entry.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/mood_tile.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _local = LocalStorageService();
  List<MoodEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final e = await _local.loadEntries();
    setState(() {
      _entries = e;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());
    if (_entries.isEmpty) return Center(child: Text('No entries yet — log your mood today!'));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _entries.length,
        itemBuilder: (context, i) {
          final entry = _entries[i];
          return MoodTile(entry: entry);
        },
      ),
    );
  }
}
