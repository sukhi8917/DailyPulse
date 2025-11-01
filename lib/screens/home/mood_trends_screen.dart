import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../services/local_storage_service.dart';
import '../../models/mood_entry.dart';
import 'dart:math';

class MoodTrendsScreen extends StatefulWidget {
  const MoodTrendsScreen({Key? key}) : super(key: key);

  @override
  _MoodTrendsScreenState createState() => _MoodTrendsScreenState();
}

class _MoodTrendsScreenState extends State<MoodTrendsScreen> {
  final _local = LocalStorageService();
  List<MoodEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final entries = await _local.loadEntries();
    // Sort by date ascending
    entries.sort((a, b) => a.date.compareTo(b.date));
    setState(() => _entries = entries);
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No mood data yet.")),
      );
    }

    // Convert entries to FlSpots: X = index, Y = score (1..5)
    final spots = _entries.asMap().entries.map((entryPair) {
      final idx = entryPair.key.toDouble();
      final score = entryPair.value.score.toDouble();
      return FlSpot(idx, score);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Mood Trends")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            backgroundColor: Colors.white,
            minY: 1,
            maxY: 5,
            gridData: FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: max(1, _entries.length / 5),
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= _entries.length) return const SizedBox.shrink();
                    final date = _entries[index].date;
                    return Text(
                      "${date.day}/${date.month}",
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
