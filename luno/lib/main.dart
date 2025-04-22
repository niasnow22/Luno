import 'package:flutter/material.dart';
import 'package:luno/db/cart_database.dart'; // adjust path if needed
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartDatabase.instance.init(); // Make sure the DB is ready
  runApp(const Luno());
}

class Luno extends StatelessWidget {
  const Luno({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
