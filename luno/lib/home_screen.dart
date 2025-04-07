// ----------------------------
// home_screen.dart (Explore Layout + Admin Access with Category Navigation)
// ----------------------------

import 'package:flutter/material.dart';
import 'package:luno/sales_screen.dart';
import 'search_screen.dart';
import 'shirts_screen.dart';
import 'pants_screen.dart';
import 'dress_screen.dart';
import 'shoes_screen.dart';
import 'admin_page.dart';
import 'account_page.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF00C28D);
    final screenWidth = MediaQuery.of(context).size.width;
    final double boxWidth = (screenWidth - 52) / 2; // 2 boxes per row with padding

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        {'label': 'Sales', 'screen': SalesScreen(name: name)},
                        {'label': 'Shirts', 'screen': ShirtScreen(name: name)},
                        {'label': 'Pants', 'screen': PantsScreen(name: name)},
                        {'label': 'Dresses', 'screen': DressScreen(name: name)},
                        {'label': 'Shoes', 'screen': ShoesScreen(name: name)},
                      ].map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                              );
                            },
                            child: Text(
                              item['label'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesScreen(name: name),
                        ),
                      );
                    },
                    child: buildCategoryBox('Sales', accentColor, height: 180),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShirtScreen(name: name),
                            ),
                          );
                        },
                        child: buildCategoryBox('Shirts', accentColor, width: boxWidth),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PantsScreen(name: name),
                            ),
                          );
                        },
                        child: buildCategoryBox('Pants', accentColor, width: boxWidth),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DressScreen(name: name),
                            ),
                          );
                        },
                        child: buildCategoryBox('Dresses', accentColor, width: boxWidth),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShoesScreen(name: name),
                            ),
                          );
                        },
                        child: buildCategoryBox('Shoes', accentColor, width: boxWidth),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPage()),
                  );
                },
                child: Icon(Icons.admin_panel_settings, color: Colors.grey[600], size: 24),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  selectedItemColor: accentColor,
  unselectedItemColor: Colors.grey,
  showUnselectedLabels: true,
  currentIndex: 0, // Change this per screen for highlighting
  onTap: (index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(name: name),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountScreen(name: name),
        ),
      );
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

  Widget buildCategoryBox(String title, Color color, {double? width, double? height}) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 100,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}