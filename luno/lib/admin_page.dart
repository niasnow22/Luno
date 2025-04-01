// ----------------------------
// admin_page.dart
// ----------------------------

import 'package:flutter/material.dart';
import '../db/sembast_user_database.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final db = SembastUserDatabase();
  List<Map<String, dynamic>> logins = [];

  @override
  void initState() {
    super.initState();
    loadLoginHistory();
  }

  Future<void> loadLoginHistory() async {
    final history = await db.getLoginHistory();
    setState(() {
      logins = history.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login History'),
        backgroundColor: const Color(0xFF00C28D),
      ),
      body: logins.isEmpty
          ? const Center(child: Text('No login history yet.'))
          : ListView.builder(
              itemCount: logins.length,
              itemBuilder: (context, index) {
                final item = logins[index];
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: Text(item['email']),
                  subtitle: Text(item['timestamp']),
                );
              },
            ),
    );
  }
}
