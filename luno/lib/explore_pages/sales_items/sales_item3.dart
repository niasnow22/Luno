import 'package:flutter/material.dart';
import 'package:luno/home_screen.dart';
import 'package:luno/account_page.dart';
import 'package:luno/search_screen.dart';
import 'package:luno/shopping_cart.dart';
import 'package:luno/db/cart_database.dart'; // make sure this exists
import 'sales_screen.dart';

class SalesItem3Screen extends StatefulWidget {
  final String name;

  const SalesItem3Screen({super.key, required this.name});

  @override
  State<SalesItem3Screen> createState() => _SalesItem3ScreenState();
}

class _SalesItem3ScreenState extends State<SalesItem3Screen> {
  final Color accentColor = const Color(0xFF00C28D);
  final Color outlineColor = Colors.black.withOpacity(0.2);

  String selectedColor = 'Black';
  String selectedSize = 'Small';

  final List<String> colors = ['Black', 'White', 'Red'];
  final List<String> sizes = ['Small', 'Medium', 'Large'];

  Future<void> _addToCart() async {
    await CartDatabase.instance.addItem({
      'name': 'Leather Fur Jacket',
      'price': 40.00,
      'size': selectedSize,
      'color': selectedColor,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SalesScreen(name: widget.name),
                          ),
                        );
                      },
                    ),
                  ),
                  const Text(
                    'Leather Fur Jacket',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 0.75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/sales_3.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  '\$40.00',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Color', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                _buildOptionSelector(colors, selectedColor, (val) {
                  setState(() => selectedColor = val);
                }),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Size', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                _buildOptionSelector(sizes, selectedSize, (val) {
                  setState(() => selectedSize = val);
                }),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: accentColor),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to favorites")),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _addToCart,
                        child: const Text('Add to Cart', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(name: widget.name)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(name: widget.name)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ShoppingCart(name: widget.name)),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AccountScreen(name: widget.name)),
              );
              break;
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

  Widget _buildOptionSelector(
    List<String> options,
    String selected,
    Function(String) onSelect,
  ) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? accentColor.withOpacity(0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
