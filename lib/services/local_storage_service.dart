import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_entry.dart';

class LocalStorageService {
  static const _entriesKey = 'mood_entries';

  Future<void> saveEntries(List<MoodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setStringList(_entriesKey, jsonList);
  }

  Future<List<MoodEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_entriesKey) ?? [];
    return list.map((s) => MoodEntry.fromJson(s)).toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // latest first
  }

  Future<void> addEntry(MoodEntry entry) async {
    final entries = await loadEntries();
    entries.insert(0, entry);
    await saveEntries(entries);
  }

  Future<void> clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_entriesKey);
  }
}
