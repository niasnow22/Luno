import 'package:flutter/material.dart';
import 'package:luno/db/cart_database.dart';
import 'package:luno/db/favorites_data.dart'; // ✅ Correct path to favorite_database.dart
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Sembast databases
  await CartDatabase.instance.init();
  await FavoriteDatabase.instance.init(); // ✅ Initialize favorites DB

  runApp(const Luno());
}

class Luno extends StatelessWidget {
  const Luno({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
