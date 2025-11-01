import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _themeMode = t == 'light' ? ThemeMode.light : t == 'dark' ? ThemeMode.dark : ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final isLoggedIn = snapshot.data != null;

        return MaterialApp(
          title: 'DailyPulse',
          theme: ThemeData.light().copyWith(
            useMaterial3: true,
            textTheme:
            Theme.of(context).textTheme.apply(fontFamily: 'GoogleSans'),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: _themeMode,
          debugShowCheckedModeBanner: false,
          routes: {
            '/login': (_) => LoginScreen(),
            '/signup': (_) => SignupScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
          },
          home: isLoggedIn ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
