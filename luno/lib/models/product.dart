class Product {
  final String name;
  final double price;
  final DateTime dateAdded;
  final int popularity;
  final String imagePath;
  final String size;
  final String color;

  Product({
    required this.name,
    required this.price,
    required this.dateAdded,
    required this.popularity,
    required this.imagePath,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'dateAdded': dateAdded.toIso8601String(),
    'popularity': popularity,
    'imagePath': imagePath,
    'size': size,
    'color': color,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'],
    price: json['price'],
    dateAdded: DateTime.parse(json['dateAdded']),
    popularity: json['popularity'],
    imagePath: json['imagePath'],
    size: json['size'],
    color: json['color'],
  );
}

