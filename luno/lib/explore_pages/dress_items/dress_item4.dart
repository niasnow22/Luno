import 'package:flutter/material.dart';
import 'package:luno/home_screen.dart';
import 'package:luno/account_page.dart';
import 'package:luno/search_screen.dart';
import 'package:luno/shopping_cart.dart';
import 'package:luno/db/cart_database.dart';
import 'dress_screen.dart';
import 'package:luno/db/favorites_data.dart';
import 'package:luno/models/product.dart' as model;
import 'package:luno/favorites_screens.dart';

class DressItem4Screen extends StatefulWidget {
  final String name;

  const DressItem4Screen({super.key, required this.name});

  @override
  State<DressItem4Screen> createState() => _DressItem4ScreenState();
}

class _DressItem4ScreenState extends State<DressItem4Screen> {
  final Color accentColor = const Color(0xFF00C28D);
  final Color outlineColor = Colors.black.withOpacity(0.2);

  String selectedColor = 'Black';
  String selectedSize = 'Small';
  bool isFavorite = false;

  final List<String> colors = ['Black', 'White', 'Red'];
  final List<String> sizes = ['Small', 'Medium', 'Large'];

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    bool status = await FavoriteDatabase.instance.isFavorite('Flower Dress');
    setState(() {
      isFavorite = status;
    });
  }

  Future<void> _toggleFavorite() async {
    final product = model.Product(
      name: 'Flower Dress',
      price: 30.00,
      dateAdded: DateTime.now(),
      popularity: 80,
      imagePath: 'assets/images/dress_4.png',
      size: selectedSize,
      color: selectedColor,
    );

    if (isFavorite) {
      await FavoriteDatabase.instance.removeFavorite(product.name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from favorites")),
      );
    } else {
      await FavoriteDatabase.instance.addFavorite(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to favorites")),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> _addToCart() async {
    await CartDatabase.instance.addItem({
      'name': 'Flower Dress',
      'price': 30.00,
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
                          builder: (_) => DressScreen(name: widget.name),
                        ),
                      );
                    },
                  ),
                ),
                const Text(
                  'Flower Dress',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 0.75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/dress_4.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '\$30.00',
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
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: accentColor,
                        ),
                        onPressed: _toggleFavorite,
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
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => FavoritesScreen(name: widget.name)),
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
