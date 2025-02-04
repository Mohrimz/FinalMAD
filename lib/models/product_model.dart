class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String imagePath;
  final String description;
  bool isFavorite;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.description,
    this.isFavorite = false,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert API response to Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'] ?? 'Shoes',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      rating: double.tryParse(json['rating'].toString()) ?? 4.6, // Default to 4.6
      imagePath: json['target_file'] ?? '',
      description: json['description'] ?? 'No description available',
      stock: json['stock'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Convert Product object to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price.toString(),
      'rating': rating.toString(),
      'target_file': imagePath,
      'description': description,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
