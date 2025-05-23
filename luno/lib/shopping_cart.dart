import 'package:flutter/material.dart';
import 'package:luno/home_screen.dart';
import 'package:luno/account_page.dart';
import 'package:luno/search_screen.dart';
import 'package:luno/db/cart_database.dart';

class ShoppingCart extends StatefulWidget {
  final String name;
  final Map<String, dynamic>? newItem;

  const ShoppingCart({super.key, required this.name, this.newItem});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final Color accentColor = const Color(0xFF00C28D);
  List<Map<String, dynamic>> cartItems = [];
  List<int> itemKeys = [];

  @override
  void initState() {
    super.initState();
    _initCart();
  }

  Future<void> _initCart() async {
    if (widget.newItem != null) {
      await CartDatabase.instance.addItem(widget.newItem!);
    }
    await _loadCart();
  }

  Future<void> _loadCart() async {
    final items = await CartDatabase.instance.getItems();
    final keys = await CartDatabase.instance.getRawKeys();
    setState(() {
      cartItems = items;
      itemKeys = keys;
    });
  }

  Future<void> _removeItem(int index) async {
    await CartDatabase.instance.removeItem(itemKeys[index]);
    await _loadCart();
  }

  double get total => cartItems.fold(0, (sum, item) => sum + (item['price'] ?? 0));
  double get taxes => total * 0.07;
  double get shipping => total >= 50 ? 0.0 : 5.0;
  double get subtotal => total + taxes + shipping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${widget.name}'s Shopping Cart",
                    style: TextStyle(
                      fontSize: 20,
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (cartItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text("Your cart is empty")),
                  ),

                ...cartItems.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> item = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Container(width: 70, height: 70, color: Colors.grey[300]),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Size: ${item['size']}', style: const TextStyle(color: Colors.black54)),
                              if (item.containsKey('color'))
                                Text('Color: ${item['color']}', style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "\$${item['price'].toStringAsFixed(2)}",
                              style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                if (cartItems.isNotEmpty)
                  Column(
                    children: [
                      _lineItem("Total", total),
                      _lineItem("Taxes (7%)", taxes),
                      _lineItem("Shipping", shipping),
                      _lineItem("Subtotal", subtotal, bold: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Checkout total: \$${subtotal.toStringAsFixed(2)}')),
                            );
                          },
                          child: const Text('Check Out'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen(name: widget.name)),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchScreen(name: widget.name)),
              );
              break;
            case 2:
              break;
            case 3:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Favorites coming soon')),
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

  Widget _lineItem(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: accentColor,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
