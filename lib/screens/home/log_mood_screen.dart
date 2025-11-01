import 'package:flutter/material.dart';
import '../../models/mood_entry.dart';
import '../../services/local_storage_service.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/mood_selector.dart';
import 'package:uuid/uuid.dart';

import 'home_screen.dart';
class LogMoodScreen extends StatefulWidget {
  @override
  _LogMoodScreenState createState() => _LogMoodScreenState();
}

class _LogMoodScreenState extends State<LogMoodScreen> {
  String? _selectedEmoji;
  final _noteCtrl = TextEditingController();
  final _local = LocalStorageService();
  final _fire = FirestoreService();
  final _auth = AuthService();
  bool _saving = false;

  int _scoreForEmoji(String emoji) {
    switch (emoji) {
      case '😄': return 5;
      case '🙂': return 4;
      case '😐': return 3;
      case '😕': return 2;
      case '😞': return 1;
      default: return 3;
    }
  }

  void _submit() async {
    if (_selectedEmoji == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose a mood')),
      );
      return;
    }

    setState(() => _saving = true);

    final id = Uuid().v4();
    final entry = MoodEntry(
      id: id,
      date: DateTime.now(),
      emoji: _selectedEmoji!,
      note: _noteCtrl.text.trim(),
      score: _scoreForEmoji(_selectedEmoji!),
    );

    await _local.addEntry(entry);

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _fire.saveEntry(user.uid, entry);
      } catch (e) {
        print('Firestore save error: $e');
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mood entry saved!')),
    );

    print('Navigating to HomeScreen...');
    Navigator.of(context).pushNamedAndRemoveUntil(
      HomeScreen.routeName,
          (route) => false,
    );

  }


  @override
  Widget build(BuildContext context) {
    final dateStr = DateTime.now().toLocal().toString().split(' ')[0];
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today — $dateStr', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16),
          MoodSelector(
            selectedEmoji: _selectedEmoji,
            onSelected: (e) => setState(() => _selectedEmoji = e),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(labelText: 'Optional note', border: OutlineInputBorder()),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _saving ? null : _submit,
            icon: Icon(Icons.save),
            label: _saving ? CircularProgressIndicator() : Text('Save entry'),
          ),
        ],
      ),
    );
  }
}
