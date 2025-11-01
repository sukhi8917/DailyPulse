import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = AuthService();

  void _signOut() async {
    await _auth.signOut();
    // Restart to login, or pop to root; for simplicity:
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          if (user != null) Text('Signed in as ${user.email}'),
          SizedBox(height: 12),
          ElevatedButton.icon(onPressed: _signOut, icon: Icon(Icons.logout), label: Text('Sign out')),
        ],
      ),
    );
  }
}
