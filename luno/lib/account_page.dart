import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AccountScreen extends StatelessWidget {
  final String name;

  const AccountScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF00C28D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hello, $name',
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              buildAccountButton(
                context,
                icon: Icons.inventory_2_outlined,
                label: 'Order History',
                onTap: () {
                  //TODO - Navigate to order history screen
                  print('Order History tapped');
                },
              ),

              const SizedBox(height: 16), 

              buildAccountButton(
                context,
                icon: Icons.settings,
                label: 'Account Settings',
                onTap: () {
                  //TODO Navigate to settings
                  print('Account Settings tapped');
                },
              ),

              const SizedBox(height: 16),

              buildAccountButton(
                context,
                icon: Icons.credit_card_outlined,
                label: 'Payment Methods',
                onTap: () {
                  //TODO Navigate to Payment
                  print('Payment Methods tapped');
                },
              ),

              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  //GO back to login 
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 4, // Account tab selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(name: name)),
            );
          } else {
            // Handle other navigation taps if necessary
            print('Tapped nav index: \$index');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget buildAccountButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF00C28D)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
