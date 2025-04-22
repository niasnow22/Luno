import 'package:flutter/material.dart';
import 'package:luno/home_screen.dart';
import 'package:luno/account_page.dart';
import 'package:luno/explore_pages/shirts_items/shirts_screen.dart';
import 'package:luno/explore_pages/pants_items/pants_screen.dart';
import 'package:luno/explore_pages/dress_items/dress_screen.dart';
import 'package:luno/explore_pages/sales_items/sales_screen.dart';
import 'shoes_item1.dart';
import 'shoes_item2.dart';
import 'shoes_item3.dart';
import 'shoes_item4.dart';

class Product {
  final String name;
  final double price;
  final DateTime dateAdded;
  final int popularity;
  final String imagePath;

  Product({
    required this.name,
    required this.price,
    required this.dateAdded,
    required this.popularity,
    required this.imagePath,
  });
}

class ShoesScreen extends StatefulWidget {
  final String name;

  const ShoesScreen({super.key, required this.name});

  @override
  State<ShoesScreen> createState() => _ShoesScreenState();
}

class _ShoesScreenState extends State<ShoesScreen> {
  String _selectedSort = 'Popularity';
  RangeValues _selectedPriceRange = const RangeValues(0, 100);

  final List<String> sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest'
  ];

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    products = [
      Product(
        name: 'Blue Kitten Heels',
        price: 20.0,
        dateAdded: DateTime.now(),
        popularity: 90,
        imagePath: 'assets/images/shoes_1.png',
      ),
      Product(
        name: 'Black Bow Heels',
        price: 30.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
        popularity: 80,
        imagePath: 'assets/images/shoes_2.png',
      ),
      Product(
        name: 'Opened Toed Heels',
        price: 40.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        popularity: 70,
        imagePath: 'assets/images/shoes_3.png',
      ),
      Product(
        name: 'High Heeled Boots',
        price: 50.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
        popularity: 60,
        imagePath: 'assets/images/shoes_4.png',
      ),
    ];
  }

  List<Product> get filteredAndSortedProducts {
    List<Product> filtered = products.where((product) {
      return product.price >= _selectedPriceRange.start &&
          product.price <= _selectedPriceRange.end;
    }).toList();

    switch (_selectedSort) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      default:
        filtered.sort((a, b) => b.popularity.compareTo(a.popularity));
        break;
    }

    return filtered;
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter by Price', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  RangeSlider(
                    values: _selectedPriceRange,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    labels: RangeLabels(
                      '\$${_selectedPriceRange.start.round()}',
                      '\$${_selectedPriceRange.end.round()}',
                    ),
                    onChanged: (RangeValues values) {
                      setModalState(() => _selectedPriceRange = values);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = const Color(0xFF00C28D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'Shoes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor),
            ),
            const SizedBox(height: 12),

            // Navigation Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  {'label': 'Sales', 'screen': SalesScreen(name: widget.name)},
                  {'label': 'Shirts', 'screen': ShirtScreen(name: widget.name)},
                  {'label': 'Pants', 'screen': PantsScreen(name: widget.name)},
                  {'label': 'Dresses', 'screen': DressScreen(name: widget.name)},
                  {'label': 'Shoes', 'screen': null},
                ].map((item) {
                  final isCurrent = item['screen'] == null;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (!isCurrent) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                          );
                        }
                      },
                      child: Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          color: isCurrent ? accentColor : Colors.black,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Sort & Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sort),
                      const SizedBox(width: 4),
                      DropdownButton<String>(
                        value: _selectedSort,
                        items: sortOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSort = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _openFilterModal,
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list),
                        SizedBox(width: 4),
                        Text('Filter'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Product Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredAndSortedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = filteredAndSortedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      if (product.name == 'Blue Kitten Heels') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShoesItem1Screen(name: widget.name)));
                      } else if (product.name == 'Black Bow Heels') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShoesItem2Screen(name: widget.name)));
                      } else if (product.name == 'Opened Toed Heels') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShoesItem3Screen(name: widget.name)));
                      } else if (product.name == 'High Heeled Boots') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ShoesItem4Screen(name: widget.name)));
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product.imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                        Text('Popularity: ${product.popularity}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(name: widget.name)),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen(name: widget.name)),
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
}
