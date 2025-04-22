import 'package:flutter/material.dart';
import 'package:luno/home_screen.dart';
import 'package:luno/account_page.dart';
import '../sales_items/sales_screen.dart';
import '../dress_items/dress_screen.dart';
import '../shirts_items/shirts_screen.dart';
import '../shoes_items/shoes_screen.dart';
import 'pants_item1.dart';
import 'pants_item2.dart';
import 'pants_item3.dart';
import 'pants_item4.dart';

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

class PantsScreen extends StatefulWidget {
  final String name;

  const PantsScreen({super.key, required this.name});

  @override
  State<PantsScreen> createState() => _PantsScreenState();
}

class _PantsScreenState extends State<PantsScreen> {
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
        name: 'Slacks',
        price: 32.0,
        dateAdded: DateTime.now(),
        popularity: 100,
        imagePath: 'assets/images/pants_1.png',
      ),
      Product(
        name: 'Jean Shorts',
        price: 28.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
        popularity: 90,
        imagePath: 'assets/images/pants_2.png',
      ),
      Product(
        name: 'Skirt',
        price: 24.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
        popularity: 80,
        imagePath: 'assets/images/pants_3.png',
      ),
      Product(
        name: 'Jeans',
        price: 30.0,
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
        popularity: 70,
        imagePath: 'assets/images/pants_4.png',
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
                  const Text('Filter by Price',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              'Pants',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: accentColor),
            ),
            const SizedBox(height: 12),

            // Category Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  {'label': 'Sales', 'screen': SalesScreen(name: widget.name)},
                  {'label': 'Shirts', 'screen': ShirtScreen(name: widget.name)},
                  {'label': 'Pants', 'screen': null},
                  {'label': 'Dresses', 'screen': DressScreen(name: widget.name)},
                  {'label': 'Shoes', 'screen': ShoesScreen(name: widget.name)},
                ].map((item) {
                  final isCurrent = item['screen'] == null;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (!isCurrent) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => item['screen'] as Widget,
                            ),
                          );
                        }
                      },
                      child: Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          color: isCurrent ? accentColor : Colors.black,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Sort & Filter Row
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
                      if (product.name == 'Slacks') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PantsItem1Screen(name: widget.name)),
                        );
                      } else if (product.name == 'Jean Shorts') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PantsItem2Screen(name: widget.name)),
                        );
                      } else if (product.name == 'Skirt') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PantsItem3Screen(name: widget.name)),
                        );
                      } else if (product.name == 'Jeans') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  PantsItem4Screen(name: widget.name)),
                        );
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
                        Text(product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
              MaterialPageRoute(
                  builder: (context) => HomeScreen(name: widget.name)),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AccountScreen(name: widget.name)),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
