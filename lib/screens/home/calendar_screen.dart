import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/mood_entry.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/mood_tile.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _local = LocalStorageService();
  late Map<DateTime, List<MoodEntry>> _moodMap = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await _local.loadEntries();
    setState(() {
      _moodMap = {};
      for (var e in entries) {
        final date = DateTime(e.date.year, e.date.month, e.date.day);
        _moodMap.putIfAbsent(date, () => []).add(e);
      }
    });
  }

  List<MoodEntry> _getMoodsForDay(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return _moodMap[d] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood Calendar')),
      body: _moodMap == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          TableCalendar<MoodEntry>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),
            eventLoader: _getMoodsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? Center(child: Text('Select a date to view moods'))
                : _getMoodsForDay(_selectedDay!).isEmpty
                ? Center(child: Text('No mood logged on this day'))
                : ListView(
              children: _getMoodsForDay(_selectedDay!)
                  .map((e) => MoodTile(entry: e))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
