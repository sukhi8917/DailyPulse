import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'log_mood_screen.dart';
import 'history_screen.dart';
import 'analytics_screen.dart';
import 'mood_trends_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 1;
  final _pages = [
    LogMoodScreen(),
    HistoryScreen(),
    CalendarScreen(),
    AnalyticsScreen(),
    MoodTrendsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DailyPulse'),
      ),
      body: _pages[_index],
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.edit),
                backgroundColor: Colors.blue,
                label: 'Log'),
            BottomNavigationBarItem(icon: Icon(Icons.history),
                backgroundColor: Colors.blue,label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today),
                backgroundColor: Colors.blue,
                label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.insights),
                backgroundColor: Colors.blue,label: 'Analytics'),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              backgroundColor: Colors.blue,
              label: 'Trends',
            ),

            BottomNavigationBarItem(icon: Icon(Icons.settings),
                backgroundColor: Colors.blue,label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
